import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sammsel/core/constants/app_constants.dart';


class VisitEntryScreen extends StatefulWidget {
  const VisitEntryScreen({super.key});

  @override
  State<VisitEntryScreen> createState() => _VisitEntryScreenState();
}

class _VisitEntryScreenState extends State<VisitEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  // -- Controllers --
  final _schoolController = TextEditingController();
  final _areaController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _purposeController = TextEditingController();
  final _specimenDetailsController = TextEditingController();
  final _dateController = TextEditingController();
  final _inTimeController = TextEditingController();
  final _outTimeController = TextEditingController();

  // -- State Variables --
  DateTime? _selectedDate;
  TimeOfDay? _inTime;
  TimeOfDay? _outTime;

  String? _selectedSchoolType;
  final List<String> _schoolTypes = [
    'State Board', 'CBSE', 'Matriculation', 'ICSE', 'College', 'Other'
  ];

  String? _selectedCatalogueType;
  final List<String> _catalogueTypes = [
    'Science Books', 'Math Guides', 'Language Arts', 'General Knowledge', 'Semester Books', 'Other'
  ];

  @override
  void initState() {
    super.initState();
    // 1. Automatically set Date to Today
    _selectedDate = DateTime.now();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);

    // 2. Automatically set In-Time to Current Time
    _inTime = TimeOfDay.now();
    // We defer the text formatting to 'didChangeDependencies' or just format it here simply
    // Note: format(context) needs context, so we do it in a post-frame callback or lazy init.
    // For safety, we'll format it in the build method if empty, or use a helper.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inTimeController.text.isEmpty && _inTime != null) {
      _inTimeController.text = _inTime!.format(context);
    }
  }

  @override
  void dispose() {
    _schoolController.dispose();
    _areaController.dispose();
    _contactPersonController.dispose();
    _purposeController.dispose();
    _specimenDetailsController.dispose();
    _dateController.dispose();
    _inTimeController.dispose();
    _outTimeController.dispose();
    super.dispose();
  }

  // -- Pickers --
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
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
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _pickTime(bool isOutTime) async {
    final initial = isOutTime
        ? (_outTime ?? TimeOfDay.now())
        : (_inTime ?? TimeOfDay.now());

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppConstants.accentColorLight),
          timePickerTheme: const TimePickerThemeData(backgroundColor: Colors.white),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() {
        if (isOutTime) {
          _outTime = picked;
          _outTimeController.text = picked.format(context);
        } else {
          _inTime = picked;
          _inTimeController.text = picked.format(context);
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Visit Report Submitted!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      appBar: AppBar(
        title: const Text('New Visit Entry', style: TextStyle(color: Color(0xFF555555), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF555555)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- SECTION 1: LOCATION DETAILS ---
              _buildSectionHeader('Institution Details', Icons.school_rounded),
              Container(
                decoration: _cardDecoration(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _dateController,
                      label: 'Date',
                      icon: Icons.calendar_today_rounded,
                      isReadOnly: true,
                      onTap: _pickDate,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _schoolController,
                      label: 'School Name',
                      icon: Icons.school_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _areaController,
                      label: 'Area / Location',
                      icon: Icons.map_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildDropdown(
                      label: 'School Type',
                      value: _selectedSchoolType,
                      items: _schoolTypes,
                      icon: Icons.category_outlined,
                      onChanged: (val) => setState(() => _selectedSchoolType = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- SECTION 2: TIMING & CONTACT ---
              _buildSectionHeader('Visit Timing & Contact', Icons.access_time_filled_rounded),
              Container(
                decoration: _cardDecoration(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _contactPersonController,
                      label: 'Contact Person',
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _inTimeController,
                            label: 'In Time',
                            icon: Icons.login_rounded,
                            isReadOnly: true,
                            onTap: () => _pickTime(false),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: _outTimeController,
                            label: 'Out Time',
                            icon: Icons.logout_rounded,
                            isReadOnly: true,
                            onTap: () => _pickTime(true),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- SECTION 3: CATALOGUE & PURPOSE ---
              _buildSectionHeader('Catalogue & Purpose', Icons.menu_book_rounded),
              Container(
                decoration: _cardDecoration(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _purposeController,
                      label: 'Purpose of Visit',
                      icon: Icons.assignment_turned_in_outlined,
                    ),
                    const SizedBox(height: 16),

                    // Catalogue Type Dropdown
                    _buildDropdown(
                      label: 'Catalogue Type',
                      value: _selectedCatalogueType,
                      items: _catalogueTypes,
                      icon: Icons.library_books_outlined,
                      onChanged: (val) => setState(() => _selectedCatalogueType = val),
                    ),
                    const SizedBox(height: 16),

                    // Specimen Details (Under Catalogue)
                    _buildTextField(
                      controller: _specimenDetailsController,
                      label: 'Specimen Details',
                      icon: Icons.description_outlined,
                      maxLines: 3,
                      hint: 'Enter details of samples given...',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- SUBMIT BUTTON ---
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.accentColorLight, // Pink
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: AppConstants.accentColorLight.withValues(alpha: 0.4),
                  ),
                  child: const Text(
                    'SUBMIT REPORT',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets for Cleaner UI ---

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppConstants.accentColorLight),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF555555), // TextDark
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.05),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
      border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isReadOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      onTap: onTap,
      maxLines: maxLines,
      style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF333333)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        prefixIcon: Icon(icon, color: AppConstants.accentColorLight, size: 22),
        filled: true,
        fillColor: const Color(0xFFF9FAFC), // Very light grey fill
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.accentColorLight, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
      style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF333333), fontSize: 16),
      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: Icon(icon, color: AppConstants.accentColorLight, size: 22),
        filled: true,
        fillColor: const Color(0xFFF9FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppConstants.accentColorLight, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (val) => val == null ? 'Please select $label' : null,
    );
  }
}