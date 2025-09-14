import 'package:flutter/material.dart';
import 'package:goals/message_page.dart';
import 'package:goals/rbc_investease_api_client.dart';
import 'package:goals/user.dart';

/// -----------------------
/// Home Page
/// -----------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Dummy values (replace with DynamoDB data later)
  double totalBalance = 2059.28;
  double monthSpending = -353.48;
  double goalCurrent = 798;
  double goalTarget = 8000;
  Client client = AuthService.currentClient!;

  @override
  void initState() {
    super.initState();
    goalCurrent = client.portfolios
        .map((account) => account.currentValue)
        .reduce((a, b) => a + b);
    totalBalance = client.cash + goalCurrent;
  }

  List<Map<String, dynamic>> recentTransactions = [
    {"title": "Star Café", "category": "Shopping", "amount": 87.66},
    {"title": "Fuel Station", "category": "Shopping", "amount": 101.05},
    {"title": "Bakery", "category": "Transport", "amount": 63.31},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome text
            Text(
              "Welcome back, ${client.name} 👋",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),

            // Total balance card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Balance",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "\$${totalBalance.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.account_balance_wallet,
                    size: 36,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Two small cards row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Monthly Spending",
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          monthSpending.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Goals Progress",
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: goalCurrent / goalTarget,
                          backgroundColor: Colors.grey.shade300,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Trip to Europe: \$${goalCurrent.toInt()} / \$${goalTarget.toInt()}",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            /*
            // Recent transactions
            const Text(
              "Recent Transactions",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
               Column(
              children: recentTransactions.map((t) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.red.shade50,
                    child: const Icon(Icons.arrow_upward, color: Colors.red),
                  ),
                  title: Text(t["title"]),
                  subtitle: Text(t["category"]),
                  trailing: Text(
                    "\$${t["amount"].toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),*/
            // MessagePage(),
            const SizedBox(height: 20),

            // Financial Tips
            const Text(
              "💡 Financial Tips",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: const [
                        Icon(Icons.savings, color: Colors.green),
                        SizedBox(height: 6),
                        Text(
                          "Save 20% of your income",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: const [
                        Icon(Icons.track_changes, color: Colors.blue),
                        SizedBox(height: 6),
                        Text(
                          "Track your spending",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
