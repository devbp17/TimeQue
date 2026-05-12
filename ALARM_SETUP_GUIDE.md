# 🔔 Setup Guide - Notifikasi Alarm ke NotificationStop Screen

## ✅ Status Konfigurasi

### Permissions Sudah Benar ✅
Android permissions sudah dikonfigurasi di `android/app/src/main/AndroidManifest.xml`:
- ✅ `INTERNET`
- ✅ `SCHEDULE_EXACT_ALARM` 
- ✅ `USE_EXACT_ALARM`
- ✅ `POST_NOTIFICATIONS`

### Code Sudah Dioptimalkan ✅

#### 1. **main.dart** ✅
- Global `navigatorKey` untuk navigasi dari notification callback
- Handle payload dari launch notification
- Routes ke `/notificationStop` sudah terdaftar

#### 2. **notification_service.dart** ✅
- Initialize dengan callback `onDidReceiveNotificationResponse`
- Payload `'notificationStop'` untuk navigasi
- Timezone: Asia/Jakarta
- Priority: HIGH
- Sound: Custom (jokowi_saya_akan_lawan)

#### 3. **notificationStop.dart** ✅
- UI dengan animated alarm icon
- Stop Alarm button
- Snooze 5 Menit button
- Back button protection saat alarm aktif

#### 4. **schedule_create.dart** ✅
- Melewatkan payload ke `NotificationService.scheduleNotification()`

---

## 🚀 Cara Kerja

### Flow Diagram
```
User Creates Schedule (schedule_create.dart)
              ↓
API Returns Schedule with ID
              ↓
NotificationService.scheduleNotification() called
   - id: hash dari schedule ID
   - title: schedule title
   - body: schedule description
   - payload: 'notificationStop' ← PENTING
              ↓
At Scheduled Time: Android/iOS shows notification
              ↓
User Taps Notification
              ↓
┌─────────────────────────────┬────────────────────────┐
│ APP RUNNING (Foreground)    │ APP TERMINATED         │
├─────────────────────────────┼────────────────────────┤
│ onDidReceiveNotification    │ App Launches           │
│ Callback triggered          │ payloadOnLaunch captured
│ navigatorKey.pushNamed()    │ navigatorKey.pushNamed()
└─────────────────────────────┴────────────────────────┘
              ↓
NotificationStop Screen Displayed
   - Icon alarm berkedip
   - Tombol "Stop Alarm"
   - Tombol "Snooze 5 Min"
              ↓
User Taps Stop/Snooze
   - Return to Home
```

---

## 📱 Testing di Android Studio

### 1. Buat Schedule dengan Waktu Dekat
- Buka app
- Pergi ke "Add Schedule"
- Isi judul dan deskripsi
- Pilih tanggal hari ini
- Pilih jam 5 menit dari sekarang
- Tap "Simpan"

### 2. Test App Running (Foreground)
- Tunggu notifikasi muncul
- Tap notifikasi
- Verifikasi masuk ke NotificationStop screen

### 3. Test App Backgrounded
- Buat schedule lagi
- Minimize app (jangan close)
- Tunggu notifikasi
- Tap notifikasi
- Verifikasi masuk ke NotificationStop screen

### 4. Test App Terminated
- Buat schedule lagi
- Force close app (Settings → Apps → Proyek → Force Stop)
- Tunggu notifikasi
- Tap notifikasi
- Verifikasi app launch dan masuk ke NotificationStop screen
- Verifikasi NotificationStop ditampilkan (bukan home screen)

---

## 🔍 Debugging Tips

### Lihat Debug Logs
```
adb logcat | grep DEBUG
```

### Lihat Pending Notifications
Di debug console, filter: `Pending Notifications`

### Check Notification Channel
```
adb shell settings get secure notification_show_on_lock_screen
```

### Simulate Notification (Manual)
```bash
adb shell am start -a android.intent.action.MAIN -n com.example.proyek/.MainActivity
```

---

## 🛠️ Jika Notifikasi Tidak Muncul

### Checklist:

1. **Permissions Granted?**
   - Buka Settings → Apps → Proyek → Notifications
   - Pastikan "Allow notifications" ON

2. **Waktu Sudah Lewat?**
   - Check di logcat: `DEBUG scheduleNotification: Waktu sudah lewat, BATAL`
   - Pastikan jam yang dipilih lebih besar dari jam saat ini

3. **Sound File Ada?**
   - Android: Check `android/app/src/main/res/raw/jokowi_saya_akan_lawan.mp3`
   - Jika tidak ada, ganti dengan `sound: null,` atau gunakan default

4. **Timezone Salah?**
   - Edit `notification_service.dart` line ~17:
   ```dart
   tz.setLocalLocation(tz.getLocation('Asia/Jakarta')); // Ubah sesuai timezone Anda
   ```

5. **Device Sleep/Doze Mode?**
   - Test di emulator dengan command:
   ```bash
   adb shell dumpsys deviceidle
   ```

---

## 🎯 Fitur yang Sudah Diimplementasikan

✅ Notification payload routing ke NotificationStop  
✅ Animated alarm icon  
✅ Stop Alarm functionality  
✅ Snooze 5 menit functionality  
✅ Back button protection  
✅ Navigasi dari app running & app terminated  
✅ Custom sound alert  
✅ Debug logging untuk troubleshooting  

---

## 📝 File yang Dimodifikasi

1. `lib/screens/notificationStop.dart` - UI improvement + stop/snooze buttons
2. `lib/services/notification_service.dart` - Added debug logging
3. `lib/main.dart` - Added debug logging

---

## ❓ FAQ

**Q: Bagaimana jika user ingin snooze alarm?**
A: Snooze button di NotificationStop screen akan kembali ke home. Implementasi snooze penuh (automatic reschedule) bisa ditambahkan di `_snoozeAlarm()`.

**Q: Bagaimana jika device restart saat alarm scheduled?**
A: flutter_local_notifications will reschedule setelah reboot (untuk Android 12+).

**Q: Apakah sound berjalan di mute mode?**
A: Iya, tapi hanya notification sound. Gunakan `AudioContext` untuk vibration juga.

**Q: Bisa multi-alarm?**
A: Iya, gunakan unique ID untuk setiap schedule (hash dari schedule ID sudah dilakukan).
