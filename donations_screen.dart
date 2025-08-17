import 'package:flutter/material.dart';

class DonationsScreen extends StatelessWidget {
  const DonationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy donations list (later you can fetch from backend)
    final List<Map<String, dynamic>> donations = [
      {
        'amount': 150.0,
        'donator': 'John Doe',
        'issue': 'Broken street light',
        'issueId': 1, // Used for navigation
      },
      {
        'amount': 250.0,
        'donator': 'Jane Smith',
        'issue': 'Flooded road',
        'issueId': 2,
      },
    ];

    final List<String> rewards = [
      'Certificate of Appreciation',
      'Discount Coupon',
      'Community Recognition Badge',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Donations & Rewards"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Recent Donations",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Donations list
          ...donations.map((donation) {
            return Card(
              child: ListTile(
                title: Text(
                  "${donation['donator']} donated \$${donation['amount']}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("For: ${donation['issue']}"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  // Navigate to Emergency Alert Issue
                  Navigator.pushNamed(
                    context,
                    '/emergency_alert/${donation['issueId']}',
                  );
                },
              ),
            );
          }).toList(),

          const SizedBox(height: 20),
          const Text(
            "Rewards",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Rewards list
          ...rewards.map((reward) {
            return Card(
              child: ListTile(
                leading: const Icon(Icons.star, color: Colors.orange),
                title: Text(reward),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
