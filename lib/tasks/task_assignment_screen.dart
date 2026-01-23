import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sammsel/core/constants/app_constants.dart';
import 'package:sammsel/models/task_model.dart';

class TaskAssignmentScreen extends StatefulWidget {
  const TaskAssignmentScreen({super.key});

  @override
  State<TaskAssignmentScreen> createState() => _TaskAssignmentScreenState();
}

class _TaskAssignmentScreenState extends State<TaskAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _deadlineController = TextEditingController();

  String? _selectedAssigneeId;
  TaskPriority _selectedPriority = TaskPriority.medium;
  DateTime? _selectedDate;

  // Mock Employees (Fetch from DB in real app)
  final List<Map<String, String>> _employees = [
    {'id': 'E1', 'name': 'Alice Johnson'},
    {'id': 'E2', 'name': 'Bob Smith'},
    {'id': 'E3', 'name': 'Charlie Brown'},
  ];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppConstants.accentColorLight),
          dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _deadlineController.text = DateFormat('MMM dd, yyyy').format(picked);
      });
    }
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      // 1. Create the Task Object
      // 2. Save to Firebase/Database (Simulated here)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task Assigned Successfully!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Assign New Task', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_titleController, 'Task Title', Icons.title),
              const SizedBox(height: 16),

              // Assignee Dropdown
              DropdownButtonFormField<String>(
                decoration: _inputDecoration('Assign To', Icons.person_search),
                initialValue: _selectedAssigneeId,
                items: _employees.map((e) => DropdownMenuItem(value: e['id'], child: Text(e['name']!))).toList(),
                onChanged: (val) => setState(() => _selectedAssigneeId = val),
              ),
              const SizedBox(height: 16),

              _buildTextField(_descController, 'Description', Icons.description, maxLines: 3),
              const SizedBox(height: 16),

              // Date & Priority Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _deadlineController,
                      readOnly: true,
                      onTap: _pickDate,
                      decoration: _inputDecoration('Deadline', Icons.calendar_today),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<TaskPriority>(
                      initialValue: _selectedPriority,
                      decoration: _inputDecoration('Priority', Icons.flag),
                      items: TaskPriority.values.map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p.name.toUpperCase())
                      )).toList(),
                      onChanged: (val) => setState(() => _selectedPriority = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.accentColorLight,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('ASSIGN TASK', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: _inputDecoration(label, icon),
      validator: (val) => val!.isEmpty ? 'Required' : null,
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: AppConstants.inputFill,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }
}