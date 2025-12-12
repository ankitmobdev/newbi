// class ItemDTO {
//   String? categoryName;
//   String? subcategory;
//   String? quantity;
//   String? instruction;
//   String? extraSubcategory;
//   String? price;
//
//   ItemDTO({
//     this.categoryName,
//     this.subcategory,
//     this.quantity,
//     this.instruction,
//     this.extraSubcategory,
//     this.price,
//   });
// }

class ItemDTO {
  String? categoryName;
  String? subcategory;
  String? quantity;
  String? instruction;
  String? extraSubcategory;
  String? price;

  ItemDTO({
    this.categoryName,
    this.subcategory,
    this.quantity,
    this.instruction,
    this.extraSubcategory,
    this.price,
  });

  // Add this method
  Map<String, dynamic> toJson() {
    return {
      'category_name': categoryName,
      'subcategory': subcategory,
      'quantity': quantity,
      'instruction': instruction,
      'extra_subcategory': extraSubcategory,
      'price': price,
    };
  }
}