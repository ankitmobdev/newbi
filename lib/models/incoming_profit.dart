class IncomingProfitModel {
  final String? result;
  final String? message;
  final String? driverProfit;
  final List<DataIncomingProfit> data;
  final int? orderCount;

  IncomingProfitModel({
    this.result,
    this.message,
    this.driverProfit,
    required this.data,
    this.orderCount,
  });

  factory IncomingProfitModel.fromJson(Map<String, dynamic> json) {
    return IncomingProfitModel(
      result: json['result'],
      message: json['message'],
      driverProfit: json['driver_profit'],
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => DataIncomingProfit.fromJson(e))
          .toList() ??
          [],
      orderCount: json['order_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'driver_profit': driverProfit,
      'data': data.map((e) => e.toJson()).toList(),
      'order_count': orderCount,
    };
  }
}

class DataIncomingProfit {
  final String? username;
  final String? profileImage;
  final String? phone;
  final String? orderId;
  final String? driverId;
  final String? orderDate;
  final String? status;
  final String? shippingAmount;
  final String? shippingAddress;
  final String? orderConfirm;

  DataIncomingProfit({
    this.username,
    this.profileImage,
    this.phone,
    this.orderId,
    this.driverId,
    this.orderDate,
    this.status,
    this.shippingAmount,
    this.shippingAddress,
    this.orderConfirm,
  });

  factory DataIncomingProfit.fromJson(Map<String, dynamic> json) {
    return DataIncomingProfit(
      username: json['username'],
      profileImage: json['profile_image'],
      phone: json['phone'],
      orderId: json['order_id'],
      driverId: json['driver_id'],
      orderDate: json['order_date'],
      status: json['status'],
      shippingAmount: json['shipping_amount'],
      shippingAddress: json['shipping_address'],
      orderConfirm: json['order_confirm'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'profile_image': profileImage,
      'phone': phone,
      'order_id': orderId,
      'driver_id': driverId,
      'order_date': orderDate,
      'status': status,
      'shipping_amount': shippingAmount,
      'shipping_address': shippingAddress,
      'order_confirm': orderConfirm,
    };
  }
}
