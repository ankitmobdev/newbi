class BookDTO {
  final String result;
  final String message;
  final List<Datum> data;

  BookDTO({
    required this.result,
    required this.message,
    required this.data,
  });

  factory BookDTO.fromJson(Map<String, dynamic> json) {
    return BookDTO(
      result: json['result'] ?? "",
      message: json['message'] ?? "",
      data: (json['data'] as List)
          .map((e) => Datum.fromJson(e))
          .toList(),
    );
  }
}

class Datum {
  final String categoryName;
  final List<Subcategory> subCategoryData;

  Datum({
    required this.categoryName,
    required this.subCategoryData,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      categoryName: json['category_name'] ?? "",
      subCategoryData: (json['subcategory'] as List)
          .map((e) => Subcategory.fromJson(e))
          .toList(),
    );
  }
}

class Subcategory {
  final String name;

  Subcategory({required this.name});

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      name: json['subcategory_name'] ?? "",
    );
  }
}