// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/intro_screen.dart';
import 'screens/home_screen.dart';
import 'screens/schedule_create.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'On.Time',
      theme: ThemeData(
        fontFamily: 'KasteloVultra',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE6EEFA),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const IntroScreen(),
        '/home': (context) => const HomeScreen(),
        '/schedule-create': (context) => const addSchedule(),
        // HAPUS schedule-result route karena tidak dipakai lagi
      },
    );
  }
} 