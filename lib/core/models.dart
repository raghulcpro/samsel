
import 'package:sammsel/core/constants/app_constants.dart';

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? location;

  User({required this.id, required this.name, required this.email, required this.role, this.location});
}

class Visit {
  final String id;
  final String institutionName;
  final String type;
  final DateTime date;
  final String purpose;
  final String employeeName;

  Visit({required this.id, required this.institutionName, required this.type, required this.date, required this.purpose, required this.employeeName});
}

class Expense {
  final String id;
  final String mode;
  final double amount;
  final DateTime date;
  final String remarks;
  final String employeeName;

  Expense({required this.id, required this.mode, required this.amount, required this.date, required this.remarks, required this.employeeName});
}
