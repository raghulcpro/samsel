import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // NEW: For navigation
import 'package:intl/intl.dart'; // NEW: For date formatting
import 'package:sammsel/core/constants/app_constants.dart';
import 'package:sammsel/models/task_model.dart'; // NEW: For TaskPriority
import 'package:sammsel/widgets/custom_card.dart';

class ManagerDashboard extends StatelessWidget {
  const ManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Central Office', style: TextStyle(color: AppConstants.textLight, fontSize: 14)),
            Text('Manager Dashboard', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppConstants.textDark)),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppConstants.accentColorLight.withValues(alpha: 0.1),
            child: const Icon(Icons.notifications_none_rounded, color: AppConstants.accentColorLight),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Stats Row
            Row(
              children: [
                Expanded(child: _buildStatBox('42', 'Employees', Icons.people_outline)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatBox('28', 'Visits Today', Icons.calendar_today_outlined)),
              ],
            ),
            const SizedBox(height: 16),

            // 2. Expenses Card
            CustomCard(
              color: Colors.white,
              hasShadow: true,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: AppConstants.accentColorLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: const Icon(Icons.account_balance_wallet_outlined, color: AppConstants.accentColorLight),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('₹12,500', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppConstants.textDark)),
                      Text('Total Expenses', style: TextStyle(fontSize: 12, color: AppConstants.textLight)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ============================================================
            // START OF NEW TASK SECTION
            // ============================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Task Board', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppConstants.textDark)),
                TextButton.icon(
                  // Navigate to the Assignment Screen
                  onPressed: () => context.push('/task_assignment'),
                  icon: const Icon(Icons.add_circle, color: AppConstants.accentColorLight, size: 20),
                  label: const Text("Assign Task", style: TextStyle(color: AppConstants.accentColorLight, fontWeight: FontWeight.bold)),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Task Tabs & Lists
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TabBar(
                      labelColor: Colors.white,
                      unselectedLabelColor: AppConstants.textLight,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: AppConstants.accentColorLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: "My Tasks"),
                        Tab(text: "Delegated"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220, // Height for the list view
                    child: TabBarView(
                      children: [
                        // TAB 1: Tasks Assigned TO Manager (From Admin)
                        ListView(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildTaskTile("Prepare Q3 Audit Report", "Admin", DateTime.now().add(const Duration(days: 2)), TaskPriority.high),
                            const SizedBox(height: 8),
                            _buildTaskTile("Update Location Policy", "Admin", DateTime.now().add(const Duration(days: 5)), TaskPriority.medium),
                          ],
                        ),
                        // TAB 2: Tasks Delegated BY Manager (To Employees)
                        ListView(
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildDelegatedTaskTile("Visit St. Joseph's", "Alice (Emp)", "Pending"),
                            const SizedBox(height: 8),
                            _buildDelegatedTaskTile("Submit Expense Proofs", "Bob (Emp)", "Completed"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // ============================================================
            // END OF NEW TASK SECTION
            // ============================================================

            const Text('Team Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppConstants.textDark)),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.05), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  _buildEmployeeTile('Alice Johnson', 'EMP-001', true),
                  Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
                  _buildEmployeeTile('Bob Smith', 'EMP-002', false),
                  Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
                  _buildEmployeeTile('Charlie Brown', 'EMP-003', true),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // --- EXISTING WIDGETS ---

  Widget _buildStatBox(String value, String label, IconData icon) {
    return CustomCard(
      color: Colors.white,
      hasShadow: true,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(icon, color: AppConstants.accentColorLight, size: 28),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppConstants.textDark)),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: AppConstants.textLight)),
        ],
      ),
    );
  }

  Widget _buildEmployeeTile(String name, String id, bool visited) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppConstants.inputFill,
        child: Text(name[0], style: const TextStyle(color: AppConstants.textDark, fontWeight: FontWeight.bold)),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppConstants.textDark)),
      subtitle: Text(id, style: const TextStyle(fontSize: 12, color: AppConstants.textLight)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: visited ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          visited ? 'Visited' : 'Pending',
          style: TextStyle(
            color: visited ? Colors.green : Colors.orange,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // --- NEW TASK HELPERS ---

  Widget _buildTaskTile(String title, String assigner, DateTime deadline, TaskPriority priority) {
    Color priorityColor = priority == TaskPriority.high ? Colors.redAccent : Colors.orangeAccent;
    return CustomCard(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hasShadow: false, // Use simple border look inside list
      child: Row(
        children: [
          Container(
            width: 4, height: 40,
            decoration: BoxDecoration(color: priorityColor, borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppConstants.textDark)),
                const SizedBox(height: 4),
                Text("From: $assigner • Due: ${DateFormat('MMM dd').format(deadline)}",
                    style: const TextStyle(fontSize: 11, color: AppConstants.textLight)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 18),
        ],
      ),
    );
  }

  Widget _buildDelegatedTaskTile(String title, String assignee, String status) {
    bool isCompleted = status == "Completed";
    return CustomCard(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hasShadow: false,
      child: Row(
        children: [
          Icon(Icons.outbound_rounded, color: AppConstants.textLight.withValues(alpha: 0.5), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppConstants.textDark)),
                const SizedBox(height: 4),
                Text("To: $assignee", style: const TextStyle(fontSize: 11, color: AppConstants.textLight)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isCompleted ? Colors.green : Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}