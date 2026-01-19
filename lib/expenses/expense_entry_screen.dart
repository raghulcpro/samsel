import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sammsel/core/constants/app_constants.dart';

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

  // State variables
  DateTime? _selectedDate;
  String? _selectedTravelMode;
  String? _receiptFileName;

  final List<String> _travelModes = ['Car', 'Train', 'Bus', 'Bike','Rental Bike','Other'];

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
            colorScheme: const ColorScheme.light(primary: AppConstants.accentColorLight),
            // FIX: dialogBackgroundColor is deprecated. Use dialogTheme.
            dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _pickReceipt() {
    setState(() => _receiptFileName = 'receipt.pdf');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Receipt Attached')),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // FIX: Using the "unused" fields here to simulate real logic
      debugPrint('Submitting Date: $_selectedDate');
      debugPrint('Receipt: $_receiptFileName');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense Submitted!'), backgroundColor: Colors.green),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('New Expense', style: TextStyle(color: AppConstants.textDark, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppConstants.textDark),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            physics: const BouncingScrollPhysics(),
            children: [
              // Banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppConstants.primaryBgTop, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.wallet_rounded, color: AppConstants.accentColorLight),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Expense Claim", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppConstants.textDark)),
                          Text("Fill details for reimbursement", style: TextStyle(fontSize: 12, color: AppConstants.textLight)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),

              const Text('Total Amount', style: TextStyle(color: AppConstants.textDark, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppConstants.accentColorLight),
                decoration: InputDecoration(
                  prefixIcon: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('₹', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppConstants.textDark))
                  ),
                  filled: true,
                  fillColor: AppConstants.inputFill,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),

              const Text('Travel Mode', style: TextStyle(color: AppConstants.textDark, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),

              // FIX: Used initialValue instead of value to fix deprecation warning
              DropdownButtonFormField<String>(
                initialValue: _selectedTravelMode,
                decoration: _inputDecoration(Icons.commute_outlined),
                dropdownColor: Colors.white,
                items: _travelModes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (val) => setState(() => _selectedTravelMode = val),
              ),
              const SizedBox(height: 20),

              _buildField('Date', _dateController, Icons.calendar_today_rounded, isReadOnly: true, onTap: () => _selectDate(context)),
              const SizedBox(height: 20),

              _buildField('Remarks', _remarksController, Icons.notes, maxLines: 3),
              const SizedBox(height: 24),

              // Attachment Button (using _receiptFileName)
              InkWell(
                onTap: _pickReceipt,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppConstants.accentColorLight.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Icon(
                          _receiptFileName == null ? Icons.cloud_upload_outlined : Icons.check_circle,
                          color: AppConstants.accentColorLight, size: 32
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _receiptFileName ?? 'Upload Receipt',
                        style: const TextStyle(color: AppConstants.accentColorLight, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.accentColorLight,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('SUBMIT CLAIM', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, {bool isReadOnly = false, VoidCallback? onTap, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppConstants.textDark, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: isReadOnly,
          onTap: onTap,
          maxLines: maxLines,
          decoration: _inputDecoration(icon),
          validator: (val) => val!.isEmpty ? 'Required' : null,
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: AppConstants.inputFill,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}