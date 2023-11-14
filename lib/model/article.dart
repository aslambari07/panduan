class Article {
  final String id;
  final String categoryId;
  final String title;
  final String coverImage;
  final String description;
  final String views;
  final String likes;
  final String saves;
  final String isTrending;
  final String isBreaking;
  final String language;
  final String reports;
  final String dateCreated;

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        id: json['id'],
        categoryId: json['category_id'],
        title: json['title'],
        coverImage: json['cover_image'],
        description: json['description'],
        views: json['views'],
        likes: json['likes'],
        saves: json['saves'],
        isTrending: json['is_trending'],
        isBreaking: json['is_breaking'],
        language: json['language'],
        reports: json['reports'],
        dateCreated: json['date_created']);
  }

  Article(
      {required this.id,
      required this.categoryId,
      required this.title,
      required this.coverImage,
      required this.description,
      required this.views,
      required this.likes,
      required this.saves,
      required this.isTrending,
      required this.isBreaking,
      required this.language,
      required this.reports,
      required this.dateCreated});
}
