import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sammsel/auth/auth_service.dart';
import 'package:sammsel/core/constants/app_constants.dart';
import 'package:provider/provider.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.contains('dashboard')) return 0;
    if (location.contains('reports')) return 1;
    if (location.contains('profile')) return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context, UserRole role) {
    switch (index) {
      case 0:
        if (role == UserRole.superAdmin) {
          context.go('/super_admin_dashboard');
        } else if (role == UserRole.manager) {
          context.go('/manager_dashboard');
        } else {
          context.go('/employee_dashboard');
        }
        break;
      case 1:
        context.go('/reports');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final role = authService.currentRole;
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      extendBody: true, // Allows content to show behind the blurred nav bar
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppConstants.primaryBackgroundColorDark,
              AppConstants.secondaryBackgroundColorDark,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: child,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: AppConstants.accentColorLight.withValues(alpha: 0.2),
              labelTextStyle: WidgetStateProperty.all(
                const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white70,
                ),
              ),
            ),
            child: NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) => _onItemTapped(index, context, role),
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.grid_view_rounded, color: Colors.white70),
                  selectedIcon: Icon(Icons.grid_view_rounded, color: AppConstants.accentColorLight),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.analytics_outlined, color: Colors.white70),
                  selectedIcon: Icon(Icons.analytics_rounded, color: AppConstants.accentColorLight),
                  label: 'Reports',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded, color: Colors.white70),
                  selectedIcon: Icon(Icons.person_rounded, color: AppConstants.accentColorLight),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
