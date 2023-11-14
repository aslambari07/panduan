class AppNotifications {
  final String id;
  final String title;
  final String description;
  final String image;
  final String type;
  final String data;
  final String date;

  AppNotifications(
      {required this.id,
      required this.title,
      required this.description,
      required this.image,
      required this.type,
      required this.data,
      required this.date});

  factory AppNotifications.fromJson(Map<String, dynamic> json) {
    return AppNotifications(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        image: json['image'],
        type: json['type'],
        data: json['data'],
        date: json['date']);
  }
}
