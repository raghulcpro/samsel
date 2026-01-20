import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammsel/auth/auth_service.dart';
import 'package:sammsel/core/constants/app_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final roleName = authService.currentRole.name.replaceAll('_', ' ').toUpperCase();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(color: AppConstants.textDark, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // AVATAR SECTION
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppConstants.accentColorLight, width: 2),
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: AppConstants.inputFill,
                child: Icon(Icons.person, size: 50, color: AppConstants.textLight),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'User Name',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppConstants.textDark),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppConstants.accentColorLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                roleName,
                style: const TextStyle(
                    color: AppConstants.accentColorLight,
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                ),
              ),
            ),
            const SizedBox(height: 32),

            // DETAILS CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                children: [
                  _buildProfileTile(Icons.email_outlined, 'Email', 'user@samsel.com'),
                  Divider(color: Colors.grey.withValues(alpha: 0.1)),
                  _buildProfileTile(Icons.badge_outlined, 'Employee ID', 'EMP12345'),
                  Divider(color: Colors.grey.withValues(alpha: 0.1)),
                  _buildProfileTile(Icons.location_on_outlined, 'Location', 'Metropolis Branch'),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => authService.logout(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.redAccent,
                  elevation: 0,
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('LOGOUT', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppConstants.inputFill,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppConstants.textLight, size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: AppConstants.textLight, fontSize: 12)),
              Text(
                  value,
                  style: const TextStyle(
                      color: AppConstants.textDark,
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }
}