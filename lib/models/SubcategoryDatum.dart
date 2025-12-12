class SubcategoryDatum {
  final String subId;
  final String categoryName;
  final String subcategory;
  final String price;
  final String created;

  SubcategoryDatum({
    required this.subId,
    required this.categoryName,
    required this.subcategory,
    required this.price,
    required this.created,
  });

  factory SubcategoryDatum.fromJson(Map<String, dynamic> json) {
    return SubcategoryDatum(
      subId: json['sub_id']?.toString() ?? '',
      categoryName: json['category_name'] ?? '',
      subcategory: json['subcategory'] ?? '',
      price: json['price']?.toString() ?? '',
      created: json['created'] ?? '',
    );
  }
}