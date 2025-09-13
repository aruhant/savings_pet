import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:goals/secrets.dart';
import 'package:goals/user.dart';

class DynamoService {
  static final DynamoService _instance = DynamoService._internal();
  factory DynamoService() => _instance;
  DynamoService._internal();

  final service = DynamoDB(
    region: 'us-east-2',
    credentials: AwsClientCredentials(
      accessKey: AWSSecrets["accessKey"]!,
      secretKey: AWSSecrets["secretKey"]!,
    ),
  );

  Future<List<Map<String, AttributeValue>>?> getAll({
    required String tableName,
  }) async {
    var reslut = await service.scan(tableName: tableName);
    return reslut.items;
  }

  Future<T?> getItem<T>({
    required String tableName,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    final userID = AuthService.currentUserId;
    try {
      var result = await service.scan(
        tableName: tableName,
        filterExpression: 'userID = :uid',
        expressionAttributeValues: {':uid': AttributeValue(s: userID)},
      );
      if (result.items != null && result.items!.isNotEmpty) {
        return fromJson(
          result.items!.first.map(
            (key, value) =>
                MapEntry(key, value.s ?? value.n ?? value.b.toString()),
          ),
        );
      }
    } catch (e) {
      print('Error fetching item: $e');
    }
    return null;
  }

  Future insertNewItem(
    Map<String, AttributeValue> dbData,
    String tableName,
  ) async {
    dbData["userID"] = AttributeValue(s: AuthService.currentUserId);
    service.putItem(item: dbData, tableName: tableName);
  }
}
