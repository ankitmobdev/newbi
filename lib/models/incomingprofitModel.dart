class IncomingProfitModel {
  String? result;
  String? message;
  String? driverProfit;
  List<IncomingProfitData>? data;

  IncomingProfitModel({
    this.result,
    this.message,
    this.driverProfit,
    this.data,
  });

  IncomingProfitModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    driverProfit = json['driver_profit'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(IncomingProfitData.fromJson(v));
      });
    }
  }
}

class IncomingProfitData {
  String? firstname;
  String? lastname;
  String? profileImage;
  String? phone;
  String? orderId;
  String? bookingType;
  String? vehicleType;
  String? driverCost;
  String? driverId;
  String? toTime;
  String? storeName;
  String? date;
  String? fromTime;
  String? purchaserName;
  String? deliveryStatus;
  String? driverDeliveryCost;
  String? pickupaddress;
  String? dropoffaddress;
  String? createdAt;

  IncomingProfitData.fromJson(Map<String, dynamic> json) {
    firstname = json['firstname'];
    lastname = json['lastname'];
    profileImage = json['profile_image'];
    phone = json['phone'];
    orderId = json['order_id'];
    bookingType = json['booking_type'];
    vehicleType = json['vehicle_type'];
    driverCost = json['driver_cost'];
    driverId = json['driver_id'];
    toTime = json['to_time'];
    storeName = json['store_name'];
    date = json['date'];
    fromTime = json['from_time'];
    purchaserName = json['purchaser_name'];
    deliveryStatus = json['delivery_status'];
    driverDeliveryCost = json['driver_delivery_cost'];
    pickupaddress = json['pickupaddress'];
    dropoffaddress = json['dropoffaddress'];
    createdAt = json['created_at'];
  }
}
