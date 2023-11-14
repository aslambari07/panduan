class Category {
  final String id;
  final String categoryName;
  final String icon;
  final String image;

  Category(
      {required this.id,
      required this.categoryName,
      required this.icon,
      required this.image});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['id'],
        categoryName: json['category_name'],
        icon: json['icon'],
        image: json['image']);
  }
}
