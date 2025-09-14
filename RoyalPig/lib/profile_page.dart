import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final accounts = [
      {'name': 'Checking', 'balance': 2345.12},
      {'name': 'Savings', 'balance': 7820.55},
      {'name': 'Credit Card', 'balance': -320.12},
    ];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Text(
              "PROFILE",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Profile header
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "John Doe",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text("johndoe@email.com",
                      style: TextStyle(color: Colors.black54)),
                  const Text("Joined Jan 2023",
                      style: TextStyle(color: Colors.black38, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Accounts card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Accounts",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...accounts.map((a) {
                    final balance = a['balance'] as double;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(a['name'] as String,
                              style: const TextStyle(fontSize: 15)),
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
              icon: Icons.edit,
              text: "Edit Profile",
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _actionButton(
              icon: Icons.flag,
              text: "Edit Goal",
              subtitle: "Trip to Europe",
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _actionButton(
              icon: Icons.settings,
              text: "Settings",
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _actionButton(
              icon: Icons.logout,
              text: "Log Out",
              color: Colors.red,
              onTap: () {},
            ),
          ],
        ),
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
            const Icon(Icons.chevron_right, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}

