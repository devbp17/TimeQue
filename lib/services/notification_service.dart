import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // Inisialisasi
  // Mengembalikan payload jika aplikasi diluncurkan oleh notifikasi
  static Future<String?> initialize({GlobalKey<NavigatorState>? navigatorKey}) async {
    // Inisialisasi timezone
    tzdata.initializeTimeZones();
    // Atur zona waktu lokal (misal Asia/Jakarta)
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // ikon notifikasi
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Tangani ketika user mengetuk notifikasi (app foreground/background)
    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        print("DEBUG: onDidReceiveNotificationResponse dipanggil, payload=${response.payload}");
        final payload = response.payload;
        if (payload == 'notificationStop') {
          // Navigasi via navigatorKey karena callback tidak punya BuildContext
          print("DEBUG: Navigasi ke /notificationStop");
          navigatorKey?.currentState?.pushNamed('/notificationStop');
        }
      },
    );

    // Jika app diluncurkan oleh notifikasi (terminated -> launched),
    // ambil payload supaya main.dart bisa mengarahkan setelah runApp
    final NotificationAppLaunchDetails? launchDetails =
        await _plugin.getNotificationAppLaunchDetails();

    // Beberapa versi plugin menyimpan payload di tempat yang berbeda
    final String? payloadOnLaunch =
        launchDetails?.notificationResponse?.payload;

    return payloadOnLaunch;
  }

  // Meminta izin notifikasi (panggil di main.dart atau splash screen)
  static Future<void> requestPermissions() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions();
  }

  // Menjadwalkan notifikasi alarm
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload, // payload opsional
  }) async {
    // Jika waktu sudah lewat, tidak usah dijadwalkan
    print(
      "DEBUG scheduleNotification: dipanggil dengan id=$id, waktu=$scheduledTime",
    );
    if (scheduledTime.isBefore(DateTime.now())) {
      print("DEBUG scheduleNotification: Waktu sudah lewat, BATAL");
      return;
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'schedule_channel',
      'Jadwal Channel',
      channelDescription: 'Notifikasi untuk jadwal yang sudah dibuat',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true, // AKTIFKAN SUARA DEFAULT
      sound: RawResourceAndroidNotificationSound('jokowi_saya_akan_lawan'), // opsional: custom sound
    );
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      sound: 'default.wav',
      presentAlert: true,
      presentSound: true,
    );
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Konversi DateTime ke TZDateTime
    final tz.TZDateTime tzTime = tz.TZDateTime.from(scheduledTime, tz.local);

    try {
      print(
        "DEBUG scheduleNotification: tz.local=${tz.local.name}, tzTime=$tzTime",
      );
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tzTime,
        details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload ?? 'notificationStop', // ✅ PAYLOAD UNTUK NAVIGASI KE NOTIFICATIONSTOP
      );
      print("DEBUG scheduleNotification: zonedSchedule berhasil dipanggil");
      await debugPendingNotifications();
    } catch (e) {
      print("DEBUG scheduleNotification: ERROR saat zonedSchedule: $e");
    }
  }

  // Membatalkan notifikasi berdasarkan id
  static Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  // (Opsional) membatalkan semua notifikasi
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  static Future<void> debugPendingNotifications() async {
    final pending = await _plugin.pendingNotificationRequests();
    print("--- Pending Notifications (${pending.length}) ---");
    for (var p in pending) {
      print("ID: ${p.id}, Title: ${p.title}, Payload: ${p.payload}");
    }
  }

}
