# 📊 VISUAL GUIDE - Alarm Notification Flow

## 🎯 What Changed

```
BEFORE                          AFTER
┌──────────────────┐           ┌──────────────────┐
│ NotificationStop │           │ NotificationStop │
│                  │           │                  │
│   Halo           │    →      │  🔔 ALARM!       │
│                  │           │  Berkedip (animated)
└──────────────────┘           │  ──────────────  │
                               │                  │
                               │  ⏹️  Stop Alarm  │
                               │  😴  Snooze 5m   │
                               └──────────────────┘
```

---

## 🔄 Complete Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│ USER INTERFACE                                                  │
└─────────────────────────────────────────────────────────────────┘

    Schedule Creation Screen
           │
           │ User fills: Title, Desc, Date, Time
           ▼
    schedule_create.dart
           │
           │ Calls: ApiSchedule.AddSchedule()
           ▼
    ┌─────────────────────────────────┐
    │ BACKEND API                     │
    │ POST /schedule/AddSchedule      │
    │ Response: Scheduleuser (with ID)│
    └────────────────┬────────────────┘
                     │
                     ▼
    NotificationService.scheduleNotification()
           │
           ├─ id: schedule.id.hashCode
           ├─ title: schedule.title
           ├─ body: schedule.description
           ├─ scheduledTime: DateTime(...)
           └─ payload: 'notificationStop'
                     │
                     ▼
    ┌─────────────────────────────────┐
    │ ANDROID/iOS SYSTEM              │
    │ Set alarm in system scheduler   │
    │ Timezone: Asia/Jakarta          │
    │ Priority: HIGH                  │
    │ Sound: Custom (jokowi_...)      │
    └────────────────┬────────────────┘
                     │
           [TIME PASSES...]
                     │
                     ▼
    [At Scheduled Time]
    System Notification Shown
    Title: Schedule title
    Body: Schedule description
                     │
                     ▼
    User Taps Notification
                     │
         ┌───────────┴───────────┐
         │                       │
         ▼                       ▼
    [APP RUNNING]           [APP TERMINATED]
         │                       │
         │ Callback triggered:   │ App Launched
         │ onDidReceive...       │ getNotificationAppLaunch...
         │ Response event        │ Payload captured
         │                       │
         └───────────┬───────────┘
                     │
                     ▼
    Check if payload == 'notificationStop'
                     │
                     ▼ YES
    navigatorKey.pushNamed('/notificationStop')
                     │
                     ▼
    ┌──────────────────────────────┐
    │ NotificationStop Screen      │
    │                              │
    │      🔔 ALARM!               │ ← Animated
    │ Saatnya untuk memulai tugas   │
    │                              │
    │  ┌─────────────────────────┐ │
    │  │  ⏹️  STOP ALARM         │ │
    │  └─────────────────────────┘ │
    │                              │
    │  ┌─────────────────────────┐ │
    │  │  😴  SNOOZE 5 MENIT    │ │
    │  └─────────────────────────┘ │
    └───────────┬──────────────────┘
                │
        ┌───────┴───────┐
        │               │
        ▼               ▼
    STOP ALARM    SNOOZE 5m
        │               │
        │ setState:     │ Show snackbar
        │ _isAlarm...   │
        │               │
        ▼               ▼
    Navigate to        Navigate to
    /bottom-navbar     /bottom-navbar
```

---

## 📱 Screen UI Layout

```
NotificationStop Screen Layout
┌──────────────────────────────────────┐
│                                      │
│         🔔 (Animated)                │
│         Size: 80x80                  │
│                                      │
├──────────────────────────────────────┤
│                                      │
│           ALARM!                     │
│     (FontSize: 36, Bold)             │
│                                      │
│  Saatnya untuk memulai tugas Anda   │
│     (FontSize: 16, Grey)             │
│                                      │
├──────────────────────────────────────┤
│                                      │
│   ┌────────────────────────────┐   │
│   │   ⏹️  STOP ALARM           │   │
│   │                            │   │
│   │ Height: 60, Bg: #4A3F83   │   │
│   └────────────────────────────┘   │
│                                      │
│   ┌────────────────────────────┐   │
│   │   😴  SNOOZE 5 MENIT      │   │
│   │                            │   │
│   │ Height: 60, Outlined      │   │
│   └────────────────────────────┘   │
│                                      │
└──────────────────────────────────────┘
```

---

## 🎬 Animation Details

### Alarm Icon Animation
```
Frame 1:  🔔 (scale: 0.8)
Frame 2:  🔔 (scale: 0.85)
Frame 3:  🔔 (scale: 0.9)
Frame 4:  🔔 (scale: 0.95)
Frame 5:  🔔 (scale: 1.0)
Frame 6:  🔔 (scale: 1.05)
Frame 7:  🔔 (scale: 1.1)
Frame 8:  🔔 (scale: 1.15)
Frame 9:  🔔 (scale: 1.2)
[REPEAT] ...

Duration: 500ms per cycle
```

---

## 🔐 State Management

```
_NotificationStopState
    │
    ├─ _isAlarmActive: bool = true
    │
    ├─ Methods:
    │  ├─ _stopAlarm()
    │  │  └─ setState(_isAlarmActive = false)
    │  │     showSnackBar("Alarm telah dihentikan")
    │  │     delay(1s) → navigate to /bottom-navbar
    │  │
    │  └─ _snoozeAlarm()
    │     ├─ showSnackBar("Alarm ditunda 5 menit")
    │     └─ navigate to /bottom-navbar
    │
    └─ onWillPop:
       └─ return !_isAlarmActive (prevent back if alarm active)
```

---

## 🚦 Navigation Routes

```
routes: {
  '/': IntroScreen,
  '/bottom-navbar': BottomNavbar,
  '/home': HomeScreen,
  '/schedule-create': addSchedule,
  '/notificationStop': NotificationStop,  ← NEW/UPDATED
}
```

---

## 📦 Payload Flow

```
schedule_create.dart
    │
    └─ NotificationService.scheduleNotification(
         title: "Contoh",
         body: "Ini alarm test",
         payload: 'notificationStop'  ← DEFAULT
       )
          │
          └─ _plugin.zonedSchedule(
               payload: payload ?? 'notificationStop'
             )
                │
                └─ [At scheduled time]
                   │
                   ├─ onDidReceiveNotificationResponse
                   │  └─ if (payload == 'notificationStop')
                   │     └─ pushNamed('/notificationStop')
                   │
                   └─ getNotificationAppLaunchDetails()
                      └─ if (payloadOnLaunch == 'notificationStop')
                         └─ pushNamed('/notificationStop')
```

---

## ⚙️ Configuration Overview

```
main.dart
  ├─ GlobalKey<NavigatorState> navigatorKey
  ├─ MaterialApp(navigatorKey: navigatorKey)
  └─ routes['/notificationStop'] = NotificationStop()

notification_service.dart
  ├─ initialize()
  │  ├─ onDidReceiveNotificationResponse callback
  │  └─ getNotificationAppLaunchDetails()
  └─ scheduleNotification()
     ├─ payload: 'notificationStop'
     ├─ timezone: Asia/Jakarta
     └─ priority: HIGH

notificationStop.dart
  ├─ _isAlarmActive state
  ├─ _stopAlarm() method
  ├─ _snoozeAlarm() method
  └─ WillPopScope (prevent back)
```

---

## 🎨 Color & Style Reference

```
Primary Color: #4A3F83 (Purple)
Background: #E6EEFA (Light Purple)
Icon Color: #4A3F83
Button: ElevatedButton (filled, rounded)
Outlined Button: OutlinedButton (bordered)
Font: KasteloVultra
```

---

## 📊 Data Flow

```
User Input
    ↓
Schedule API Call
    ↓
Notification Scheduled
    ↓
System Alarm Triggered
    ↓
Notification Shown
    ↓
User Interaction
    ├─ Tap Notification → NavigatorKey Route
    ├─ Stop Button → setState + Navigate
    └─ Snooze Button → Navigate
```

---

## ✅ Implementation Checklist

- [x] NotificationStop screen rewritten
- [x] UI with animated icon
- [x] Stop Alarm button functional
- [x] Snooze button functional
- [x] Back button protection
- [x] Payload routing configured
- [x] Debug logging added
- [x] No compilation errors
- [x] No unused imports
- [x] Ready for testing
