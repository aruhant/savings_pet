import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:goals/martian_service.dart';
import 'package:goals/user.dart';

class LogEntry {
  String? text, sender, category, time, recepient, type;
  String key;
  double? amount;

  LogEntry({
    this.text,
    this.sender,
    this.category,
    this.time,
    this.type,
    this.amount,
    String? recepient,
    String? key,
  }) : key = key ?? DateTime.now().millisecondsSinceEpoch.toString(),
       recepient = recepient ?? "demo_user";

  factory LogEntry.fromDBValue(Map<String, AttributeValue> dbValue) {
    return LogEntry(
      text: dbValue["text"]!.s!,
      sender: dbValue["sender"]!.s!,
      category: dbValue["category"]!.s!,
      key: dbValue["key"]!.s!,
      time: dbValue["time"]!.s!,
      recepient: dbValue["recepient"]!.s!,
      type: dbValue["type"]?.s,
      amount: dbValue["amount"]?.n != null
          ? double.tryParse(dbValue["amount"]!.n!)
          : null,
    );
  }

  Map<String, AttributeValue> toDBValue() {
    Map<String, AttributeValue> dbMap = Map();
    dbMap["text"] = AttributeValue(s: text);
    dbMap["sender"] = AttributeValue(s: sender);
    dbMap["category"] = AttributeValue(s: category);
    dbMap["time"] = AttributeValue(s: time);
    dbMap["key"] = AttributeValue(s: key);
    dbMap["recepient"] = AttributeValue(s: recepient);
    if (type != null) dbMap["type"] = AttributeValue(s: type);
    if (amount != null) dbMap["amount"] = AttributeValue(n: amount!.toString());
    return dbMap;
  }

  static fromJson(Map<String, dynamic> json) {
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

    print("Martian result: $result");
  }
}
