import 'package:flutter/material.dart';
import 'dart:async';
import 'package:aws_dynamodbstreams_api/streams-dynamodb-2012-08-10.dart'
    as aws;
import 'dynamo_service.dart';
import 'log_entry.dart';
import 'dynamo_stream_listener.dart';
import 'sms_service.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key, required Null Function(dynamic e) onNewEntry})
    : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final String tableName = "messages";
  final DynamoService dynamoService = DynamoService();
  final service = aws.DynamoDBStreams(region: 'eu-east-12');
   List<LogEntry> messages = [];

  @override
  void initState() {
    super.initState();

    final listener = DynamoStreamListener<LogEntry>(
      tableName: "messages",
      fromJson: (json) => LogEntry.fromJson(json),
    );

    listener.currentItems.then((items) {
      setState(() {
        messages = items;
      });
    });

    listener.listen(
      onEvents: (events) {
        for (var event in events) {
          print('Event Type: ${event.type}');
          if (event.newItem != null) {
            print('New Item: ${event.newItem}');
            setState(() {
              messages.add(event.newItem!);
            });
          }
          if (event.oldItem != null) {
            print('Old Item: ${event.oldItem}');
          }
        }
      },
    );
 
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Recent Transactions')),
      body: ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
          return LogEntryWidget(logEntry: messages[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          LogEntry message = LogEntry(
            text:
                "You spent \$${(20 + (80 * (new DateTime.now().second % 10) / 10)).toStringAsFixed(2)} at ${["Starbucks", "McDonalds", "Amazon", "Walmart", "Target"][new DateTime.now().second % 5]}",
            sender: "test sender",
            category: "",
            time: DateTime.now().toString(),
          );
          await message.classify();
          dynamoService.insertNewItem(message.toDBValue(), tableName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
