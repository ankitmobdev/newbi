class CategoryModel {
  final String categoryName;
  final String comission;
  final String categoryImage;
  final String itemCount;
  final String? subCategory;
  final String? ingredientsName;
  final String? ingredientsImage;

  CategoryModel({
    required this.categoryName,
    required this.comission,
    required this.categoryImage,
    required this.itemCount,
    this.subCategory,
    this.ingredientsName,
    this.ingredientsImage,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryName: json['category_name'] ?? '',
      comission: json['comission'] ?? '',
      categoryImage: json['category_image'] ?? '',
      itemCount: json['item_count'] ?? '',
      subCategory: json['subcategory'], // optional
      ingredientsName: json['ingredients_name'], // optional
      ingredientsImage: json['ingredients_image'], // optional
    );
  }

}