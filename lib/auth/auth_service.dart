import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sammsel/core/constants/app_constants.dart';

class AuthService extends ChangeNotifier {
  UserRole _currentUserRole = UserRole.none;

  // Stream to notify GoRouter (keep this for routing)
  final _authController = StreamController<UserRole>.broadcast();
  Stream<UserRole> get currentUserRole => _authController.stream;

  UserRole get currentRole => _currentUserRole;

  Future<bool> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 700));

    if (email == AppConstants.superAdminEmail && password == AppConstants.superAdminPassword) {
      _currentUserRole = UserRole.superAdmin;
    } else if (email == AppConstants.managerEmail && password == AppConstants.managerPassword) {
      _currentUserRole = UserRole.manager;
    } else if (email == AppConstants.employeeEmail && password == AppConstants.employeePassword) {
      _currentUserRole = UserRole.employee;
    } else {
      _currentUserRole = UserRole.none;
      _authController.add(_currentUserRole);
      notifyListeners(); // Update UI
      return false;
    }

    _authController.add(_currentUserRole);
    notifyListeners(); // Update UI
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