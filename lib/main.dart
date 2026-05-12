import 'package:flutter/material.dart';
import 'package:proyek/screens/bottomNavbar.dart';
import 'package:proyek/services/notification_service.dart';
import 'package:proyek/services/permission_services.dart';
import 'screens/intro_screen.dart';
import 'screens/home_screen.dart';
import 'screens/schedule_create.dart';
import 'screens/notificationStop.dart';

// Global navigator key so notification callbacks can navigate without a BuildContext
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification service and get payload if app was launched by a notification
  final String? payloadOnLaunch =
      await NotificationService.initialize(navigatorKey: navigatorKey);

  runApp(MyApp(payloadOnLaunch: payloadOnLaunch));
}

class MyApp extends StatefulWidget {
  final String? payloadOnLaunch;
  const MyApp({super.key, this.payloadOnLaunch});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Jika app dibuka karena notifikasi dan payload sesuai, navigasi setelah frame pertama
    if (widget.payloadOnLaunch == 'notificationStop') {
      print('DEBUG: payloadOnLaunch adalah notificationStop');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print('DEBUG: Navigasi ke /notificationStop dari payload on launch');
        navigatorKey.currentState?.pushNamed('/notificationStop');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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
        '/': (context) => const PermissionAwareIntroScreen(), // Ubah sementara
        '/bottom-navbar': (context) => BottomNavbar(),
        '/home': (context) => const HomeScreen(),
        '/schedule-create': (context) => const addSchedule(),
        '/notificationStop': (context) => const NotificationStop(),
      },
    );
  }
}

// Buat wrapper untuk IntroScreen yang meminta izin saat pertama kali
class PermissionAwareIntroScreen extends StatelessWidget {
  const PermissionAwareIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Minta izin saat pertama kali muncul
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await PermissionService.requestAllPermissions(context);
    });

    return const IntroScreen();
  }
}
