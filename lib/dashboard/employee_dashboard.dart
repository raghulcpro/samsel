import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:sammsel/auth/auth_service.dart';
import 'package:sammsel/core/constants/app_constants.dart';
import 'package:sammsel/widgets/custom_card.dart';
import 'package:intl/intl.dart';

// Mock Data for Tasks (In real app, fetch from DB)
final List<Map<String, dynamic>> _mockEmployeeTasks = [
  {
    'title': 'Visit St. Josephs',
    'assigner': 'Manager John',
    'due': DateTime.now().add(const Duration(days: 1)),
    'priority': 'High',
    'status': 'Pending'
  },
  {
    'title': 'Submit Expense Report',
    'assigner': 'Manager Sarah',
    'due': DateTime.now().add(const Duration(days: 3)),
    'priority': 'Medium',
    'status': 'Completed'
  },
];

class EmployeeDashboard extends StatelessWidget {
  const EmployeeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final authService = Provider.of<AuthService>(context);
    const String employeeName = 'Alice Smith';

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Employee Dashboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                'Good morning,',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70),
              ),
              Text(
                employeeName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              // Quick Actions Section
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      context,
                      label: 'Add Visit',
                      icon: Icons.add_location_alt_rounded,
                      color: AppConstants.accentColorLight,
                      onTap: () => context.push('/visit_entry'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionButton(
                      context,
                      label: 'Add Expense',
                      icon: Icons.account_balance_wallet_rounded,
                      color: AppConstants.accentColorDark,
                      onTap: () => context.push('/expense_entry'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // --- NEW: ASSIGNED TASKS SECTION ---
              Text(
                'My Assigned Tasks',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _mockEmployeeTasks.length,
                separatorBuilder: (ctx, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final task = _mockEmployeeTasks[index];
                  return CustomCard(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                task['title'],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: task['priority'] == 'High' ? Colors.red.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                task['priority'],
                                style: TextStyle(
                                    color: task['priority'] == 'High' ? Colors.red : Colors.orange,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Assigned by: ${task['assigner']}",
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Due: ${DateFormat('MMM dd').format(task['due'])}",
                              style: const TextStyle(fontSize: 12, color: Colors.white70),
                            ),
                            if (task['status'] == 'Pending')
                              InkWell(
                                onTap: () {
                                  // Mark as done logic
                                },
                                child: const Text("Mark Done", style: TextStyle(color: AppConstants.accentColorLight, fontWeight: FontWeight.bold)),
                              )
                            else
                              const Icon(Icons.check_circle, color: Colors.green, size: 18)
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // --- MISSING METHODS RESTORED ---
  Widget _buildActionButton(BuildContext context, {required String label, required IconData icon, required Color color, required VoidCallback onTap}) {
    return CustomCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 36),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white38, size: 20),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(color: Colors.white70)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }
}