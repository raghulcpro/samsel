import 'package:flutter/material.dart';
import 'package:sammsel/core/constants/app_constants.dart';
import 'package:sammsel/widgets/custom_button.dart';
import 'package:sammsel/widgets/input_field.dart';
import 'package:intl/intl.dart';

class VisitEntryScreen extends StatefulWidget {
  const VisitEntryScreen({super.key});

  @override
  State<VisitEntryScreen> createState() => _VisitEntryScreenState();
}

class _VisitEntryScreenState extends State<VisitEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _schoolController = TextEditingController();
  final _visitDateController = TextEditingController();
  final _inTimeController = TextEditingController();
  final _outTimeController = TextEditingController();
  final _purposeController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedInTime;
  TimeOfDay? _selectedOutTime;

  // Institution Type Dropdown
  String? _selectedInstitutionType;
  final List<String> _institutionTypes = [
    'School',
    'College',
    'University',
    'Other'
  ];

  @override
  void dispose() {
    _schoolController.dispose();
    _visitDateController.dispose();
    _inTimeController.dispose();
    _outTimeController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppConstants.accentColorLight,
              onPrimary: Colors.white,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: AppConstants.secondaryBackgroundColorDark,
            useMaterial3: true,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _visitDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isInTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isInTime ? (_selectedInTime ?? TimeOfDay.now()) : (_selectedOutTime ?? TimeOfDay.now()),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppConstants.accentColorLight,
              onPrimary: Colors.white,
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: AppConstants.secondaryBackgroundColorDark,
            useMaterial3: true,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isInTime) {
          _selectedInTime = picked;
          _inTimeController.text = picked.format(context);
        } else {
          _selectedOutTime = picked;
          _outTimeController.text = picked.format(context);
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Visit report submitted successfully!'),
          backgroundColor: Colors.greenAccent,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Consistent with global gradient
      appBar: AppBar(
        title: const Text('New Visit Report'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      InputField(
                        labelText: 'School / College Name',
                        hintText: 'Enter institution name',
                        controller: _schoolController,
                        prefixIcon: const Icon(Icons.school_outlined, color: Colors.white70),
                        validator: (value) => (value == null || value.isEmpty) ? 'Please enter institution name' : null,
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _selectedInstitutionType,
                        dropdownColor: AppConstants.secondaryBackgroundColorDark,
                        hint: const Text('Select Institution Type', style: TextStyle(color: Colors.white54)),
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                        decoration: InputDecoration(
                          labelText: 'Institution Type',
                          labelStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(Icons.category_outlined, color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                            borderSide: const BorderSide(color: AppConstants.accentColorLight, width: 1.5),
                          ),
                        ),
                        items: _institutionTypes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedInstitutionType = newValue;
                          });
                        },
                        validator: (value) => value == null ? 'Please select institution type' : null,
                      ),
                      const SizedBox(height: 20),
                      InputField(
                        labelText: 'Visit Date',
                        hintText: 'Select Date',
                        controller: _visitDateController,
                        readOnly: true,
                        prefixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.white70),
                        onTap: () => _selectDate(context),
                        validator: (value) => (value == null || value.isEmpty) ? 'Please select a visit date' : null,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: InputField(
                              labelText: 'In Time',
                              hintText: 'HH:MM',
                              controller: _inTimeController,
                              readOnly: true,
                              prefixIcon: const Icon(Icons.access_time_outlined, color: Colors.white70),
                              onTap: () => _selectTime(context, true),
                              validator: (value) => (value == null || value.isEmpty) ? 'Select In' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InputField(
                              labelText: 'Out Time',
                              hintText: 'HH:MM',
                              controller: _outTimeController,
                              readOnly: true,
                              prefixIcon: const Icon(Icons.access_time_outlined, color: Colors.white70),
                              onTap: () => _selectTime(context, false),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Select Out';
                                if (_selectedInTime != null && _selectedOutTime != null) {
                                  final inMin = _selectedInTime!.hour * 60 + _selectedInTime!.minute;
                                  final outMin = _selectedOutTime!.hour * 60 + _selectedOutTime!.minute;
                                  if (outMin <= inMin) return 'Invalid time';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      InputField(
                        labelText: 'Purpose of Visit',
                        hintText: 'Describe purpose...',
                        controller: _purposeController,
                        maxLines: 3,
                        prefixIcon: const Icon(Icons.description_outlined, color: Colors.white70),
                        validator: (value) => (value == null || value.isEmpty) ? 'Please enter purpose' : null,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: CustomButton(
                  text: 'SUBMIT VISIT REPORT',
                  onPressed: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
