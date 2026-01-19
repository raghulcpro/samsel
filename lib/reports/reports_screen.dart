import 'package:flutter/material.dart';
import 'package:sammsel/core/constants/app_constants.dart';
import 'package:sammsel/widgets/custom_card.dart';

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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Consistent with global gradient
      appBar: AppBar(
        title: const Text('Enterprise Reports'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined, color: AppConstants.accentColorLight),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Exporting report to Excel...'),
                  backgroundColor: AppConstants.accentColorLight,
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Filter Bar Section
            Text(
              'Filters',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.white70, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildFilterChip('Date Range', Icons.calendar_today_rounded),
                  const SizedBox(width: 10),
                  _buildFilterChip('Location', Icons.location_on_rounded),
                  const SizedBox(width: 10),
                  _buildFilterChip('Employee', Icons.person_rounded),
                  const SizedBox(width: 10),
                  _buildFilterChip('Type', Icons.category_rounded),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: CustomCard(
                padding: EdgeInsets.zero,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _mockReports.length,
                  // UPDATED: withOpacity -> withValues
                  separatorBuilder: (context, index) => Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
                  itemBuilder: (context, index) {
                    final item = _mockReports[index];
                    final bool isExpense = item['type'] == 'Expense';

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          // UPDATED: withOpacity -> withValues
                          color: (isExpense ? AppConstants.accentColorDark : AppConstants.accentColorLight).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isExpense ? Icons.receipt_long_rounded : Icons.location_city_rounded,
                          color: isExpense ? AppConstants.accentColorDark : AppConstants.accentColorLight,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        item['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          '${item['type']} • ${item['date']}',
                          // UPDATED: withOpacity -> withValues
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13),
                        ),
                      ),
                      trailing: Text(
                        item['location'] ?? item['amount'] ?? '',
                        style: TextStyle(
                          color: isExpense ? AppConstants.accentColorDark : AppConstants.accentColorLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 100), // Bottom padding for navigation bar
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        // UPDATED: withOpacity -> withValues
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        // UPDATED: withOpacity -> withValues
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white54),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: Colors.white38),
        ],
      ),
    );
  }
}