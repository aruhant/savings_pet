// lib/main.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:goals/dynamo_service.dart';
import 'dart:math';
import 'package:goals/home_page.dart';
import 'package:goals/log_entry.dart';
import 'package:goals/rbc_investease_api_client.dart';
import 'package:goals/shopping_items.dart';
import 'package:goals/sms_service.dart';
import 'package:goals/stats_page.dart';
import 'package:goals/message_page.dart';
import 'package:goals/shopping_page.dart';
import 'package:goals/profile_page.dart';
import 'package:goals/user.dart';

void main() {
  runApp(const MyApp());
}

const Color kPrimaryBlue = Color(0xFF107CDC);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Savings App (Demo)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Montserrat',
      ),
      home: const RootScaffold(),
    );
  }
}

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});
  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  final PageController _pageController = PageController();
  int _selected = 0;

  // Demo "user" name
  final String _userName = 'Alex';

  // Replace DemoData.* calls with your DynamoService methods if you'd like.
  @override
  void initState() {
    super.initState();
    // Example: load data from DynamoService here (async)
    // DynamoService ds = DynamoService();
    // ds.getAll(tableName: 'messages')...
    AuthService.login().then((user) {
      setState(() {});
      if (user != null) {
        print('Logged in as ${user.name} (${user.email} - ${user.id})');
      } else {
        print('Login failed or cancelled');
      }
    });
    SmsMonitor smsMonitor = SmsMonitor();
    smsMonitor.startMonitoring((smsData) {
      () => setState(() {
        print("New SMS from ${smsData['sender']}: ${smsData['body']}");
      });
    });
  }

  void _onTap(int index) {
    setState(() => _selected = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (AuthService.currentClient == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final pages = <Widget>[
      HomePage(),
      StatsPage(),
      MessagePage(),
      ShoppingPage(
        onPurchase: (goalKey, amount) async {
          bool? confirmed = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirm Investment'),
                content: Text(
                  'Invest \$${amount.toStringAsFixed(2)} in ${(goalKey as ShoppingItem).portfolio} portfolio towards your goal? ',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      InvestEaseApiClient.investInPortfolio(
                        AuthService.currentClient!,
                        (goalKey as ShoppingItem).portfolio,
                        amount,
                      );

                      DynamoService().insertNewItem(
                        LogEntry(
                          text:
                              "Invested \$${amount.toStringAsFixed(2)} in the ${goalKey.portfolio} portfolio",
                          sender: "system",
                          category: "investment",
                          time: DateTime.now().toString(),
                          amount: amount,
                          merchant:
                              '${goalKey.title} (${goalKey.portfolio.toTitleCase()})',
                          recepient: "RBC InvestEase",
                          type: 'credit',
                        ).toDBValue(),
                        'messages',
                      );

                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Confirm'),
                  ),
                ],
              );
            },
          );
          if (confirmed == true) {
            // Add purchase logic here if needed
            setState(() {});
          }
        },
      ),
      /*
      GoalsPage(
        onAllocate: (goalKey, amount) {
          DemoData.allocateToGoal(goalKey, amount);
          setState(() {});
        },
      ),
      */
      ProfilePage(),
    ];

    final icons = [
      Icons.home_rounded,
      Icons.pie_chart_outline_rounded,
      Icons.add_circle_outline,
      Icons.shopping_cart_outlined,
      Icons.person_outline,
    ];

    final labels = ['Home', 'Analytics', 'Log', 'Shop', 'Profile'];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (i) => setState(() => _selected = i),
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white, // flush with page
        elevation: 0,
        currentIndex: _selected,
        selectedItemColor: kPrimaryBlue,
        unselectedItemColor: Colors.grey[600],
        onTap: _onTap,
        items: List.generate(5, (i) {
          final bool isCenter = i == 2;
          return BottomNavigationBarItem(
            icon: Icon(icons[i], size: isCenter ? 34 : 22),
            label: labels[i],
          );
        }),
      ),
    );
  }
}

/// -----------------------
/// Log Page
/// - user picks type: House / Car / Trip, then the form updates
/// -----------------------
class LogPage extends StatefulWidget {
  final void Function(DemoMessage entry)? onNewEntry;
  const LogPage({super.key, this.onNewEntry});
  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'Car';
  final Map<String, TextEditingController> _controllers = {
    'amount': TextEditingController(),
    'carModel': TextEditingController(),
    'downPayment': TextEditingController(),
    'mortgage': TextEditingController(),
    'interest': TextEditingController(),
    'location': TextEditingController(),
  };

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.tryParse(_controllers['amount']!.text) ?? 0.0;
    final category = _type;
    String title;
    switch (_type) {
      case 'Car':
        title = 'Car: ${_controllers['carModel']!.text}';
        break;
      case 'House':
        title = 'House down: ${_controllers['downPayment']!.text}';
        break;
      case 'Trip':
        title = 'Trip to ${_controllers['location']!.text}';
        break;
      default:
        title = 'Log';
    }
    final entry = DemoMessage(
      title: title,
      category: category,
      amount: amount,
      timestamp: DateTime.now(),
    );
    DemoData.addMessage(entry);
    widget.onNewEntry?.call(entry);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Saved')));
    _controllers.forEach((k, c) => c.clear());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Log'.toUpperCase(),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // dropdown
                  Row(
                    children: [
                      const Text('Save for: '),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        value: _type,
                        items: const [
                          DropdownMenuItem(value: 'Car', child: Text('Car')),
                          DropdownMenuItem(
                            value: 'House',
                            child: Text('House'),
                          ),
                          DropdownMenuItem(value: 'Trip', child: Text('Trip')),
                        ],
                        onChanged: (v) => setState(() => _type = v ?? 'Car'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // dynamic fields
                  if (_type == 'Car') ...[
                    TextFormField(
                      controller: _controllers['carModel'],
                      decoration: const InputDecoration(labelText: 'Car model'),
                      validator: (s) =>
                          (s == null || s.isEmpty) ? 'Enter model' : null,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _controllers['amount'],
                      decoration: const InputDecoration(
                        labelText: 'Amount (total)',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (s) =>
                          (s == null || s.isEmpty) ? 'Enter amount' : null,
                    ),
                  ] else if (_type == 'House') ...[
                    TextFormField(
                      controller: _controllers['downPayment'],
                      decoration: const InputDecoration(
                        labelText: 'Down payment',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (s) => (s == null || s.isEmpty)
                          ? 'Enter down payment'
                          : null,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _controllers['mortgage'],
                      decoration: const InputDecoration(
                        labelText: 'Mortgage (amount)',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (s) =>
                          (s == null || s.isEmpty) ? 'Enter mortgage' : null,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _controllers['interest'],
                      decoration: const InputDecoration(
                        labelText: 'Interest %',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (s) =>
                          (s == null || s.isEmpty) ? 'Enter interest' : null,
                    ),
                  ] else ...[
                    TextFormField(
                      controller: _controllers['location'],
                      decoration: const InputDecoration(labelText: 'Location'),
                      validator: (s) =>
                          (s == null || s.isEmpty) ? 'Enter location' : null,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _controllers['amount'],
                      decoration: const InputDecoration(
                        labelText: 'Total needed',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (s) =>
                          (s == null || s.isEmpty) ? 'Enter total' : null,
                    ),
                  ],
                  const SizedBox(height: 14),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryBlue,
                    ),
                    onPressed: _save,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// -----------------------
/// Goals Page
/// - shows a list of goals and lets user allocate money to each
/// -----------------------
class GoalsPage1 extends StatefulWidget {
  final void Function(String goalKey, double amount)? onAllocate;
  const GoalsPage1({super.key, this.onAllocate});
  @override
  State<GoalsPage1> createState() => _GoalsPage1State();
}

class _GoalsPage1State extends State<GoalsPage1> {
  final TextEditingController _allocController = TextEditingController();

  List<DemoGoal> get goals => DemoData.goals;

  void _openAllocate(DemoGoal g) {
    _allocController.clear();
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Allocate to ${g.title}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _allocController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'Amount'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryBlue,
                  ),
                  onPressed: () {
                    final amt = double.tryParse(_allocController.text) ?? 0.0;
                    DemoData.allocateToGoal(g.key, amt);
                    widget.onAllocate?.call(g.key, amt);
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                  child: const Text('Allocate'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Goals'.toUpperCase(),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: goals.isEmpty
                  ? const Center(child: Text('No goals yet'))
                  : ListView.separated(
                      itemCount: goals.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final g = goals[i];
                        final pct = g.getProgressPercentage();
                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            title: Text(g.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LinearProgressIndicator(
                                  value: pct / 100,
                                  color: kPrimaryBlue,
                                  backgroundColor: Colors.grey[200],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '\$${g.currentAmount.toStringAsFixed(2)} / \$${g.targetAmount.toStringAsFixed(2)}',
                                ),
                              ],
                            ),
                            trailing: ElevatedButton(
                              onPressed: () => _openAllocate(g),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryBlue,
                              ),
                              child: const Text('Add'),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// -----------------------
/// Profile Page (minimal)
/// -----------------------
///
///
/*
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    // Replace with real account data
    final accounts = [
      {'name': 'Checking', 'balance': 2345.12},
      {'name': 'Savings', 'balance': 7820.55},
      {'name': 'Credit Card', 'balance': -320.12},
    ];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile'.toUpperCase(),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...accounts.map(
              (a) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(a['name'] as String),
                trailing: Text(
                  '\$${(a['balance'] as double).toStringAsFixed(2)}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
/// -----------------------
/// -----------------------
/// Demo data + simple models (replace these with your models/services)
/// -----------------------
class DemoMessage {
  String? title;
  String? category;
  double? amount;
  DateTime timestamp;
  DemoMessage({this.title, this.category, this.amount, DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();
}

class DemoGoal {
  String key;
  String title;
  double targetAmount;
  double currentAmount;
  DemoGoal({
    required this.key,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
  });
  double getProgressPercentage() {
    if (targetAmount == 0) return 0.0;
    return ((currentAmount / targetAmount) * 100).clamp(0.0, 100.0);
  }
}

class DemoData {
  static final List<DemoMessage> _messages = [
    DemoMessage(
      title: 'Groceries',
      category: 'Food',
      amount: 24.50,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    DemoMessage(
      title: 'Coffee',
      category: 'Food',
      amount: 4.75,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    DemoMessage(
      title: 'Gas',
      category: 'Transport',
      amount: 45.00,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    DemoMessage(
      title: 'New phone case',
      category: 'Shopping',
      amount: 12.99,
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  static final List<DemoGoal> _goals = [
    DemoGoal(
      key: 'g1',
      title: 'Vacation',
      targetAmount: 2000,
      currentAmount: 400,
    ),
    DemoGoal(
      key: 'g2',
      title: 'Down payment',
      targetAmount: 15000,
      currentAmount: 3000,
    ),
  ];

  static List<DemoMessage> recentMessages({int limit = 100}) =>
      _messages.reversed.take(limit).toList();

  static void addMessage(DemoMessage m) => _messages.add(m);

  static List<DemoMessage> allMessages() => _messages;

  static List<DemoGoal> get goals => _goals;

  static void allocateToGoal(String key, double amount) {
    final g = _goals.firstWhere(
      (x) => x.key == key,
      orElse: () => throw Exception('Goal not found'),
    );
    g.currentAmount += amount;
  }
}
