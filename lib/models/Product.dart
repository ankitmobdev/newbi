class Product {
  String? result;
  String? message;
  List<Data>? data;
  Product({this.result, this.message, this.data});
  Product.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? productId;
  String? productName;
  String? productImage;
  String? productPrice;
  String? discountPrice;
  String? createdAt;
  String? category;
  String? subcategory;
  String? productDescription;
  String? variants;
  String? recommended;
  String? website;
  Data(
      {this.productId,
        this.productName,
        this.productImage,
        this.productPrice,
        this.discountPrice,
        this.createdAt,
        this.category,
        this.subcategory,
        this.productDescription,
        this.variants,
        this.recommended,
        this.website});
  Data.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productImage = json['product_image'];
    productPrice = json['product_price'];
    discountPrice = json['discount_price'];
    createdAt = json['created_at'];
    category = json['category'];
    subcategory = json['subcategory'];
    productDescription = json['product_description'];
    variants = json['variants'];
    recommended = json['recommended'];
    website = json['website'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['product_price'] = this.productPrice;
    data['discount_price'] = this.discountPrice;
    data['created_at'] = this.createdAt;
    data['category'] = this.category;
    data['subcategory'] = this.subcategory;
    data['product_description'] = this.productDescription;
    data['variants'] = this.variants;
    data['recommended'] = this.recommended;
    data['website'] = this.website;
    return data;
  }
}