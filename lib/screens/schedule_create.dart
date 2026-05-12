import 'package:flutter/material.dart';
import 'package:proyek/models/schedule_model.dart';
import 'package:proyek/services/notification_service.dart';
import 'package:proyek/services/schedule_service.dart';

class addSchedule extends StatefulWidget {
  const addSchedule({super.key});

  @override
  State<addSchedule> createState() => _addScheduleState();
}

class _addScheduleState extends State<addSchedule> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _jamController = TextEditingController(); // ✅ TAMBAHAN

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Schedule")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _judulController,
              decoration: const InputDecoration(hintText: "Judul"),
            ),

            TextField(
              controller: _deskripsiController,
              decoration: const InputDecoration(hintText: "Deskripsi"),
            ),

            /// 📅 PILIH TANGGAL
            TextField(
              controller: _tanggalController,
              decoration: const InputDecoration(hintText: "Tanggal"),
              readOnly: true,
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );

                if (picked != null) {
                  _tanggalController.text = picked.toIso8601String();
                }
              },
            ),

            /// ⏰ PILIH JAM (BARU)
            TextField(
              controller: _jamController,
              decoration: const InputDecoration(hintText: "Jam"),
              readOnly: true,
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (picked != null) {
                  // format 24 jam biar aman
                  _jamController.text =
                      "${picked.hour}:${picked.minute.toString().padLeft(2, '0')}";
                }
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                try {
                    // Validasi tanggal & jam tidak kosong
                    if (_tanggalController.text.isEmpty || _jamController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Tanggal & jam harus diisi")),
                      );
                      return;
                    }

                    DateTime date = DateTime.parse(_tanggalController.text);
                    final timeParts = _jamController.text.split(":");
                    int hour = int.parse(timeParts[0]);
                    int minute = int.parse(timeParts[1]);
                    DateTime parsedDate = DateTime(
                      date.year, date.month, date.day, hour, minute,
                    );

                    // Panggil API dan dapatkan schedule yang baru (sudah ada id)
                    final newSchedule = await ApiSchedule.AddSchedule(
                      _judulController.text,
                      _deskripsiController.text,
                      parsedDate,
                    );
                    int notificationId = newSchedule.id.hashCode;

                    // 🔔 Jadwalkan notifikasi alarm menggunakan id dari server
                    await NotificationService.scheduleNotification(
                      id: notificationId,
                      title: newSchedule.title,
                      body: newSchedule.description,
                      scheduledTime: parsedDate,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Schedule berhasil ditambahkan & alarm dijadwalkan")),
                    );
                    Navigator.pop(context, true);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: $e")),
                    );
                  }

              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
