import 'package:flutter/material.dart';
import 'package:proyek/models/schedule_model.dart';
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
  Future<List<Scheduleuser>>? schedules;

  @override
  void initState() {
    super.initState();
    schedules = ApiSchedule.getSchedule();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Schedule")),
      body: Column(
        children: [
          TextField(
            controller: _judulController,
            decoration: InputDecoration(hintText: "Judul")),
          TextField(
            controller: _deskripsiController,
            decoration: InputDecoration(hintText: "Deskripsi")),
          TextField(
            controller: _tanggalController,
            decoration: InputDecoration(hintText: "Tanggal"),
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
          ElevatedButton(
            onPressed: () async {
              try {
                DateTime parsedDate = DateTime.parse(_tanggalController.text);
                await ApiSchedule.AddSchedule(
                  _judulController.text,
                  _deskripsiController.text,
                  parsedDate,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Schedule berhasil ditambahkan")),
                );
                Navigator.pop(context, true);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error: $e")),
                );
              }
            },
            child: Text("Simpan"),
          ),
        ],
      ),
    );
  }
}
