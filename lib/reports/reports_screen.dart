import 'package:flutter/material.dart';


class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final List<Map<String, String>> _mockReports = [
    {'date': '2023-10-25', 'name': 'Raghul', 'type': 'Visit', 'location': 'Metropolis High'},
    {'date': '2023-10-24', 'name': 'Tamil Selvi', 'type': 'Expense', 'amount': '\$120.00'},
    {'date': '2023-10-24', 'name': 'Revi', 'type': 'Visit', 'location': 'Gotham Academy'},
    {'date': '2023-10-23', 'name': 'Roshan', 'type': 'Expense', 'amount': '\$45.50'},
    {'date': '2023-10-22', 'name': 'Sales', 'type': 'Visit', 'location': 'City Hospital'},
    {'date': '2023-10-21', 'name': 'Marketing', 'type': 'Expense', 'amount': '\$200.00'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.download_rounded, color: Colors.white),
              tooltip: 'Export Excel',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exporting data...')),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // FILTERS SECTION
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All Dates', Icons.calendar_today),
                  const SizedBox(width: 8),
                  _buildFilterChip('Locations', Icons.location_on_outlined),
                  const SizedBox(width: 8),
                  _buildFilterChip('Type: All', Icons.filter_list),
                ],
              ),
            ),
          ),

          // LIST SECTION
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _mockReports.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = _mockReports[index];
                    final bool isExpense = item['type'] == 'Expense';

                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                      child: Row(
                        children: [
                          // Icon Box
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              // UPDATED: Modern API
                              color: isExpense
                                  ? Colors.orange.withValues(alpha: 0.1)
                                  : Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              isExpense ? Icons.receipt_long : Icons.business,
                              color: isExpense ? Colors.orange[800] : Colors.blue[800],
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Main Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item['type']} • ${item['date']}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Right Value
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                item['location'] ?? item['amount'] ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isExpense ? Colors.red[700] : Colors.black87,
                                ),
                              ),
                              if (isExpense)
                                const Text(
                                  "Pending",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 16, color: Colors.white70),
      label: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.white),
      ),
      // UPDATED: Modern API
      backgroundColor: Colors.white.withValues(alpha: 0.15),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}