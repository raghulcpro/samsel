import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:sammsel/core/constants/app_constants.dart';

class VisitEntryScreen extends StatefulWidget {
  const VisitEntryScreen({super.key});

  @override
  State<VisitEntryScreen> createState() => _VisitEntryScreenState();
}

class _VisitEntryScreenState extends State<VisitEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mapController = MapController(); // Controller to handle map movement

  // -- Controllers --
  final _schoolController = TextEditingController();
  final _areaController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _purposeController = TextEditingController();
  final _specimenDetailsController = TextEditingController();
  final _dateController = TextEditingController();
  final _inTimeController = TextEditingController();
  final _outTimeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _inTime;
  TimeOfDay? _outTime;

  // -- Location State --
  LatLng? _currentPosition;
  bool _isGettingLocation = true;
  String _locationStatus = "Fetching location...";

  String? _selectedSchoolType;
  final List<String> _schoolTypes = ['State Board', 'CBSE', 'Matriculation', 'ICSE', 'College', 'Other'];
  String? _selectedCatalogueType;
  final List<String> _catalogueTypes = ['Science Books', 'Math Guides', 'Language Arts', 'General Knowledge', 'Semester Books', 'Other'];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    _inTime = TimeOfDay.now();
    _getCurrentLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inTimeController.text.isEmpty && _inTime != null) {
      _inTimeController.text = _inTime!.format(context);
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if(mounted) setState(() { _isGettingLocation = false; _locationStatus = "GPS disabled"; });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if(mounted) setState(() { _isGettingLocation = false; _locationStatus = "Permission denied"; });
        return;
      }
    }

    try {
      // Use LocationSettings for new Geolocator API
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );

      Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);

      if (!mounted) return;

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      // Move map to new location
      _mapController.move(_currentPosition!, 15.0);

      // Reverse Geocoding
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String address = "${place.subLocality ?? ''}, ${place.locality ?? ''}";
          if (address.startsWith(', ')) address = address.substring(2);
          setState(() { _areaController.text = address; _isGettingLocation = false; });
        }
      } catch (_) {
        setState(() { _areaController.text = "${position.latitude}, ${position.longitude}"; _isGettingLocation = false; });
      }
    } catch (e) {
      if(mounted) setState(() { _isGettingLocation = false; _locationStatus = "Error fetching location"; });
    }
  }

  // Snap map back to user location
  void _recenterMap() {
    if (_currentPosition != null) {
      _mapController.move(_currentPosition!, 15.0);
    }
  }

  // ... (Keep existing _pickDate, _pickTime, dispose methods unchanged) ...
  @override
  void dispose() {
    _schoolController.dispose(); _areaController.dispose(); _contactPersonController.dispose();
    _purposeController.dispose(); _specimenDetailsController.dispose(); _dateController.dispose();
    _inTimeController.dispose(); _outTimeController.dispose(); _mapController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async { /* ... same as before ... */ }
  Future<void> _pickTime(bool isOutTime) async { /* ... same as before ... */ }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_currentPosition == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location required!')));
        return;
      }
      // Submit Logic: Send _currentPosition.latitude & longitude to backend
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Visit Report Submitted!'), backgroundColor: Colors.green));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('New Visit Entry', style: TextStyle(color: Color(0xFF555555), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF555555)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 12.0, left: 4),
                child: Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 20, color: AppConstants.accentColorLight),
                    SizedBox(width: 8),
                    Text('Location Verification', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF555555))),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // --- MAP SECTION ---
                    SizedBox(
                      height: 200, // Taller map for better visibility
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            _isGettingLocation
                                ? const Center(child: CircularProgressIndicator(color: AppConstants.accentColorLight))
                                : _currentPosition == null
                                ? Center(child: Text(_locationStatus, style: const TextStyle(color: Colors.red)))
                                : FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                initialCenter: _currentPosition!,
                                initialZoom: 15.0,
                                // ALLOW INTERACTION (Zoom/Pan enabled)
                                interactionOptions: const InteractionOptions(
                                  flags: InteractiveFlag.all,
                                ),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.sammsel',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: _currentPosition!, // Fixed to GPS
                                      width: 40,
                                      height: 40,
                                      child: const Icon(
                                        Icons.location_on,
                                        color: AppConstants.accentColorLight,
                                        size: 40,
                                        shadows: [Shadow(blurRadius: 10, color: Colors.black26)],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Recenter Button
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: FloatingActionButton.small(
                                onPressed: _recenterMap,
                                backgroundColor: Colors.white,
                                child: const Icon(Icons.my_location, color: AppConstants.accentColorLight),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // ... Existing TextFields (Date, School, Area, Type) ...
                    _buildTextField(controller: _dateController, label: 'Date', icon: Icons.calendar_today_rounded, isReadOnly: true, onTap: _pickDate),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _schoolController, label: 'School Name', icon: Icons.school_outlined),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _areaController, label: 'Detected Area', icon: Icons.map_outlined, isReadOnly: true, hint: 'Fetching...'),
                    const SizedBox(height: 16),
                    _buildDropdown(label: 'School Type', value: _selectedSchoolType, items: _schoolTypes, icon: Icons.category_outlined, onChanged: (val) => setState(() => _selectedSchoolType = val)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // ... Rest of the UI (Contact, Submit Button) ...
              // (Include the rest of your form fields here as before)

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.accentColorLight,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('SUBMIT REPORT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ... Helper Widgets (_buildTextField, _buildDropdown) remain the same ...
  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, bool isReadOnly = false, VoidCallback? onTap, String? hint}) {
    return TextFormField(
      controller: controller, readOnly: isReadOnly, onTap: onTap,
      decoration: InputDecoration(
        labelText: label, prefixIcon: Icon(icon, color: AppConstants.accentColorLight),
        filled: true, fillColor: const Color(0xFFF9FAFC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      validator: (val) => (val == null || val.isEmpty) ? 'Required' : null,
    );
  }

  Widget _buildDropdown({required String label, required String? value, required List<String> items, required IconData icon, required Function(String?) onChanged}) {
    return DropdownButtonFormField<String>(
      initialValue: value, items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(), onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label, prefixIcon: Icon(icon, color: AppConstants.accentColorLight),
        filled: true, fillColor: const Color(0xFFF9FAFC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}