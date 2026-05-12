import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionService {
  // Cek dan minta izin notifikasi (Android 13+)
  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.status;

    if (status.isGranted) {
      print("Izin notifikasi sudah diberikan.");
      return true;
    }

    if (status.isDenied) {
      // Minta izin
      final result = await Permission.notification.request();
      if (result.isGranted) {
        print("Izin notifikasi diberikan.");
        return true;
      } else if (result.isPermanentlyDenied) {
        print("Izin notifikasi ditolak permanen. Arahkan ke pengaturan.");
        openAppSettings();
        return false;
      }
    } else if (status.isPermanentlyDenied) {
      print("Izin notifikasi ditolak permanen. Buka pengaturan.");
      openAppSettings();
      return false;
    }

    return false;
  }

  // Cek dan minta izin exact alarm (Android 14+ untuk alarmClock)
  static Future<bool> requestExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;

    if (status.isGranted) {
      print("Izin exact alarm sudah diberikan.");
      return true;
    }

    if (status.isDenied) {
      final result = await Permission.scheduleExactAlarm.request();
      if (result.isGranted) {
        print("Izin exact alarm diberikan.");
        return true;
      } else {
        print("Izin exact alarm ditolak.");
        return false;
      }
    }

    return false;
  }

  // Cek dan minta izin ignore battery optimization (opsional, untuk semua versi)
  static Future<bool> requestIgnoreBatteryOptimization() async {
    final status = await Permission.ignoreBatteryOptimizations.status;

    if (status.isGranted) {
      print("Sudah ignore battery optimization.");
      return true;
    }

    if (status.isDenied) {
      final result = await Permission.ignoreBatteryOptimizations.request();
      return result.isGranted;
    }

    return false;
  }

  // Tampilkan dialog edukasi sebelum meminta izin (opsional)
  static Future<void> showPermissionRationale(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Izin Diperlukan"),
        content: const Text(
          "Aplikasi ini memerlukan izin notifikasi dan alarm tepat waktu "
          "agar Anda mendapat pengingat jadwal tepat pada waktunya."
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Fungsi utama untuk meminta semua izin yang diperlukan
  static Future<bool> requestAllPermissions(BuildContext context) async {
    // Untuk Android 13+, izin notifikasi wajib
    final notifGranted = await requestNotificationPermission();
    if (!notifGranted) {
      // Tampilkan pesan jika ditolak
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notifikasi tidak diizinkan. Pengingat jadwal tidak akan muncul.")),
      );
    }

    // Untuk Android 14+, exact alarm diperlukan agar alarmClock bekerja
    final exactAlarmGranted = await requestExactAlarmPermission();
    if (!exactAlarmGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Izin alarm tepat waktu tidak diberikan. Notifikasi mungkin tidak muncul tepat waktu.")),
      );
    }

    // Opsional: meminta ignore battery optimization (bisa skip jika tidak ingin mengganggu user)
    // await requestIgnoreBatteryOptimization();

    return notifGranted && exactAlarmGranted;
  }
}
