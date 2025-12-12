class GetDriverDeliveryModel {
  String? result;
  String? message;
  List<Data>? data;

  GetDriverDeliveryModel({this.result, this.message, this.data});

  GetDriverDeliveryModel.fromJson(Map<String, dynamic> json) {
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
  String? vehicleType;
  String? driverId;
  String? bookingType;
  String? deliveryCost;
  String? userId;
  String? orderImage1;
  String? orderImage2;
  String? orderImage3;
  String? adminCost;
  String? driverCost;
  String? driverPlusAideCost;
  String? fromTime;
  String? toTime;
  String? date;
  String? pickupaddress;
  String? dropoffaddress;
  String? createdAt;
  String? driverPhone;
  String? userPhone;
  String? userName;
  String? userImage;
  String? deliveryStatus;
  String? phone_code;

  Data(
      {this.orderId,
        this.vehicleType,
        this.driverId,
        this.bookingType,
        this.deliveryCost,
        this.userId,
        this.orderImage1,
        this.orderImage2,
        this.orderImage3,
        this.adminCost,
        this.driverCost,
        this.driverPlusAideCost,
        this.phone_code,
        this.fromTime,
        this.toTime,
        this.date,
        this.pickupaddress,
        this.dropoffaddress,
        this.createdAt,
        this.driverPhone,
        this.userPhone,
        this.userName,
        this.userImage,
        this.deliveryStatus});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    vehicleType = json['vehicle_type'];
    driverId = json['driver_id'];
    bookingType = json['booking_type'];
    phone_code = json['phone_code'];
    deliveryCost = json['delivery_cost'];
    userId = json['user_id'];
    orderImage1 = json['order_image1'];
    orderImage2 = json['order_image2'];
    orderImage3 = json['order_image3'];
    adminCost = json['admin_cost'];
    driverCost = json['driver_cost'];
    driverPlusAideCost = json['driver_plus_aide_cost'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
    date = json['date'];
    pickupaddress = json['pickupaddress'];
    dropoffaddress = json['dropoffaddress'];
    createdAt = json['created_at'];
    driverPhone = json['driver_phone'];
    userPhone = json['user_phone'];
    userName = json['user_name'];
    userImage = json['user_image'];
    deliveryStatus = json['delivery_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['vehicle_type'] = this.vehicleType;
    data['driver_id'] = this.driverId;
    data['booking_type'] = this.bookingType;
    data['phone_code'] = this.phone_code;
    data['delivery_cost'] = this.deliveryCost;
    data['user_id'] = this.userId;
    data['order_image1'] = this.orderImage1;
    data['order_image2'] = this.orderImage2;
    data['order_image3'] = this.orderImage3;
    data['admin_cost'] = this.adminCost;
    data['driver_cost'] = this.driverCost;
    data['driver_plus_aide_cost'] = this.driverPlusAideCost;
    data['from_time'] = this.fromTime;
    data['to_time'] = this.toTime;
    data['date'] = this.date;
    data['pickupaddress'] = this.pickupaddress;
    data['dropoffaddress'] = this.dropoffaddress;
    data['created_at'] = this.createdAt;
    data['driver_phone'] = this.driverPhone;
    data['user_phone'] = this.userPhone;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    data['delivery_status'] = this.deliveryStatus;
    return data;
  }
}
