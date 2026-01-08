import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sammsel/auth/auth_service.dart';
import 'package:sammsel/auth/login_screen.dart';
import 'package:sammsel/core/constants/app_constants.dart';
import 'package:sammsel/core/theme/app_theme.dart';
import 'package:sammsel/main_layout.dart';

// Import Dashboard Screens
import 'package:sammsel/dashboard/employee_dashboard.dart';
import 'package:sammsel/dashboard/manager_dashboard.dart';
import 'package:sammsel/dashboard/super_admin_dashboard.dart';

// Import other screens
import 'package:sammsel/reports/reports_screen.dart';
import 'package:sammsel/profile/profile_screen.dart';
import 'package:sammsel/visits/visit_entry_screen.dart';
import 'package:sammsel/expenses/expense_entry_screen.dart';

void main() {
  runApp(
    // Using ChangeNotifierProvider since AuthService extends ChangeNotifier
    ChangeNotifierProvider<AuthService>(
      create: (_) => AuthService(),
      child: const SamselApp(),
    ),
  );
}

class SamselApp extends StatefulWidget {
  const SamselApp({super.key});

  @override
  State<SamselApp> createState() => _SamselAppState();
}

class _SamselAppState extends State<SamselApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final authService = Provider.of<AuthService>(context, listen: false);
    _router = _buildRouter(authService);
  }

  GoRouter _buildRouter(AuthService authService) {
    return GoRouter(
      refreshListenable: GoRouterRefreshStream(authService.currentUserRole),
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) {
            return authService.currentRole != UserRole.none
                ? MainLayout(child: child)
                : const LoginScreen();
          },
          routes: [
            GoRoute(
              path: '/super_admin_dashboard',
              builder: (context, state) => const SuperAdminDashboard(),
            ),
            GoRoute(
              path: '/manager_dashboard',
              builder: (context, state) => const ManagerDashboard(),
            ),
            GoRoute(
              path: '/employee_dashboard',
              builder: (context, state) => const EmployeeDashboard(),
            ),
            GoRoute(
              path: '/reports',
              builder: (context, state) => const ReportsScreen(),
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
            GoRoute(
              path: '/visit_entry',
              builder: (context, state) => const VisitEntryScreen(),
            ),
            GoRoute(
              path: '/expense_entry',
              builder: (context, state) => const ExpenseEntryScreen(),
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        final loggedIn = authService.currentRole != UserRole.none;
        final goingToLogin = state.uri.path == '/login';

        if (!loggedIn && !goingToLogin) {
          return '/login';
        }
        if (loggedIn && goingToLogin) {
          switch (authService.currentRole) {
            case UserRole.superAdmin:
              return '/super_admin_dashboard';
            case UserRole.manager:
              return '/manager_dashboard';
            case UserRole.employee:
              return '/employee_dashboard';
            default:
              return '/login';
          }
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,

      // --- THIS IS THE KEY CHANGE ---
      theme: AppTheme.lightTheme,
      // ----------------------------

      routerConfig: _router,
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}