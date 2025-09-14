import 'package:aws_dynamodb_api/dynamodb-2012-08-10.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:aws_dynamodbstreams_api/streams-dynamodb-2012-08-10.dart'
    as aws;
import 'package:goals/rbc_investease_api_client.dart';
import 'package:goals/user.dart';
import 'dynamo_service.dart';
import 'log_entry.dart';
import 'dynamo_stream_listener.dart';
import 'sms_service.dart';

class Goal {
  String title;
  String description;
  String imageUrl;
  DateTime targetDate;
  double progress = 0.0;
  double totalAmount = 0.0;

  Goal({
    required this.title,
    required this.description,
    required this.targetDate,
    required this.imageUrl,
    this.progress = 0.0,
    this.totalAmount = 0.0,
  });

  // factory constructor to create Goal from DynamoDB item
  factory Goal.fromDBValue(Map<String, aws.AttributeValue> dbValue) {
    return Goal(
      title: dbValue["title"]!.s!,
      description: dbValue["description"]!.s!,
      targetDate: DateTime.parse(dbValue["targetDate"]!.s!),
      progress: double.parse(dbValue["progress"]!.n ?? '0'),
      totalAmount: double.parse(dbValue["totalAmount"]!.n ?? '0'),
      imageUrl: dbValue["imageUrl"]!.s!,
    );
  }

  Map<String, AttributeValue> toDBValue() {
    Map<String, AttributeValue> dbMap = Map();
    dbMap["title"] = AttributeValue(s: title);
    dbMap["description"] = AttributeValue(s: description);
    dbMap["targetDate"] = AttributeValue(s: targetDate.toIso8601String());
    dbMap["progress"] = AttributeValue(n: progress.toString());
    dbMap["totalAmount"] = AttributeValue(n: totalAmount.toString());
    dbMap["imageUrl"] = AttributeValue(s: imageUrl);
    return dbMap;
  }

  static fromJson(Map<String, dynamic> json) {
    return Goal.fromDBValue(
      json.map(
        (key, value) => MapEntry(key, aws.AttributeValue(s: value.toString())),
      ),
    );
  }

  save() async {
    await DynamoService().insertNewItem(toDBValue(), "goals");
  }

  static Goal? _goal;
  static Goal? get currentUserGoal => _goal;
  static Future<Goal> fetchGoalForUser(String email) async {
    if (_goal != null) return _goal!;
    print('Fetching goal for user: ${email}');
    final response = await DynamoService().getItem<Goal>(
      tableName: "goals",
      fromJson: (json) => Goal.fromJson(json),
    );

    print('Fetched goal: $response');

    _goal =
        response ??
        Goal(
          title: 'No Goal',
          description: 'Set a new goal',
          targetDate: DateTime.now(),
          imageUrl: '',
        );

    await _goal!.save();
    return _goal!;
  }
}

class GoalsPage extends StatefulWidget {
  const GoalsPage({
    Key? key,
    required Null Function(dynamic goalKey, dynamic amount) onAllocate,
  }) : super(key: key);

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  @override
  void initState() {
    super.initState();
  }

  void _refreshGoal() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Goal goal = Goal.currentUserGoal!;

    final daysToGo = goal.targetDate.difference(DateTime.now()).inDays;
    final completionPercentage = goal.totalAmount > 0
        ? (goal.progress / goal.totalAmount)
        : 0.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Goals')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => GoalEditor(onSave: _refreshGoal),
          );
        },
        child: const Icon(Icons.edit),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              goal.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (goal.imageUrl.isNotEmpty)
              Image.network(goal.imageUrl, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(goal.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text(
              'Completion: ${(completionPercentage * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 18),
            ),
            LinearProgressIndicator(value: completionPercentage),
            const SizedBox(height: 16),
            Text('Days to go: $daysToGo', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

class GoalEditor extends StatefulWidget {
  final VoidCallback? onSave;

  const GoalEditor({Key? key, this.onSave}) : super(key: key);

  @override
  State<GoalEditor> createState() => _GoalEditorState();
}

class _GoalEditorState extends State<GoalEditor> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _imageUrl = '';
  DateTime _targetDate = DateTime.now().add(const Duration(days: 30));
  double _totalAmount = 0.0;
  String _investmentID = '';
  double _investedAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Goal'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a title' : null,
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter a description'
                    : null,
                onSaved: (value) => _description = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter an image URL'
                    : null,
                onSaved: (value) => _imageUrl = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Total Amount Needed',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter total amount';
                  }
                  final n = num.tryParse(value);
                  if (n == null || n <= 0) {
                    return 'Enter a valid positive number';
                  }
                  return null;
                },
                onSaved: (value) => _totalAmount = double.parse(value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Investment ID'),
                onSaved: (value) => _investmentID = value ?? '',
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Invested Amount'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final n = num.tryParse(value);
                    if (n == null || n < 0) {
                      return 'Enter a valid non-negative number';
                    }
                  }
                  return null;
                },
                onSaved: (value) =>
                    _investedAmount = value != null && value.isNotEmpty
                    ? double.parse(value)
                    : 0.0,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Target Date: '),
                  TextButton(
                    child: Text('${_targetDate.toLocal()}'.split(' ')[0]),
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _targetDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null && pickedDate != _targetDate) {
                        setState(() {
                          _targetDate = pickedDate;
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: const Text('Save'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              final newGoal = Goal(
                title: _title,
                description: _description,
                imageUrl: _imageUrl,
                targetDate: _targetDate,
                totalAmount: _totalAmount,
                progress: 0.0,
              );
              newGoal.save().then((_) {
                Navigator.of(context).pop();
                widget.onSave?.call();
              });
            }
          },
        ),
      ],
    );
  }
}
