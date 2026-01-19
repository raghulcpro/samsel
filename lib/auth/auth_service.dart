import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sammsel/core/constants/app_constants.dart';

class AuthService extends ChangeNotifier {
  UserRole _currentUserRole = UserRole.none;
  final _authController = StreamController<UserRole>.broadcast();

  Stream<UserRole> get currentUserRole => _authController.stream;

  UserRole get currentRole => _currentUserRole;

  // UPDATED: 'login' now accepts 'role'
  Future<bool> login(String email, String password, String role) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 700));

    // MOCK VALIDATION:
    if (email.isEmpty || password.isEmpty) {
      return false;
    }

    // LOGIC FIX: Assign role based on Dropdown Selection
    switch (role) {
      case 'Admin':
        _currentUserRole = UserRole.superAdmin;
        break;
      case 'Manager':
        _currentUserRole = UserRole.manager;
        break;
      case 'Executive':
        _currentUserRole = UserRole.employee;
        break;
      default:
        _currentUserRole = UserRole.none;
        return false;
    }

    _authController.add(_currentUserRole);
    notifyListeners();
    return true;
  }

  // FIXED: Removed undefined '$role' from debugPrint
  Future<bool> signup(String name, String email, String mobile, String password) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    // ERROR WAS HERE: Removed $role
    debugPrint('Mock Signup Attempt: $name, $email, $mobile');

    if (email == 'existing@example.com') {
      return false;
    }
    return true;
  }

  void logout() {
    _currentUserRole = UserRole.none;
    _authController.add(_currentUserRole);
    notifyListeners();
  }

  @override
  void dispose() {
    _authController.close();
    super.dispose();
  }
}