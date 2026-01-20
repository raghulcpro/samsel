import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sammsel/core/constants/app_constants.dart';
import 'package:sammsel/widgets/custom_card.dart';

class SuperAdminDashboard extends StatelessWidget {
  const SuperAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.shield_rounded, color: AppConstants.accentColorLight),
            SizedBox(width: 8),
            Text('Admin Console', style: TextStyle(fontWeight: FontWeight.bold, color: AppConstants.textDark)),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () => context.go('/profile'),
              icon: const Icon(Icons.person_outline_rounded, color: AppConstants.textDark)
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0,
              children: [
                _buildPinkStatCard('Locations', '142', '+12%', Icons.location_on_outlined),
                _buildPinkStatCard('Managers', '28', '+5%', Icons.business_center_outlined),
                _buildPinkStatCard('Employees', '850', '-2%', Icons.people_outline),
                _buildPinkStatCard('Visits', '1.2K', '+18%', Icons.bar_chart_rounded),
              ],
            ),
            const SizedBox(height: 24),

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

                  // Use push here to stack the screen so they can come back
                  _buildNavTile(context, 'Manage Employees', Icons.badge_outlined, () => context.push('/employee_dashboard')),

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
    return CustomCard(
      color: Colors.white,
      hasShadow: true,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: AppConstants.accentColorLight, size: 24),
              Text(
                  growth,
                  style: TextStyle(
                      color: growth.contains('+') ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold
                  )
              ),
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