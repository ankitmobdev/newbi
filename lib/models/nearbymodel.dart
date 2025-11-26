class NearbyDeliveriesModel {
  final String? result;
  final String? message;
  final List<Data>? data;

  NearbyDeliveriesModel({this.result, this.message, this.data});

  factory NearbyDeliveriesModel.fromJson(Map<String, dynamic> json) {
    return NearbyDeliveriesModel(
      result: json['result'],
      message: json['message'],
      data: json['data'] != null
          ? List<Data>.from(json['data'].map((v) => Data.fromJson(v)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': data?.map((v) => v.toJson()).toList(),
    };
  }
}

class Data {
  final String? orderId;
  final String? source;
  final String? status;
  final String? username;
  final String? userphone;
  final String? drivername;
  final String? driverphone;
  final String? orderDate;
  final String? totalQty;
  final String? totalAmount;
  final String? shippingAmount;
  final String? shippingPhone;
  final String? shippingAddress;
  final String? paymentType;
  final String? couponCode;
  final String? restaurantId;
  final String? restaurant_name;
  final String? restaurant_latitude;
  final String? restaurant_longitude;
  final String? restaurant_address;
  final String? restaurant_phone;
  final String? user_profile_image;
  final String? restro_profile_image;
  final String? orderTime;
  final String? distance;
  final List<Products>? products;

  Data({
    this.orderId,
    this.source,
    this.status,
    this.username,
    this.userphone,
    this.drivername,
    this.driverphone,
    this.orderDate,
    this.totalQty,
    this.totalAmount,
    this.shippingAmount,
    this.shippingPhone,
    this.shippingAddress,
    this.paymentType,
    this.couponCode,
    this.restaurantId,
    this.restaurant_name,
    this.restaurant_phone,
    this.restaurant_address,
    this.restaurant_latitude,
    this.restaurant_longitude,
    this.restro_profile_image,
    this.user_profile_image,
    this.orderTime,
    this.products,
    this.distance,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      orderId: json['order_id'],
      status: json['status'],
      username: json['username'],
      userphone: json['userphone'],
      restaurant_name: json['restaurant_name'],
      source: json['source'],
      restaurant_phone: json['restaurant_phone'],
      restaurant_address: json['restaurant_address'],
      restaurant_latitude: json['restaurant_latitude'],
      restaurant_longitude: json['restaurant_longitude'],
      orderTime: json['orderTime'],
      user_profile_image: json['user_profile_image'],
      restro_profile_image: json['restro_profile_image'],
      drivername: json['drivername'],
      driverphone: json['driverphone'],
      orderDate: json['order_date'],
      totalQty: json['total_qty'],
      totalAmount: json['total_amount'],
      shippingAmount: json['shipping_amount'],
      shippingPhone: json['shipping_phone'],
      shippingAddress: json['shipping_address'],
      paymentType: json['payment_type'],
      couponCode: json['coupon_code'],
      restaurantId: json['restaurant_id'],
      distance: json['distance'],
      products: json['products'] != null
          ? List<Products>.from(json['products'].map((v) => Products.fromJson(v)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'status': status,
      'username': username,
      'userphone': userphone,
      'source': source,
      'drivername': drivername,
      'driverphone': driverphone,
      'restro_profile_image': restro_profile_image,
      'user_profile_image': user_profile_image,
      'orderTime': orderTime,
      'restaurant_name': restaurant_name,
      'restaurant_phone': restaurant_phone,
      'restaurant_latitude': restaurant_latitude,
      'restaurant_longitude': restaurant_longitude,
      'restaurant_address': restaurant_address,
      'order_date': orderDate,
      'distance': distance,
      'total_qty': totalQty,
      'total_amount': totalAmount,
      'shipping_amount': shippingAmount,
      'shipping_phone': shippingPhone,
      'shipping_address': shippingAddress,
      'payment_type': paymentType,
      'coupon_code': couponCode,
      'restaurant_id': restaurantId,
      'products': products?.map((v) => v.toJson()).toList(),
    };
  }
}

class Products {
  final String? id;
  final String? orderId;
  final String? productId;
  final String? productName;
  final String? price;
  final String? qty;
  final String? subtotal;
  final String? category;
  final String? status;
  final String? restaurantId;
  final List<Item>? item;

  Products({
    this.id,
    this.orderId,
    this.productId,
    this.productName,
    this.price,
    this.qty,
    this.subtotal,
    this.category,
    this.status,
    this.restaurantId,
    this.item,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      productName: json['product_name'],
      price: json['price'],
      qty: json['qty'],
      subtotal: json['subtotal'],
      category: json['category'],
      status: json['status'],
      restaurantId: json['restaurant_id'],
      item: json['item'] != null
          ? List<Item>.from(json['item'].map((v) => Item.fromJson(v)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'qty': qty,
      'subtotal': subtotal,
      'category': category,
      'status': status,
      'restaurant_id': restaurantId,
      'item': item?.map((v) => v.toJson()).toList(),
    };
  }
}

class Item {
  final String? id;
  final String? productOrderId;
  final String? orderId;
  final String? userId;
  final String? productId;
  final String? productName;
  final String? price;
  final String? type;
  final String? createdAt;

  Item({
    this.id,
    this.productOrderId,
    this.orderId,
    this.userId,
    this.productId,
    this.productName,
    this.price,
    this.type,
    this.createdAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      productOrderId: json['product_order_id'],
      orderId: json['order_id'],
      userId: json['user_id'],
      productId: json['product_id'],
      productName: json['product_name'],
      price: json['price'],
      type: json['type'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_order_id': productOrderId,
      'order_id': orderId,
      'user_id': userId,
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'type': type,
      'created_at': createdAt,
    };
  }
}
