// lib/utils/constants.dart
import 'package:flutter/material.dart';

class AppColors {
  static const backgroundColor = Color(0xFFE6EEFA);
  static const black = Colors.black;
  static const white = Colors.white;
  static const grey300 = Color(0xFFD1D5DB); // Untuk border
  static const grey400 = Color(0xFF9CA3AF); // Untuk hint text
  static const grey600 = Color(0xFF4B5563); // Untuk label
  static const grey700 = Color(0xFF374151); // Untuk text
  
    // Tambahan untuk Instagram style
  static const instagramBlue = Color(0xFF0095F6);
  static const instagramBackground = Color(0xFFFAFAFA);
  static const cardShadow = Color.fromRGBO(0, 0, 0, 0.1);

  // Tambahan untuk homescreen
  static const primaryBlue =   Color(0xFF007AFF); // Warna biru tombol
  static const lightBackground = Color(0xFFF8F9FA); // Background lebih terang
  
  // Tambahkan untuk schedule create
  static const purplePrimary = Color(0xFF6B46C1);
  static const purpleLight = Color(0xFF9F7AEA);
}

class AppTextStyles {
  static const TextStyle kasteloLarge = TextStyle(
    fontFamily: 'KasteloVultra',
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.0,
  );
  
  static const TextStyle kasteloMedium = TextStyle(
    fontFamily: 'KasteloVultra',
    fontSize: 32,
    fontWeight: FontWeight.w700,
  );
  
  static const TextStyle kasteloSmall = TextStyle(
    fontFamily: 'KasteloVultra',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  
  static const TextStyle kasteloButton = TextStyle(
    fontFamily: 'KasteloVultra',
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  
  // Tambahan untuk homescreen
  static const TextStyle kasteloTitle = TextStyle(
    fontFamily: 'KasteloVultra',
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle kasteloBody = TextStyle(
    fontFamily: 'KasteloVultra',
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  
  static const TextStyle kasteloAppBar = TextStyle(
    fontFamily: 'KasteloVultra',
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  
}