class Scheduleuser {
  final String id;
  final String title;
  final String description;
  final DateTime date;

  Scheduleuser({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  factory Scheduleuser.fromjson(Map<String, dynamic> json) {
    return Scheduleuser(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
    );
  }
}