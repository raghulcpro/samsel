import 'package:flutter/material.dart';
import 'package:sammsel/core/constants/app_constants.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final List<Map<String, String>> _mockReports = [
    {'date': '2023-10-25', 'name': 'John Doe', 'type': 'Visit', 'location': 'Metropolis High'},
    {'date': '2023-10-24', 'name': 'Jane Smith', 'type': 'Expense', 'amount': '₹120.00'},
    {'date': '2023-10-24', 'name': 'Alice Wong', 'type': 'Visit', 'location': 'Gotham Academy'},
    {'date': '2023-10-23', 'name': 'Bob Ross', 'type': 'Expense', 'amount': '₹45.50'},
    {'date': '2023-10-22', 'name': 'Sales Team', 'type': 'Visit', 'location': 'City Hospital'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Enterprise Reports',
          style: TextStyle(color: AppConstants.textDark, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.download_rounded, color: AppConstants.accentColorLight),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exporting report...')),
                );
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FILTERS
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildFilterChip('This Week', true),
                  const SizedBox(width: 10),
                  _buildFilterChip('Visits', false),
                  const SizedBox(width: 10),
                  _buildFilterChip('Expenses', false),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // LIST HEADER
            const Text(
              'Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppConstants.textDark),
            ),
            const SizedBox(height: 16),

            // REPORT LIST
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: _mockReports.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _mockReports[index];
                  final bool isExpense = item['type'] == 'Expense';

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (isExpense ? Colors.blueAccent : AppConstants.accentColorLight).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isExpense ? Icons.receipt_long_rounded : Icons.location_city_rounded,
                          color: isExpense ? Colors.blueAccent : AppConstants.accentColorLight,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        item['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppConstants.textDark),
                      ),
                      subtitle: Text(
                        '${item['type']} • ${item['date']}',
                        style: const TextStyle(color: AppConstants.textLight, fontSize: 13),
                      ),
                      trailing: Text(
                        item['location'] ?? item['amount'] ?? '',
                        style: TextStyle(
                          color: isExpense ? Colors.redAccent : AppConstants.textDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
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

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppConstants.accentColorLight : Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          if (!isSelected)
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppConstants.textLight,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}