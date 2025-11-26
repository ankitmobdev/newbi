class OrdersModel {
  String? result;
  String? message;
  List<Data>? data;

  OrdersModel({this.result, this.message, this.data});

  OrdersModel.fromJson(Map<String, dynamic> json) {
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
  String? orderId;
  String? username;
  String? userphone;
  String? drivername;
  String? driverphone;
  String? orderDate;
  String? totalQty;
  String? totalAmount;
  String? shippingAmount;
  String? shippingPhone;
  String? shippingAddress;
  String? paymentType;
  String? couponCode;
  String? restaurantId;
  List<Products>? products;

  Data(
      {this.orderId,
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
        this.products});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    username = json['username'];
    userphone = json['userphone'];
    drivername = json['drivername'];
    driverphone = json['driverphone'];
    orderDate = json['order_date'];
    totalQty = json['total_qty'];
    totalAmount = json['total_amount'];
    shippingAmount = json['shipping_amount'];
    shippingPhone = json['shipping_phone'];
    shippingAddress = json['shipping_address'];
    paymentType = json['payment_type'];
    couponCode = json['coupon_code'];
    restaurantId = json['restaurant_id'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['username'] = this.username;
    data['userphone'] = this.userphone;
    data['drivername'] = this.drivername;
    data['driverphone'] = this.driverphone;
    data['order_date'] = this.orderDate;
    data['total_qty'] = this.totalQty;
    data['total_amount'] = this.totalAmount;
    data['shipping_amount'] = this.shippingAmount;
    data['shipping_phone'] = this.shippingPhone;
    data['shipping_address'] = this.shippingAddress;
    data['payment_type'] = this.paymentType;
    data['coupon_code'] = this.couponCode;
    data['restaurant_id'] = this.restaurantId;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String? id;
  String? orderId;
  String? productId;
  String? productName;
  String? price;
  String? qty;
  String? subtotal;
  String? category;
  String? status;
  String? restaurantId;
  List<Item>? item;

  Products(
      {this.id,
        this.orderId,
        this.productId,
        this.productName,
        this.price,
        this.qty,
        this.subtotal,
        this.category,
        this.status,
        this.restaurantId,
        this.item});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    price = json['price'];
    qty = json['qty'];
    subtotal = json['subtotal'];
    category = json['category'];
    status = json['status'];
    restaurantId = json['restaurant_id'];
    if (json['item'] != null) {
      item = <Item>[];
      json['item'].forEach((v) {
        item!.add(new Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['subtotal'] = this.subtotal;
    data['category'] = this.category;
    data['status'] = this.status;
    data['restaurant_id'] = this.restaurantId;
    if (this.item != null) {
      data['item'] = this.item!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Item {
  String? id;
  String? productOrderId;
  String? orderId;
  String? userId;
  String? productId;
  String? productName;
  String? price;
  String? createdAt;

  Item(
      {this.id,
        this.productOrderId,
        this.orderId,
        this.userId,
        this.productId,
        this.productName,
        this.price,
        this.createdAt});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productOrderId = json['product_order_id'];
    orderId = json['order_id'];
    userId = json['user_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    price = json['price'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_order_id'] = this.productOrderId;
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    return data;
  }
}