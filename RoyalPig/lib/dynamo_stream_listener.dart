import 'dart:async';
import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:aws_dynamodbstreams_api/streams-dynamodb-2012-08-10.dart'
    as streams;
import 'package:goals/secrets.dart';
import 'package:goals/user.dart';

/// The type of change detected in the DynamoDB stream.
enum StreamEventType { insert, modify, remove }

/// Represents a single change event from the stream, deserialized to type [T].
class StreamEvent<T> {
  /// The type of event.
  final StreamEventType type;

  /// The new version of the item. Available for INSERT and MODIFY.
  final T? newItem;

  /// The old version of the item. Available for MODIFY and REMOVE.
  final T? oldItem;

  StreamEvent({required this.type, this.newItem, this.oldItem});
}

/// Defines the signature for the callback that handles a batch of stream events.
typedef StreamEventCallback<T> = void Function(List<StreamEvent<T>> events);

/// A generic listener for DynamoDB table streams.
class DynamoStreamListener<T> {
  final String tableName;
  final T Function(Map<String, dynamic> json) fromJson;

  final _credentials = AwsClientCredentials(
    accessKey: AWSSecrets["accessKey"]!,
    secretKey: AWSSecrets["secretKey"]!,
  );
  final String _region = 'us-east-2';
  late final DynamoDB _dynamoDB;
  late final streams.DynamoDBStreams _dynamoDBStreams;

  /// Creates a listener for a specific table.
  ///
  /// [tableName] is the name of the DynamoDB table to listen to.
  /// [fromJson] is a factory function that converts a JSON map to an object of type [T].
  DynamoStreamListener({required this.tableName, required this.fromJson}) {
    _dynamoDB = DynamoDB(region: _region, credentials: _credentials);
    _dynamoDBStreams = streams.DynamoDBStreams(
      region: _region,
      credentials: _credentials,
    );
  }

  Future<List<T>> get currentItems async {
    // return all current items from the table
    final userID = AuthService.currentUserId;
    final result = await _dynamoDB.scan(
      tableName: tableName,
      filterExpression: 'userID = :uid',
      expressionAttributeValues: {':uid': AttributeValue(s: userID)},
    );
    final items = <T>[];
    if (result.items != null) {
      for (final item in result.items!) {
        try {
          final convertedItem = _convertAttributeMap(item);
          items.add(fromJson(convertedItem));
        } catch (e) {
          print('Error converting item: $e');
        }
      }
    }
    return items;
  }

  /// Starts listening to the stream and invokes the callback with new events.
  Future<void> listen({required StreamEventCallback<T> onEvents}) async {
    print('Attempting to listen to stream for table: $tableName');

    try {
      final description = await _dynamoDB.describeTable(tableName: tableName);
      final streamArn = description.table?.latestStreamArn;

      if (streamArn == null) {
        print(
          'Error: Stream not enabled for table "$tableName" or table does not exist.',
        );
        return;
      }
      print('Successfully found stream: $streamArn');

      final streamDescription = await _dynamoDBStreams.describeStream(
        streamArn: streamArn,
      );
      final shards = streamDescription.streamDescription?.shards;

      if (shards == null || shards.isEmpty) {
        print('No shards found for the stream.');
        return;
      }

      // Launch a polling process for each shard.
      print('Found ${shards.length} shard(s). Starting listeners for each.');
      final futures = <Future<void>>[];
      for (final shard in shards) {
        if (shard.shardId != null) {
          futures.add(_pollShard(streamArn, shard.shardId!, onEvents));
        }
      }

      // Wait for all shard polling processes to complete
      await Future.wait(futures);
    } catch (e) {
      print('An error occurred while initializing the stream listener: $e');
    }
  }

  /// Polls a single shard for records indefinitely.
  Future<void> _pollShard(
    String streamArn,
    String shardId,
    StreamEventCallback<T> onEvents,
  ) async {
    try {
      final iteratorResult = await _dynamoDBStreams.getShardIterator(
        streamArn: streamArn,
        shardId: shardId,
        shardIteratorType: streams.ShardIteratorType.latest,
      );

      var nextShardIterator = iteratorResult.shardIterator;
      print('Starting to poll for changes on shard "$shardId"...');

      while (nextShardIterator != null) {
        try {
          final recordsResult = await _dynamoDBStreams.getRecords(
            shardIterator: nextShardIterator,
          );

          if (recordsResult.records != null &&
              recordsResult.records!.isNotEmpty) {
            final events = _processRecords(recordsResult.records!);
            if (events.isNotEmpty) {
              print(
                'Detected ${events.length} new event(s) on shard "$shardId".',
              );
              onEvents(events);
            }
          }
          // Removed the "No new records" log to reduce spam

          nextShardIterator = recordsResult.nextShardIterator;

          // A shard iterator becomes null if the shard is closed (e.g., due to a split).
          if (nextShardIterator == null) {
            print(
              'Shard "$shardId" has been closed. Stopping polling for this shard.',
            );
            return;
          }
        } catch (e) {
          print(
            'Error polling shard "$shardId": $e. Retrying in 10 seconds...',
          );
          await Future.delayed(const Duration(seconds: 10));
          continue;
        }

        await Future.delayed(const Duration(seconds: 5));
      }
    } catch (e) {
      print(
        'An error occurred while setting up polling for shard "$shardId": $e',
      );
    }
  }

  List<StreamEvent<T>> _processRecords(List<streams.Record> records) {
    String userID = AuthService.currentUserId;
    final events = <StreamEvent<T>>[];
    for (final record in records) {
      // ignore records that do not belong to the current user
      final newImage = record.dynamodb?.newImage;
      final oldImage = record.dynamodb?.oldImage;
      if (newImage != null) {
        final newItemMap = _convertAttributeMap(newImage);
        if (newItemMap['userID'] != userID) continue;
      }
      if (oldImage != null) {
        final oldItemMap = _convertAttributeMap(oldImage);
        if (oldItemMap['userID'] != userID) continue;
      }

      try {
        final eventType = _mapEventType(record.eventName?.name);
        if (eventType == null) continue;

        final T? newItem = record.dynamodb?.newImage != null
            ? fromJson(_convertAttributeMap(record.dynamodb!.newImage!))
            : null;

        final T? oldItem = record.dynamodb?.oldImage != null
            ? fromJson(_convertAttributeMap(record.dynamodb!.oldImage!))
            : null;

        events.add(
          StreamEvent(type: eventType, newItem: newItem, oldItem: oldItem),
        );
      } catch (e) {
        print('Error processing record: $e');
        // Continue processing other records even if one fails
      }
    }
    return events;
  }

  StreamEventType? _mapEventType(String? eventName) {
    switch (eventName) {
      case 'insert':
        return StreamEventType.insert;
      case 'modify':
        return StreamEventType.modify;
      case 'remove':
        return StreamEventType.remove;
      default:
        print('Unknown event type: $eventName');
        return null;
    }
  }

  Map<String, dynamic> _convertAttributeMap(Map<String, dynamic> attributeMap) {
    return attributeMap.map((key, value) {
      dynamic result;

      if (value.s != null) {
        result = value.s;
      } else if (value.n != null) {
        result = num.tryParse(value.n!) ?? value.n;
      } else if (value.b != null) {
        result = value.b;
      } else if (value.ss != null) {
        result = value.ss;
      } else if (value.ns != null) {
        result = value.ns?.map((n) => num.tryParse(n) ?? n).toList();
      } else if (value.bs != null) {
        result = value.bs;
      } else if (value.m != null) {
        result = _convertAttributeMap(value.m!);
      } else if (value.l != null) {
        result = value.l!.map((item) => _convertAttributeValue(item)).toList();
      } else if (value.nul == true) {
        result = null;
      } else if (value.boolValue != null) {
        result = value.boolValue;
      } else {
        result = null;
      }

      return MapEntry(key, result);
    });
  }

  /// Helper method to convert a single AttributeValue
  dynamic _convertAttributeValue(dynamic value) {
    if (value.s != null) return value.s;
    if (value.n != null) return num.tryParse(value.n!) ?? value.n;
    if (value.b != null) return value.b;
    if (value.ss != null) return value.ss;
    if (value.ns != null)
      return value.ns?.map((n) => num.tryParse(n) ?? n).toList();
    if (value.bs != null) return value.bs;
    if (value.m != null) return _convertAttributeMap(value.m!);
    if (value.l != null) return value.l!.map(_convertAttributeValue).toList();
    if (value.nul == true) return null;
    if (value.boolValue != null) return value.boolValue;
    return null;
  }
}
