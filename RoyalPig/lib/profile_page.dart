import 'package:flutter/material.dart';
import 'package:goals/rbc_investease_api_client.dart';
import 'package:goals/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Profile info
  String _name = AuthService.currentClient?.name ?? "John Doe";
  String _email = AuthService.currentClient?.email ?? "johndoe@email.com";

  // Goal info
  String _goalName = "Trip to Europe";
  double _goalCost = 3000;
  double _goalSaved = 1200;
  String _goalEndDate = "Dec 2025";
  String _goalDescription = "Save for a trip to Europe with friends";

  @override
  Widget build(BuildContext context) {
    Client client = AuthService.currentClient!;
    final accounts = [
      {'name': 'Cash', 'balance': client.cash},
      ...client.portfolios.map(
        (portfolio) => {
          'name': '${portfolio.type} Investment'.toTitleCase(),
          'balance': portfolio.currentValue,
        },
      ),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title with Log Out button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /*
Text(
"PROFILE",
style: const TextStyle(
fontSize: 26,
fontWeight: FontWeight.bold,
),
),
*/
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.purple.shade200, width: 1),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.logout, size: 20),
                    onPressed: () {},
                    tooltip: 'Log Out',
                    color: const Color.fromARGB(255, 40, 39, 41),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Profile header
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/profile.png'),
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _email,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      Text(
                        "Joined " +
                            (AuthService.currentClient?.createdAt != null
                                ? DateTime.tryParse(
                                            AuthService
                                                .currentClient!
                                                .createdAt,
                                          ) !=
                                          null
                                      ? "${_monthName(DateTime.parse(AuthService.currentClient!.createdAt).toLocal().month)} ${DateTime.parse(AuthService.currentClient!.createdAt).year}"
                                      : AuthService.currentClient!.createdAt
                                : "Jan 2023"),
                        style: const TextStyle(
                          color: Colors.black38,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () => _showEditProfileDialog(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  Text(_email, style: const TextStyle(color: Colors.black54)),
                  const Text(
                    "Joined Jan 2023",
                    style: TextStyle(color: Colors.black38, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Accounts",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...accounts.map((a) {
                    final balance = a['balance'] as double;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            a['name'] as String,
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            "\$${balance.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 15,
                              color: balance < 0 ? Colors.red : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Separate Action Buttons
            _actionButton(
              icon: Icons.flag,
              text: "Goal: Europe Trip",
              subtitle:
                  "$_goalEndDate\nSaved: \$${_goalSaved.toStringAsFixed(0)} / \$${_goalCost.toStringAsFixed(0)}",
              onTap: () => _showEditGoalDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  // --- Edit Profile Dialog ---
  void _showEditProfileDialog(BuildContext context) {
    final nameController = TextEditingController(text: _name);
    final emailController = TextEditingController(text: _email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _name = nameController.text;
                _email = emailController.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // --- Edit Goal Dialog ---
  void _showEditGoalDialog(BuildContext context) {
    final nameController = TextEditingController(text: _goalName);
    final costController = TextEditingController(text: _goalCost.toString());
    final savedController = TextEditingController(text: _goalSaved.toString());
    final endDateController = TextEditingController(text: _goalEndDate);
    final descriptionController = TextEditingController(text: _goalDescription);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Goal"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Goal Name"),
            ),
            // short description of goal
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: endDateController,
              decoration: const InputDecoration(labelText: "End Date"),
            ),
            TextField(
              controller: costController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Total Cost"),
            ),
            TextField(
              controller: savedController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount Saved"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _goalName = nameController.text;
                _goalEndDate = endDateController.text;
                _goalCost = double.tryParse(costController.text) ?? _goalCost;
                _goalSaved =
                    double.tryParse(savedController.text) ?? _goalSaved;
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // Reusable button widget
  Widget _actionButton({
    required IconData icon,
    required String text,
    String? subtitle,
    Color? color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color ?? Colors.black87),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: color ?? Colors.black87,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.edit, color: Colors.black54, size: 18),
          ],
        ),
      ),
    );
  }
}

_monthName(int month) {
  const monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  return monthNames[month - 1];
}

extension StringCasingExtension on String {
  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}
