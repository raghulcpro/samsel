import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sammsel/widgets/custom_card.dart';
import 'package:sammsel/core/theme/app_theme.dart';

class SuperAdminDashboard extends StatelessWidget {
  const SuperAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.shield, color: AppTheme.primaryPink),
            SizedBox(width: 8),
            Text('Samsel'),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.person_outline_rounded)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Stats Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85, // Adjust for height
              children: [
                _buildPinkStatCard(context, 'Total Locations', '142', '+12% Last Month', Icons.location_on_outlined),
                _buildPinkStatCard(context, 'Total Managers', '28', '+5% Last Month', Icons.business_center_outlined),
                _buildPinkStatCard(context, 'Total Employees', '850', '-2% Last Month', Icons.people_outline),
                _buildPinkStatCard(context, 'Total Visits Today', '1.2K', '+18% Since Yesterday', Icons.bar_chart_rounded),
              ],
            ),
            const SizedBox(height: 24),

            // 2. Daily Activity Trend (Chart Card)
            CustomCard(
              color: const Color(0xFFFCE4EC), // Light pink background
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Daily Activity Trend', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Insights into user engagement over the last week.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 24),
                  // Simple Custom Paint for the Wavy Chart
                  SizedBox(
                    height: 80,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: _ChartPainter(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Bottom Navigation Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildNavAction(context, 'Locations\nManagement', Icons.gps_fixed, () {}),
                _buildNavAction(context, 'Managers\nAccounts', Icons.manage_accounts, () {}),
                _buildNavAction(context, 'Employees\nDirectory', Icons.groups, () => context.go('/employee_dashboard')), // Demo link
                _buildNavAction(context, 'Reports &\nExport', Icons.description_outlined, () => context.go('/reports')),
              ],
            ),
            const SizedBox(height: 80), // Bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildPinkStatCard(BuildContext context, String title, String value, String subtext, IconData icon) {
    return CustomCard(
      color: const Color(0xFFFCE4EC), // Light pink
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: AppTheme.primaryPink, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
          Row(
            children: [
              Icon(
                subtext.contains('+') ? Icons.arrow_outward_rounded : Icons.arrow_downward_rounded,
                size: 14,
                color: Colors.black54,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  subtext,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black54),
                  maxLines: 2,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildNavAction(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return CustomCard(
      color: const Color(0xFFFCE4EC),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.primaryPink, size: 28),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Simple Painter to draw the pink wave
class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFF4081)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFFFF4081).withOpacity(0.3), Colors.white.withOpacity(0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.cubicTo(size.width * 0.2, size.height * 0.5, size.width * 0.4, size.height * 0.9, size.width * 0.6, size.height * 0.6);
    path.cubicTo(size.width * 0.8, size.height * 0.3, size.width * 0.9, size.height * 0.6, size.width, size.height * 0.4);

    canvas.drawPath(path, paint);

    // Close path for fill
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}