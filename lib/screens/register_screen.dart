// lib/screens/register_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proyek/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import 'login_form_screen.dart';
import 'package:http/http.dart' as htttp;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String baseurl = ("https://backendtimeque-production-fdcf.up.railway.app/auth/register");

  Future<void> _authenticate() async {
    try {
      final res = await htttp.post(
        Uri.parse(baseurl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );
      if ( res.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registrasi berhasil 🎉"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      await Future.delayed(const Duration(seconds: 1));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginFormScreen()),
          );
      }
    } catch (e) {
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Title "Welcome!"
              Text(
                'Welcome!',
                style: TextStyle(
                  fontFamily: 'KasteloVultra',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              // Subtitle
              Text(
                "We're excited to see you!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[700],
                ),
              ),

              const SizedBox(height: 40),

              // Section Title
              Text(
                'ACCOUNT INFORMATION',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 25),

              // Email/Phone Field
              _buildTextField(
                label: 'Email or phone Number',
                hintText: 'Enter your email',
                Textcontroller: _emailController,
                isPassword: false,
              ),

              const SizedBox(height: 20),

              //username field
              _buildTextField(
                label: 'Username',
                hintText: 'Enter your username',
                Textcontroller: _nameController,
                isPassword: false,
              ),

              // Password Field
              _buildTextField(
                label: 'Password',
                hintText: 'Enter your password',
                Textcontroller: _passwordController,
                isPassword: true,
              ),

              const SizedBox(height: 10),

              // Password hint
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  'Use 8 or more characters with a mix of letters, numbers & symbols',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // Register Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _authenticate();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Already have account link
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginFormScreen(),
                      ),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      children: const [
                        TextSpan(
                          text: 'Log in',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
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

  Widget _buildTextField({
    required String label,
    required String hintText,
    required bool isPassword,
    required TextEditingController Textcontroller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: Textcontroller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
