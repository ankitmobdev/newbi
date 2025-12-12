class NearByDeliveryModel {
  String? result;
  String? message;
  List<NearByData>? data;

  NearByDeliveryModel({this.result, this.message, this.data});

  NearByDeliveryModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NearByData>[];
      json['data'].forEach((v) {
        data!.add(new NearByData.fromJson(v));
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

class NearByData {
  String? userId;
  String? firstname;
  String? lastname;
  String? phone;
  String? profileImage;
  String? orderId;
  String? vehicleType;
  String? driverId;
  String? bookingType;
  String? deliveryCost;
  String? adminCost;
  String? driverCost;
  String? driverPlusAideCost;
  String? fromTime;
  String? toTime;
  String? date;
  String? pickupaddress;
  String? dropoffaddress;
  String? createdAt;
  String? deliveryStatus;

  NearByData(
      {this.userId,
        this.firstname,
        this.lastname,
        this.phone,
        this.profileImage,
        this.orderId,
        this.vehicleType,
        this.driverId,
        this.bookingType,
        this.deliveryCost,
        this.adminCost,
        this.driverCost,
        this.driverPlusAideCost,
        this.fromTime,
        this.toTime,
        this.date,
        this.pickupaddress,
        this.dropoffaddress,
        this.createdAt,
        this.deliveryStatus});

  NearByData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phone = json['phone'];
    profileImage = json['profile_image'];
    orderId = json['order_id'];
    vehicleType = json['vehicle_type'];
    driverId = json['driver_id'];
    bookingType = json['booking_type'];
    deliveryCost = json['delivery_cost'];
    adminCost = json['admin_cost'];
    driverCost = json['driver_cost'];
    driverPlusAideCost = json['driver_plus_aide_cost'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
    date = json['date'];
    pickupaddress = json['pickupaddress'];
    dropoffaddress = json['dropoffaddress'];
    createdAt = json['created_at'];
    deliveryStatus = json['delivery_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['phone'] = this.phone;
    data['profile_image'] = this.profileImage;
    data['order_id'] = this.orderId;
    data['vehicle_type'] = this.vehicleType;
    data['driver_id'] = this.driverId;
    data['booking_type'] = this.bookingType;
    data['delivery_cost'] = this.deliveryCost;
    data['admin_cost'] = this.adminCost;
    data['driver_cost'] = this.driverCost;
    data['driver_plus_aide_cost'] = this.driverPlusAideCost;
    data['from_time'] = this.fromTime;
    data['to_time'] = this.toTime;
    data['date'] = this.date;
    data['pickupaddress'] = this.pickupaddress;
    data['dropoffaddress'] = this.dropoffaddress;
    data['created_at'] = this.createdAt;
    data['delivery_status'] = this.deliveryStatus;
    return data;
  }
}
