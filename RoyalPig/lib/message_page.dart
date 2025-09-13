import 'package:flutter/material.dart';
import 'dart:async';
import 'package:aws_dynamodbstreams_api/streams-dynamodb-2012-08-10.dart'
    as aws;
import 'dynamo_service.dart';
import 'message.dart';
import 'dynamo_stream_listener.dart';
import 'sms_service.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key, required Null Function(dynamic e) onNewEntry}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final String tableName = "messages";
  final DynamoService dynamoService = DynamoService();
  final service = aws.DynamoDBStreams(region: 'eu-east-12');
  final SmsService smsService = SmsService(); // Add this
  String sms = 'no sms received';
  String sender = 'no sms received';
  String time = 'no sms received';
  StreamSubscription<Map<String, String>>? _smsSubscription; // Add this
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();

    final listener = DynamoStreamListener<Message>(
      tableName: "messages",
      fromJson: (json) => Message.fromJson(json),
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

    // Initialize SMS service and listen to its stream
    smsService.initialize().then((initialized) {
      if (initialized) {
        _smsSubscription = smsService.smsStream.listen((smsData) {
          setState(() {
            sms = smsData['body']!;
            sender = smsData['sender']!;
            time = smsData['time']!;
            Message message = Message(
              text: sms,
              sender: sender,
              category: "inbox",
              time: time,
            );
            dynamoService.insertNewItem(message.toDBValue(), tableName);
          });
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _smsSubscription?.cancel(); // Cancel subscription
    smsService.dispose(); // Dispose service
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (BuildContext context, int index) {
          return Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                '${messages[index].text} - ${messages[index].sender} at ${messages[index].time}',
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Message message = Message(
            text: "test message",
            sender: "test sender",
            category: "test category",
            time: DateTime.now().toString(),
          );
          dynamoService.insertNewItem(message.toDBValue(), tableName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
