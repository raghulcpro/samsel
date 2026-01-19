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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppConstants.primaryBgTop,
              Colors.white,
              AppConstants.primaryBgTop
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(child: child),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              // FIX: Replaced withOpacity with withValues (newer Flutter)
              color: AppConstants.accentColorLight.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => _onItemTapped(index, context, role),
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppConstants.accentColorLight,
          unselectedItemColor: Colors.grey.shade400,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics_outlined),
              activeIcon: Icon(Icons.analytics_rounded),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}