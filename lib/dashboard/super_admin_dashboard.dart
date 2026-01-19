import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sammsel/core/constants/app_constants.dart';

class SuperAdminDashboard extends StatelessWidget {
  const SuperAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Row(
              children: [
                Icon(Icons.shield_rounded, color: AppConstants.accentColorLight, size: 28),
                SizedBox(width: 12),
                Text('Admin Console', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppConstants.textDark)),
              ],
            ),
            const SizedBox(height: 24),

            // 1. Top Stats Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildPinkStatCard('Locations', '142', '+12%', Icons.location_on_outlined),
                _buildPinkStatCard('Managers', '28', '+5%', Icons.business_center_outlined),
                _buildPinkStatCard('Employees', '850', '-2%', Icons.people_outline),
                _buildPinkStatCard('Visits', '1.2K', '+18%', Icons.bar_chart_rounded),
              ],
            ),
            const SizedBox(height: 24),

            // 2. Navigation Actions
            const Text("Quick Management", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppConstants.textDark)),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.05), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  _buildNavTile(context, 'Manage Locations', Icons.map_outlined, () {}),
                  Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
                  _buildNavTile(context, 'Manage Employees', Icons.badge_outlined, () => context.go('/employee_dashboard')),
                  Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
                  _buildNavTile(context, 'System Reports', Icons.file_copy_outlined, () => context.go('/reports')),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildPinkStatCard(String title, String value, String growth, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.05), blurRadius: 10)],
        border: Border.all(color: AppConstants.primaryBgTop),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: AppConstants.accentColorLight, size: 24),
              Text(growth, style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppConstants.textDark)),
              Text(title, style: const TextStyle(fontSize: 13, color: AppConstants.textLight)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavTile(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppConstants.inputFill, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppConstants.textDark, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppConstants.textDark)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
    );
  }
}