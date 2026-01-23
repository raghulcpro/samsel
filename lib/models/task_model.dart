import 'package:flutter/material.dart';

enum TaskPriority { high, medium, low }
enum TaskStatus { pending, inProgress, completed }

class Task {
  final String id;
  final String title;
  final String description;
  final String assignerId;
  final String assigneeId;
  final String assigneeName;
  final DateTime deadline;
  final TaskPriority priority;
  TaskStatus status;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignerId,
    required this.assigneeId,
    required this.assigneeName,
    required this.deadline,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    required this.createdAt,
  });
}