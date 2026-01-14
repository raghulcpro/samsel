import 'dart:async';
import 'package:flutter/material.dart'; // Import for ChangeNotifier and debugPrint
import 'package:sammsel/core/constants/app_constants.dart';

class AuthService extends ChangeNotifier {
  UserRole _currentUserRole = UserRole.none;
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
      notifyListeners(); // Notify listeners for UI update
      return false;
    }

    _authController.add(_currentUserRole);
    notifyListeners(); // Notify listeners for UI update
    return true;
  }

  // New mock signup method
  Future<bool> signup(String name, String email, String mobile, String password) async {
    // Simulate network delay for signup
    await Future.delayed(const Duration(milliseconds: 1000));

    // In a real app, you'd integrate with a backend here (e.g., Firebase, REST API)
    // For now, we'll just simulate a successful signup.
    // UPDATED: Replaced print with debugPrint for production safety
    debugPrint('Mock Signup Attempt:');
    debugPrint('Name: $name');
    debugPrint('Email: $email');
    debugPrint('Mobile: $mobile');
    debugPrint('Password: $password (not stored in mock)');

    // You could add some mock logic here, e.g., fail if email is 'existing@example.com'
    if (email == 'existing@example.com') {
      return false;
    }

    return true; // Simulate successful signup
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