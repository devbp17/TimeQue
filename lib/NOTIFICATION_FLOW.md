# Alur Navigasi Notifikasi Alarm - Dokumentasi

## 📋 Ringkasan
Ketika alarm yang dijadwalkan sudah mencapai waktunya, sistem akan menampilkan notifikasi. Ketika user menekan notifikasi tersebut, aplikasi akan mengarahkan user ke halaman `NotificationStop`.

## 🔄 Alur Lengkap

### 1. **Pembuatan Schedule & Penjadwalan Alarm**
   - **File**: `lib/screens/schedule_create.dart`
   - **Proses**:
     - User membuat schedule baru dengan judul, deskripsi, tanggal, dan jam
     - Schedule dikirim ke API dan mendapatkan ID dari server
     - `NotificationService.scheduleNotification()` dipanggil dengan:
       - `id`: Hash dari schedule ID
       - `title`: Judul schedule
       - `body`: Deskripsi schedule
       - `scheduledTime`: DateTime gabungan dari tanggal & jam yang dipilih
       - `payload`: Default adalah `'notificationStop'`

### 2. **Penjadwalan di NotificationService**
   - **File**: `lib/services/notification_service.dart`
   - **Metode**: `scheduleNotification()`
   - **Fitur Penting**:
     - Menggunakan timezone `Asia/Jakarta`
     - Suara custom: `jokowi_saya_akan_lawan` (Android)
     - Priority: HIGH untuk memastikan notifikasi ditampilkan
     - Payload: `'notificationStop'` ← **PENTING untuk navigasi**

### 3. **Trigger Notifikasi Saat Waktunya**
   - Sistem Android/iOS menampilkan notifikasi pada waktu yang dijadwalkan
   - Notifikasi menampilkan:
     - Judul: Schedule title
     - Body: Schedule description
     - Sound: Custom sound atau default

### 4. **User Menekan Notifikasi**
   Ada 2 skenario:

   #### 4a. **App Sedang Berjalan (Foreground/Background)**
   - **Callback**: `onDidReceiveNotificationResponse` di `NotificationService.initialize()`
   - **Proses**:
     ```dart
     if (payload == 'notificationStop') {
       navigatorKey?.currentState?.pushNamed('/notificationStop');
     }
     ```
   - Navigasi langsung ke `NotificationStop` screen

   #### 4b. **App Tidak Sedang Berjalan (Terminated)**
   - **Proses**:
     1. `main.dart` memanggil `NotificationService.initialize()`
     2. Mendapatkan `payloadOnLaunch` dari `getNotificationAppLaunchDetails()`
     3. Jika `payloadOnLaunch == 'notificationStop'`:
        ```dart
        navigatorKey.currentState?.pushNamed('/notificationStop');
        ```
     4. Navigasi ke `NotificationStop` screen setelah frame pertama

### 5. **NotificationStop Screen**
   - **File**: `lib/screens/notificationStop.dart`
   - **Fitur**:
     - ✅ Icon alarm berkedip (animasi)
     - 🔔 Teks "ALARM!" dengan pesan
     - ⏹️ Tombol "Stop Alarm" → Menghentikan alarm dan kembali ke home
     - 😴 Tombol "Snooze 5 Menit" → Menunda alarm 5 menit
     - 🚫 Back button dinonaktifkan saat alarm aktif

## 📱 UI/UX Flow

```
Schedule Created
       ↓
Alarm Triggered
       ↓
Notification Shown
       ↓
User Taps Notification
       ↓
NotificationStop Screen Displayed
       ├─ Stop Alarm → Back to Home
       └─ Snooze 5 Min → Back to Home
```

## 🛠️ Debugging

Untuk melihat alur notifikasi, cek log dengan keyword:
- `DEBUG scheduleNotification` - Info penjadwalan
- `DEBUG: onDidReceiveNotificationResponse` - User tap notifikasi
- `DEBUG: Navigasi ke /notificationStop` - Navigasi terjadi
- `Pending Notifications` - Daftar alarm yang dijadwalkan

## ⚙️ Konfigurasi Penting

### AndroidManifest.xml
Pastikan sudah ada:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
```

### pubspec.yaml
Pastikan dependencies:
```yaml
flutter_local_notifications: ^14.0.0 atau lebih baru
timezone: ^0.9.0 atau lebih baru
```

## 📝 Catatan Penting

1. **Payload**: Selalu gunakan `'notificationStop'` sebagai payload
2. **Timezone**: Set ke zona waktu lokal (Asia/Jakarta dalam kode)
3. **NavigatorKey**: Global navigator key di main.dart diperlukan untuk navigasi dari callback
4. **Permissions**: User harus memberikan izin notifikasi di Android 13+
5. **Sound File**: Custom sound harus ada di `res/raw/` folder (Android)

## 🔍 Testing Checklist

- [ ] Schedule dibuat dengan sukses
- [ ] Notifikasi muncul pada waktu yang dijadwalkan
- [ ] User dapat tap notifikasi saat app berjalan
- [ ] User dapat tap notifikasi saat app terminated
- [ ] Navigation ke NotificationStop screen berhasil
- [ ] Stop Alarm button berfungsi
- [ ] Snooze button berfungsi
- [ ] Back button tidak aktif saat alarm aktif
- [ ] Custom sound play saat notifikasi trigger
