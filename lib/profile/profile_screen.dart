
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sammsel/auth/auth_service.dart';
import 'package:sammsel/core/constants/app_constants.dart';
import 'package:sammsel/widgets/custom_card.dart';
import 'package:sammsel/widgets/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final roleName = authService.currentRole.name.replaceAll('_', ' ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppConstants.accentColorLight,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              'User Name', // Mock name
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              roleName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppConstants.accentColorDark),
            ),
            const SizedBox(height: 32),
            CustomCard(
              child: Column(
                children: [
                  _buildProfileTile(Icons.email_outlined, 'Email', 'user@samsel.com'),
                  const Divider(color: Colors.white10),
                  _buildProfileTile(Icons.badge_outlined, 'Employee ID', 'EMP12345'),
                  const Divider(color: Colors.white10),
                  _buildProfileTile(Icons.location_on_outlined, 'Assigned Location', 'Metropolis Branch'),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'LOGOUT',
                onPressed: () {
                  authService.logout();
                },
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
          Icon(icon, color: Colors.white54, size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
