import 'package:flutter/material.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  final Color _accentPink = const Color(0xFFF52F78);
  final Color _bgPinkTop = const Color(0xFFFDEFF6);
  final Color _inputFill = const Color(0xFFF2F4F7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_bgPinkTop, Colors.white, _bgPinkTop],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // --- Profile Picture Upload Section ---
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: _accentPink.withValues(alpha: 0.1),
                          child: Icon(Icons.person, size: 50, color: _accentPink),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(color: _accentPink, shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    _buildTextField(controller: _nameController, hintText: "Full Name", icon: Icons.person_outline),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _emailController, hintText: "Email Address", icon: Icons.mail_outline),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _mobileController, hintText: "Mobile Number", icon: Icons.phone_android_outlined, keyboardType: TextInputType.phone),
                    const SizedBox(height: 16),
                    _buildTextField(controller: _passwordController, hintText: "Password", icon: Icons.lock_outline, isPassword: true),

                    const SizedBox(height: 30),

                    // --- Sign Up Button ---
                    Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(colors: [Color(0xFFF52F78), Color(0xFFFF5996)]),
                        boxShadow: [BoxShadow(color: _accentPink.withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 5))],
                      ),
                      child: ElevatedButton(
                        onPressed: () { if (_formKey.currentState!.validate()) { /* Handle Sign Up */ } },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                        child: const Text("Sign Up", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),

                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Already have an account? Log In", style: TextStyle(color: _accentPink, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hintText, required IconData icon, bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(color: _inputFill, borderRadius: BorderRadius.circular(16)),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey.shade600),
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          suffixIcon: isPassword ? IconButton(
            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey.shade600),
            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          ) : null,
        ),
      ),
    );
  }
}