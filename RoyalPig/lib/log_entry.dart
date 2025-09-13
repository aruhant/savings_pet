import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:goals/martian_service.dart';
import 'package:goals/user.dart';
import 'package:flutter/material.dart'; // Assuming Flutter is used for UI

class LogEntry {
  String? text, sender, category, time, recepient, type, merchant;
  String key;
  double? amount;

  LogEntry({
    this.text,
    this.sender,
    this.category,
    this.time,
    this.type,
    this.amount,
    this.merchant,
    String? recepient,
    String? key,
  }) : key = key ?? DateTime.now().millisecondsSinceEpoch.toString(),
       recepient = recepient ?? "demo_user";

  factory LogEntry.fromDBValue(Map<String, AttributeValue> dbValue) {
    print("LogEntry fromDBValue: $dbValue");
    print('amount: ${dbValue["amount"]?.s}');
    return LogEntry(
      text: dbValue["text"]!.s!,
      sender: dbValue["sender"]!.s!,
      category: dbValue["category"]!.s!,
      key: dbValue["key"]!.s!,
      time: dbValue["time"]!.s!,
      recepient: dbValue["recepient"]!.s!,
      merchant: dbValue["merchant"]?.s,
      type: dbValue["type"]?.s,
      amount: dbValue["amount"]?.n != null
          ? double.tryParse(dbValue["amount"]!.n!)
          : (dbValue["amount"]?.s != null
                ? double.tryParse(dbValue["amount"]!.s!)
                : null),
    );
  }

  Map<String, AttributeValue> toDBValue() {
    Map<String, AttributeValue> dbMap = Map();
    dbMap["text"] = AttributeValue(s: text);
    dbMap["sender"] = AttributeValue(s: sender);
    dbMap["category"] = AttributeValue(s: category);
    dbMap["time"] = AttributeValue(s: time);
    dbMap["merchant"] = AttributeValue(s: merchant);
    dbMap["key"] = AttributeValue(s: key);
    dbMap["recepient"] = AttributeValue(s: recepient);
    if (type != null) dbMap["type"] = AttributeValue(s: type);
    if (amount != null) dbMap["amount"] = AttributeValue(n: amount!.toString());
    return dbMap;
  }

  static fromJson(Map<String, dynamic> json) {
    print("LogEntry fromJson: $json");
    return LogEntry.fromDBValue(
      json.map(
        (key, value) => MapEntry(key, AttributeValue(s: value.toString())),
      ),
    );
  }

  String toString() {
    return 'Message{text: $text, sender: $sender, category: $category, time: $time, key: $key, recepient: $recepient, type: $type, amount: $amount}';
  }

  Future<void> classify() async {
    Map result = await MartianService.processSMS(text!);
    category = result['category'] ?? 'Other';
    amount = result['amount'] != null
        ? double.tryParse(result['amount'].toString())
        : null;
    type = 'expense';
    merchant = result['merchant'] ?? 'Unknown';

    print("Martian result: $result");
  }
}

class LogEntryWidget extends StatelessWidget {
  final LogEntry logEntry;

  const LogEntryWidget({Key? key, required this.logEntry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CategoryIcon(category: logEntry.category ?? 'Other'),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8.0),
                  Text(_formatDateTime(logEntry.time ?? '')),
                  const SizedBox(height: 8.0),
                  Text(
                    '${logEntry.merchant ?? ''}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            if (logEntry.amount != null)
              Text(
                '\$${logEntry.amount!.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: logEntry.type == 'expense'
                      ? Colors.red.withAlpha(180)
                      : Colors.green.withAlpha(180),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(String s) {
    try {
      DateTime dt = DateTime.parse(s);
      List<String> months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      String month = months[dt.month - 1];
      String day = dt.day.toString();
      String year = dt.year.toString().substring(2);
      String hour = dt.hour > 12
          ? (dt.hour - 12).toString()
          : (dt.hour == 0 ? '12' : dt.hour.toString());
      String minute = dt.minute.toString().padLeft(2, '0');
      String period = dt.hour >= 12 ? 'PM' : 'AM';
      return '$day $month $year, $hour:$minute $period';
    } catch (e) {
      return s;
    }
  }
}

class CategoryIcon extends StatelessWidget {
  final String category;

  const CategoryIcon({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    switch (category.toLowerCase()) {
      case 'food':
        iconData = Icons.restaurant;
        break;
      case 'shopping':
        iconData = Icons.shopping_cart;
        break;
      case 'entertainment':
        iconData = Icons.movie;
        break;
      case 'bills':
        iconData = Icons.receipt;
        break;
      case 'transportation':
        iconData = Icons.directions_car;
        break;
      case 'salary':
        iconData = Icons.attach_money;
        break;
      default:
        iconData = Icons.category;
    }
    return Icon(iconData, size: 40, color: Colors.blue.withAlpha(180));
  }
}
