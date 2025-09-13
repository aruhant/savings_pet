import 'package:flutter/material.dart';
import 'dart:async';
import 'package:aws_dynamodbstreams_api/streams-dynamodb-2012-08-10.dart'
    as aws;
import 'package:goals/goals_page.dart';
import 'message_page.dart';
import 'stats_page.dart';
import 'dynamo_service.dart';
import 'log_entry.dart';
import 'shopping_page.dart';
import 'sms_service.dart';
import 'user.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final SmsService smsService = SmsService();
  StreamSubscription<Map<String, String>>? _smsSubscription;

  final String tableName = "messages";
  final DynamoService dynamoService = DynamoService();
  final service = aws.DynamoDBStreams(region: 'eu-east-12');

  // Add User instance
  User? user;

  @override
  void initState() {
    super.initState();

    _loadUser();

    // Initialize SMS service and listen to its stream
    smsService.initialize().then((initialized) {
      if (initialized) {
        _smsSubscription = smsService.smsStream.listen((smsData) {
          dynamoService.insertNewItem(
            LogEntry(
              text: smsData['body']!,
              sender: smsData['sender']!,
              category: "uncategorized",
              time: smsData['time']!,
            ).toDBValue(),
            tableName,
          );
        });
      }
    });
  }

  Future<void> _loadUser() async {
    await AuthService.login().then((user) {
      setState(() {
        this.user = user;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _smsSubscription?.cancel(); // Cancel subscription
    smsService.dispose(); // Dispose service
  }

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.area_chart),
            icon: Icon(Icons.area_chart_outlined),
            label: 'Stats',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.track_changes),
            icon: Icon(Icons.track_changes_outlined),
            label: 'Goals',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
          NavigationDestination(
            icon: Icon(Icons.messenger_outlined),
            selectedIcon: Icon(Icons.messenger),
            label: 'Messages',
          ),
        ],
      ),
      body: <Widget>[
        /// Home page
        StatsPage(),
        GoalsPage(
          onAllocate: (goalKey, amount) {
            setState(() {});
          },
        ),

        /// Notifications page
        ShoppingPage(
          onPurchase: (goalKey, amount) {
            setState(() {});
          },
        ),
        MessagePage(),

        /// Messages page
      ][currentPageIndex],
    );
  }
}
