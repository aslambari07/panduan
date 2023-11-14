class VideoArticle {
  final String id;
  final String categoryId;
  final String categoryName;
  final String title;
  final String description;
  final String thumbnail;
  final String video;
  final String views;
  final String likes;
  final String saves;
  final String language;
  final String reports;
  final String dateCreated;

  VideoArticle(
      {required this.id,
      required this.categoryId,
      required this.categoryName,
      required this.title,
      required this.description,
      required this.thumbnail,
      required this.video,
      required this.views,
      required this.likes,
      required this.saves,
      required this.language,
      required this.reports,
      required this.dateCreated});

  // factory VideoArticle.fromJson(Map<String, dynamic> json) {
  //   return VideoArticle(
  //       id: json['id'],
  //       categoryId: json['category_id'],
  //       categoryName: json['category_name'],
  //       title: json['title'],
  //       description: json['description'],
  //       thumbnail: json['thumbnail'],
  //       video: json['video'],
  //       views: json['views'],
  //       likes: json['likes'],
  //       saves: json['saves'],
  //       language: json['language'],
  //       reports: json['reports'],
  //       dateCreated: json['date_created']);
  // }
  factory VideoArticle.fromJson(Map<String, dynamic> json) {
    return VideoArticle(
      id: json['id'] ?? '',
      categoryId: json['category_id'] ?? '',
      categoryName: json['category_name'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
      video: json['video'] ?? '',
      views: json['views'] ?? '',
      likes: json['likes'] ?? '',
      saves: json['saves'] ?? '',
      language: json['language'] ?? '',
      reports: json['reports'] ?? '',
      dateCreated: json['date_created'] ?? '',
    );
  }
}
