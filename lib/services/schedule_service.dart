import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyek/models/schedule_model.dart';

class ApiSchedule {
  final List schedule = [];
  static const baseUrl =
      "https://backendtimeque-production-fdcf.up.railway.app/schedule";

  static Future<Scheduleuser> AddSchedule(
    String title,
    String description,
    DateTime date,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.post(
      Uri.parse("$baseUrl/AddSchedule"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({
        "title": title,
        "description": description,
        "date": date.toIso8601String(),
      }),
    );
    if (res.statusCode != 201) {
      throw Exception("Failed to add schedule");
    }
    final data = jsonDecode(res.body);
    // Asumsikan API mengembalikan object Scheduleuser dengan id
    return Scheduleuser.fromJson(data);
  }

  static Future<List<Scheduleuser>> getSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.get(
      Uri.parse("$baseUrl/GetSchedule"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode == 200) {
      List data = json.decode(res.body);

      return data.map((e) => Scheduleuser.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load schedule");
    }
  }

  static Future<void> deleteSchedule(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final res = await http.delete(
      Uri.parse("$baseUrl/Delete/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (res.statusCode != 200) {
      throw Exception("Failed to delete schedule");
    }
  }
}
