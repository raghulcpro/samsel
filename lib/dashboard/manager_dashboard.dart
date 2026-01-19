import 'package:flutter/material.dart';
import 'package:sammsel/widgets/custom_card.dart';
import 'package:sammsel/core/theme/app_theme.dart';

class ManagerDashboard extends StatelessWidget {
  const ManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(onPressed: (){}, icon: const Icon(Icons.grid_view_rounded)),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Central Office Branch', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Stats Row
                Row(
                  children: [
                    Expanded(child: _buildStatBox('42', 'Employees in\nLocation', Icons.people_outline)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildStatBox('28', 'Visits Today', Icons.calendar_today_outlined)),
                  ],
                ),
                const SizedBox(height: 16),

                // 2. Total Expenses Box
                CustomCard(
                  color: const Color(0xFFFCE4EC),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.account_balance_wallet_outlined, color: AppTheme.primaryPink),
                      ),
                      const SizedBox(width: 16),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('\$12,500', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          Text('Total Expenses', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 3. View All Metrics Button
                CustomCard(
                  color: const Color(0xFFFCE4EC),
                  onTap: () {},
                  child: const Center(
                    child: Column(
                      children: [
                        Icon(Icons.keyboard_double_arrow_right, color: Colors.black87),
                        SizedBox(height: 8),
                        Text('View All Metrics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Detailed Performance', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // 4. Employees List Header
                const Text('Employees in Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                // 5. Employee List
                CustomCard(
                  hasShadow: true, // White card with shadow
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      _buildEmployeeTile('Alice Johnson', 'EMP-001', true),
                      _buildDivider(),
                      _buildEmployeeTile('Bob Smith', 'EMP-002', false),
                      _buildDivider(),
                      _buildEmployeeTile('Charlie Brown', 'EMP-003', true),
                      _buildDivider(),
                      _buildEmployeeTile('Diana Prince', 'EMP-004', true),
                      _buildDivider(),
                      _buildEmployeeTile('Ethan Hunt', 'EMP-005', false),
                    ],
                  ),
                ),
                const SizedBox(height: 100), // Space for floating button
              ],
            ),
          ),

          // 6. Floating Action Button (Download Report)
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_rounded, color: Colors.white),
              label: const Text('Download Excel Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF50057), // Hot Pink
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 4,
                shadowColor: const Color(0xFFF50057).withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String value, String label, IconData icon) {
    return CustomCard(
      color: const Color(0xFFFCE4EC),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryPink, size: 28),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildEmployeeTile(String name, String id, bool visited) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=${name.replaceAll(" ", "+")}&background=random'),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(id, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: visited ? const Color(0xFFF50057) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          visited ? 'Visited' : 'Not Visited',
          style: TextStyle(
            color: visited ? Colors.white : Colors.grey,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey.withValues(alpha: 0.1), height: 1, indent: 70, endIndent: 20);
  }
}