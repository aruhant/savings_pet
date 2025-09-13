import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';

class SocialStats {
  double min, max, spend;
  String month;
  String key;
  int seq;

  SocialStats({
    required this.min,
    required this.max,
    required this.month,
    required this.spend,
    required this.seq,
    required this.key,
  });

  factory SocialStats.fromDBValue(Map<String, AttributeValue> dbValue) {
    return SocialStats(
      key: dbValue["key"]!.s!,
      month: dbValue["month"]!.s!,
      min: double.parse(dbValue["min"]!.n!),
      max: double.parse(dbValue["max"]!.n!),
      spend: double.parse(dbValue["spend"]!.n!),
      seq: int.parse(dbValue["seq"]!.n!),
    );
  }

  Map<String, AttributeValue> toDBValue() {
    Map<String, AttributeValue> dbMap = Map();
    dbMap["key"] = AttributeValue(s: key);
    dbMap["month"] = AttributeValue(s: month);
    dbMap["min"] = AttributeValue(n: min.toString());
    dbMap["max"] = AttributeValue(n: max.toString());
    dbMap["spend"] = AttributeValue(n: spend.toString());
    dbMap["seq"] = AttributeValue(n: seq.toString());    
    return dbMap;
  }

  static fromJson(Map<String, dynamic> json) {
    return SocialStats.fromDBValue(
      json.map(
        (key, value) => MapEntry(key, AttributeValue(s: value.toString())),
      ),
    );
  }

  String toString() {
    return 'Stats(min: $min, max: $max, month: $month, spend: $spend, seq: $seq, key: $key)';
  }
}
