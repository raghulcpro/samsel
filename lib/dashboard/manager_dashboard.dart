import 'package:flutter/material.dart';
import 'package:sammsel/core/constants/app_constants.dart';
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
            Row(
              children: [
                Expanded(child: _buildStatBox('42', 'Employees', Icons.people_outline)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatBox('28', 'Visits Today', Icons.calendar_today_outlined)),
              ],
            ),
            const SizedBox(height: 16),

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
}