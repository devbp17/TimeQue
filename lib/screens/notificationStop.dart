import 'package:flutter/material.dart';

class NotificationStop extends StatefulWidget {
  const NotificationStop({super.key});

  @override
  State<NotificationStop> createState() => _NotificationStopState();
}

class _NotificationStopState extends State<NotificationStop> {
  bool _isAlarmActive = true;

  void _stopAlarm() {
    setState(() {
      _isAlarmActive = false;
    });

    // Tampilkan notifikasi sukses
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alarm telah dihentikan'),
        duration: Duration(seconds: 2),
      ),
    );

    // Kembali ke home screen setelah 1 detik
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/bottom-navbar',
          (route) => false,
        );
      }
    });
  }

  void _snoozeAlarm() {
    // Snooze alarm selama 5 menit
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alarm ditunda 5 menit'),
        duration: Duration(seconds: 2),
      ),
    );

    // Kembali ke home screen
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/bottom-navbar',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Cegah back button ketika alarm aktif
        return !_isAlarmActive;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFE6EEFA),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon alarm yang berkedip
                    if (_isAlarmActive)
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.8, end: 1.2),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: child,
                          );
                        },
                        onEnd: () {
                          // Animasi loop
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.alarm,
                          size: 80,
                          color: Color(0xFF4A3F83),
                        ),
                      ),
                    if (!_isAlarmActive)
                      const Icon(
                        Icons.check_circle,
                        size: 80,
                        color: Colors.green,
                      ),
                    const SizedBox(height: 32),

                    // Teks alarm
                    Text(
                      _isAlarmActive ? 'ALARM!' : 'Alarm Dihentikan',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A3F83),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Jam saat ini atau pesan
                    Text(
                      _isAlarmActive
                          ? 'Saatnya untuk memulai tugas Anda'
                          : 'Tugas Anda dimulai nanti',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Tombol-tombol aksi
                    if (_isAlarmActive)
                      Column(
                        children: [
                          // Tombol Stop (besar)
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton.icon(
                              onPressed: _stopAlarm,
                              icon: const Icon(Icons.check),
                              label: const Text('Stop Alarm'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4A3F83),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Tombol Snooze
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: OutlinedButton.icon(
                              onPressed: _snoozeAlarm,
                              icon: const Icon(Icons.schedule),
                              label: const Text('Snooze 5 Menit'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF4A3F83),
                                side: const BorderSide(
                                  color: Color(0xFF4A3F83),
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (!_isAlarmActive)
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/bottom-navbar',
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A3F83),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Kembali ke Home'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
