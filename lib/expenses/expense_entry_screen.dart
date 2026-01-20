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

  // -- Controllers --
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _remarksController = TextEditingController();

  // -- State Variables --
  DateTime? _selectedDate;

  // -- Dynamic Dropdown State --
  String _selectedCategory = 'Travel';
  String? _selectedSubCategory;

  // -- Lists --
  final List<String> _categories = ['Travel', 'Food', 'Lodging', 'Other'];
  final List<String> _travelModes = ['Car', 'Train', 'Bus', 'Flight', 'Auto/Cab'];
  final List<String> _foodTypes = ['Breakfast', 'Lunch', 'Dinner', 'Client Meeting', 'Snacks/Tea'];

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
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense Submitted Successfully!'), backgroundColor: Colors.green),
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
              // --- BANNER ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppConstants.primaryBgTop, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Icon(
                          _selectedCategory == 'Food' ? Icons.restaurant_rounded : Icons.wallet_rounded,
                          color: AppConstants.accentColorLight
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "$_selectedCategory Claim",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppConstants.textDark)
                          ),
                          const Text("Fill details for reimbursement", style: TextStyle(fontSize: 12, color: AppConstants.textLight)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- 1. CATEGORY SELECTION ---
              const Text('Expense Category', style: TextStyle(color: AppConstants.textDark, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;
                    return ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: AppConstants.accentColorLight,
                      labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppConstants.textDark,
                          fontWeight: FontWeight.bold
                      ),
                      backgroundColor: AppConstants.inputFill,
                      onSelected: (bool selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = cat;
                            _selectedSubCategory = null;
                          });
                        }
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
                      showCheckmark: false,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // --- 2. DYNAMIC SUB-CATEGORY ---
              if (_selectedCategory == 'Travel') ...[
                const Text('Travel Mode', style: TextStyle(color: AppConstants.textDark, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _buildDropdown(
                  hint: 'Select Mode (e.g. Bus, Train)',
                  icon: Icons.commute_outlined,
                  items: _travelModes,
                ),
              ] else if (_selectedCategory == 'Food') ...[
                const Text('Meal Type', style: TextStyle(color: AppConstants.textDark, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _buildDropdown(
                  hint: 'Select Meal (e.g. Lunch, Client Treat)',
                  icon: Icons.restaurant_menu_rounded,
                  items: _foodTypes,
                ),
              ],
              const SizedBox(height: 20),

              // --- 3. AMOUNT (Rupees) ---
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

              // --- 4. DATE ---
              _buildField('Date', _dateController, Icons.calendar_today_rounded, isReadOnly: true, onTap: () => _selectDate(context)),
              const SizedBox(height: 20),

              // --- 5. REMARKS ---
              _buildField('Remarks', _remarksController, Icons.notes, maxLines: 3),
              const SizedBox(height: 40),

              // --- SUBMIT BUTTON ---
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

  // --- Widgets ---

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

  Widget _buildDropdown({required String hint, required IconData icon, required List<String> items}) {
    return DropdownButtonFormField<String>(
      key: ValueKey(_selectedCategory),
      initialValue: _selectedSubCategory,
      decoration: _inputDecoration(icon),
      dropdownColor: Colors.white,
      hint: Text(hint, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      items: items.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
      onChanged: (val) => setState(() => _selectedSubCategory = val),
      validator: (val) => val == null ? 'Please select option' : null,
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