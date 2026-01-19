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
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Row(
          children: [
            Icon(Icons.shield, color: AppTheme.primaryPink),
            SizedBox(width: 8),
            Text(
              'Samsel',
              style: TextStyle(
                fontFamily: 'BrushScript',
                color: Color(0xFFD8276A),
                fontSize: 28,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person_outline_rounded, color: Colors.black54),
          ),
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
              childAspectRatio: 0.85,
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
              color: const Color(0xFFFCE4EC),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Daily Activity Trend', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Insights into user engagement over the last week.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 24),
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
                _buildNavAction(context, 'Employees\nDirectory', Icons.groups, () => context.go('/employee_dashboard')),
                _buildNavAction(context, 'Reports &\nExport', Icons.description_outlined, () => context.go('/reports')),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPinkStatCard(BuildContext context, String title, String value, String subtext, IconData icon) {
    final bool isPositive = subtext.contains('+');
    return CustomCard(
      color: const Color(0xFFFCE4EC),
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
                isPositive ? Icons.arrow_outward_rounded : Icons.arrow_downward_rounded,
                size: 14,
                color: isPositive ? Colors.green : Colors.redAccent,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  subtext,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isPositive ? Colors.green.shade700 : Colors.redAccent.shade700
                  ),
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

class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD8276A) // Updated to brand color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFD8276A).withValues(alpha: 0.2), // Updated syntax
          Colors.transparent,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.9, size.width * 0.5, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.1, size.width, size.height * 0.4);

    canvas.drawPath(path, fillPaint..style = PaintingStyle.fill); // Draw fill first
    canvas.drawPath(path, paint); // Draw line on top
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}