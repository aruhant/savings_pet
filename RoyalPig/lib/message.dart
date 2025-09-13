import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:goals/user.dart';

class Message {
  String? text, sender, category, time, recepient;
  String key;

  Message({
    this.text,
    this.sender,
    this.category,
    this.time,
    String? recepient,
    String? key,
  }) : key = key ?? DateTime.now().millisecondsSinceEpoch.toString(),
       recepient = recepient ?? "demo_user";

  factory Message.fromDBValue(Map<String, AttributeValue> dbValue) {
    return Message(
      text: dbValue["text"]!.s!,
      sender: dbValue["sender"]!.s!,
      category: dbValue["category"]!.s!,
      key: dbValue["key"]!.s!,
      time: dbValue["time"]!.s!,
      recepient: dbValue["recepient"]!.s!,
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
    return dbMap;
  }

  static fromJson(Map<String, dynamic> json) {
    return Message.fromDBValue(
      json.map(
        (key, value) => MapEntry(key, AttributeValue(s: value.toString())),
      ),
    );
  }

  String toString() {
    return 'Message{text: $text, sender: $sender, category: $category, time: $time, key: $key, recepient: $recepient}';
  }
}
