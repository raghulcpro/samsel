import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sammsel/core/constants/app_constants.dart';
import 'package:sammsel/widgets/custom_button.dart';
import 'package:sammsel/widgets/input_field.dart';

class ExpenseEntryScreen extends StatefulWidget {
  const ExpenseEntryScreen({super.key});

  @override
  State<ExpenseEntryScreen> createState() => _ExpenseEntryScreenState();
}

class _ExpenseEntryScreenState extends State<ExpenseEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _remarksController = TextEditingController();
  DateTime? _selectedDate;

  // Travel Mode Dropdown
  String? _selectedTravelMode;
  final List<String> _travelModes = [
    'Car',
    'Rental Bike',
    'Train',
    'Bus',
    'Flight',
    'Other'
  ];

  // Mock receipt upload state
  String? _receiptFileName;

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    _remarksController.dispose();
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
            // UPDATED: dialogBackgroundColor is deprecated, moved to dialogTheme
            dialogTheme: const DialogThemeData(
              backgroundColor: AppConstants.secondaryBackgroundColorDark,
            ),
            // UPDATED: useMaterial3 is deprecated (default true now), removed
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _pickReceipt() {
    setState(() {
      _receiptFileName = 'receipt_document.pdf';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Receipt file mock selected: receipt_document.pdf'),
        backgroundColor: AppConstants.accentColorLight,
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Expense report submitted successfully!'),
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
        title: const Text('New Expense Report'),
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
                      // Travel Mode Dropdown
                      DropdownButtonFormField<String>(
                        // UPDATED: Using initialValue as value is deprecated in newer Flutter versions for this context
                        initialValue: _selectedTravelMode,
                        dropdownColor: AppConstants.secondaryBackgroundColorDark,
                        hint: const Text('Select Travel Mode', style: TextStyle(color: Colors.white54)),
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                        decoration: InputDecoration(
                          labelText: 'Travel Mode',
                          labelStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(Icons.commute_outlined, color: Colors.white70),
                          filled: true,
                          // UPDATED: using withValues instead of withOpacity
                          fillColor: Colors.white.withValues(alpha: 0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                            borderSide: const BorderSide(color: AppConstants.accentColorLight, width: 1.5),
                          ),
                        ),
                        items: _travelModes.map((String mode) {
                          return DropdownMenuItem<String>(
                            value: mode,
                            child: Text(mode),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedTravelMode = newValue;
                          });
                        },
                        validator: (value) => value == null ? 'Please select a travel mode' : null,
                      ),
                      const SizedBox(height: 20),
                      // Amount Field
                      InputField(
                        labelText: 'Amount',
                        hintText: '0.00',
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                        ],
                        prefixIcon: const Icon(Icons.currency_rupee, color: Colors.white70),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Please enter the amount';
                          if (double.tryParse(value) == null) return 'Please enter a valid number';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // Date Field
                      InputField(
                        labelText: 'Date',
                        hintText: 'Select Date',
                        controller: _dateController,
                        readOnly: true,
                        prefixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.white70),
                        onTap: () => _selectDate(context),
                        validator: (value) => (value == null || value.isEmpty) ? 'Please select a date' : null,
                      ),
                      const SizedBox(height: 20),
                      // Remarks Field
                      InputField(
                        labelText: 'Remarks',
                        hintText: 'Add notes here...',
                        controller: _remarksController,
                        maxLines: 3,
                        prefixIcon: const Icon(Icons.notes_outlined, color: Colors.white70),
                      ),
                      const SizedBox(height: 30),
                      // Receipt Upload Mock
                      Text(
                        'Receipt Attachment',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white70, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: _pickReceipt,
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.1), style: BorderStyle.solid),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _receiptFileName == null ? Icons.cloud_upload_outlined : Icons.check_circle_rounded,
                                color: _receiptFileName == null ? AppConstants.accentColorDark : Colors.greenAccent,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _receiptFileName ?? 'Upload Receipt Image',
                                style: TextStyle(color: _receiptFileName == null ? Colors.white70 : Colors.greenAccent),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: CustomButton(
                  text: 'SUBMIT EXPENSE',
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