// lib/screens/login_screen.dart - PERBAIKAN BAGIAN TOMBOL
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'register_screen.dart';
import 'login_form_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          // BACKGROUND PATTERN
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/grup.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          
          // KONTEN UTAMA
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    
                    Text(
                      'TimeQue',
                      style: AppTextStyles.kasteloLarge.copyWith(
                        color: Colors.black,
                        fontSize: 44,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    
                    const Spacer(flex: 1),
                    
                    Text(
                      'Welcome to TimeQue',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'KasteloVultra',
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        height: 1.3,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Join with us to help you bring a\nbetter future for yourself and others.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tombol Register - YANG BENAR
                        SizedBox(
                          width: 220,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
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
                        
                        const SizedBox(height: 15),
                        
                        // Tombol Login - YANG BENAR
                        SizedBox(
                          width: 220,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginFormScreen(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Log in',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}