// lib/screens/login_form_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import 'home_screen.dart'; // Untuk navigasi setelah login berhasil
import 'package:http/http.dart' as htttp;

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({super.key});

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String baseurl = ("https://backendtimeque-production-fdcf.up.railway.app/auth/login");

  Future<void> _authenticate() async {
    try {
      final res = await htttp.post(
        Uri.parse(baseurl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        }),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        if (data['token'] != null) {
          (await SharedPreferences.getInstance()).setString(
            'token',
              data['token'],
            );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login berhasil 🎉"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        await Future.delayed(const Duration(seconds: 1));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
        }
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

              // Title "Welcome Back!"
              Text(
                'Welcome Back!',
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
                "We're glad to see you again!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[700],
                ),
              ),

              const SizedBox(height: 40),

              // Section Title (optional, bisa dihapus)
              Text(
                'LOGIN TO YOUR ACCOUNT',
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
                hintText: 'Enter your email or phone',
                isPassword: false,
                icon: Icons.email_outlined,
                ControllerText: _emailController
              ),

              const SizedBox(height: 20),

              // Password Field
              _buildTextField(
                label: 'Password',
                hintText: 'Enter your password',
                isPassword: true,
                icon: Icons.lock_outline,
                ControllerText: _passwordController
              ),

              const SizedBox(height: 10),

              // Forgot password link
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Navigasi ke forgot password screen
                    print('Forgot password tapped');
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[600],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // Login Button
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
                    'Log in',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Divider dengan "or"
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'or',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Sign up link
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Kembali ke login screen
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign up',
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
    IconData? icon,
    required TextEditingController ControllerText
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
          controller: ControllerText,
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
            prefixIcon: icon != null
                ? Icon(icon, color: Colors.grey[600], size: 20)
                : null,
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      Icons.visibility_off,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    onPressed: () {
                      // Toggle password visibility
                    },
                  )
                : null,
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
