class MenuItem {
  String? result;
  String? message;
  List<Data>? data;

  MenuItem({this.result, this.message, this.data});

  MenuItem.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? vegType;
  String? categoryName;
  String? itemName;
  String? itemDescription;
  String? normalPrice;
  String? offerPrice;
  String? gstCharge;
  String? prepartionTime;
  String? itemImage;
  String? id;
  List<ItemIngredients>? itemIngredients;

  Data({
    this.vegType,
    this.categoryName,
    this.itemName,
    this.itemDescription,
    this.normalPrice,
    this.offerPrice,
    this.gstCharge,
    this.prepartionTime,
    this.itemImage,
    this.id,
    this.itemIngredients,
  });

  Data.fromJson(Map<String, dynamic> json) {
    vegType = json['veg_type'];
    categoryName = json['category_name'];
    itemName = json['item_name'];
    itemDescription = json['item_description'];
    normalPrice = json['normal_price'];
    offerPrice = json['offer_price'];
    gstCharge = json['gst_charge'];
    prepartionTime = json['prepartion_time'];
    itemImage = json['item_image'];
    id = json['id'];

    // 🔐 Safely parse item_ingredients if it's a List
    if (json['item_ingredients'] is List) {
      itemIngredients = <ItemIngredients>[];
      json['item_ingredients'].forEach((v) {
        itemIngredients!.add(ItemIngredients.fromJson(v));
      });
    } else {
      itemIngredients = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['veg_type'] = vegType;
    data['category_name'] = categoryName;
    data['item_name'] = itemName;
    data['item_description'] = itemDescription;
    data['normal_price'] = normalPrice;
    data['offer_price'] = offerPrice;
    data['gst_charge'] = gstCharge;
    data['prepartion_time'] = prepartionTime;
    data['item_image'] = itemImage;
    data['id'] = id;
    if (itemIngredients != null) {
      data['item_ingredients'] = itemIngredients!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemIngredients {
  String? id;
  String? itemId;
  String? ingredientsName;
  String? createdAt;

  ItemIngredients({
    this.id,
    this.itemId,
    this.ingredientsName,
    this.createdAt,
  });

  ItemIngredients.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemId = json['item_id'];
    ingredientsName = json['ingredients_name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['item_id'] = itemId;
    data['ingredients_name'] = ingredientsName;
    data['created_at'] = createdAt;
    return data;
  }
}
