class DeliverydetailModel {
  String? result;
  String? message;
  Deliverydata? deliverydata;

  DeliverydetailModel({this.result, this.message, this.deliverydata});

  DeliverydetailModel.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    message = json['message'];
    deliverydata = json['deliverydata'] != null
        ? new Deliverydata.fromJson(json['deliverydata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['message'] = this.message;
    if (this.deliverydata != null) {
      data['deliverydata'] = this.deliverydata!.toJson();
    }
    return data;
  }
}

class Deliverydata {
  String? orderId;
  String? numberOfStairs2;
  String? vehicleType;
  String? driverId;
  String? userId;
  String? bookingType;
  String? deliveryCost;
  String? orderImage1;
  String? orderImage2;
  String? orderImage3;
  String? adminCost;
  String? driverCost;
  String? driverPlusAideCost;
  String? fromTime;
  String? toTime;
  String? pickupaddress;
  String? dropoffaddress;
  String? createdAt;
  String? storeName;
  String? itemPurchaseBy;
  String? purchaserName;
  String? purchaserNumber;
  String? unitOrApartment;
  String? staircase;
  String? numberOfStairs;
  String? elevators;
  String? aideAndDriver;
  String? itemQuantity;
  String? sellerName;
  String? sellerNumber;
  String? unitOrApartment2;
  String? staircase2;
  String? elevator2;
  String? date;
  String? pickupLat;
  String? pickupLong;
  String? dropoffLat;
  String? dropoffLong;
  String? deliveryStatus;
  String? driverPhone;
  String? driverName;
  String? driverImage;
  String? userPhone;
  String? userName;
  String? userImage;
  List<Package>? package;

  Deliverydata(
      {this.orderId,
        this.numberOfStairs2,
        this.vehicleType,
        this.driverId,
        this.userId,
        this.bookingType,
        this.deliveryCost,
        this.orderImage1,
        this.orderImage2,
        this.orderImage3,
        this.adminCost,
        this.driverCost,
        this.driverPlusAideCost,
        this.fromTime,
        this.toTime,
        this.pickupaddress,
        this.dropoffaddress,
        this.createdAt,
        this.storeName,
        this.itemPurchaseBy,
        this.purchaserName,
        this.purchaserNumber,
        this.unitOrApartment,
        this.staircase,
        this.numberOfStairs,
        this.elevators,
        this.aideAndDriver,
        this.itemQuantity,
        this.sellerName,
        this.sellerNumber,
        this.unitOrApartment2,
        this.staircase2,
        this.elevator2,
        this.date,
        this.pickupLat,
        this.pickupLong,
        this.dropoffLat,
        this.dropoffLong,
        this.deliveryStatus,
        this.driverPhone,
        this.driverName,
        this.driverImage,
        this.userPhone,
        this.userName,
        this.userImage,
        this.package});

  Deliverydata.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    numberOfStairs2 = json['number_of_stairs2'];
    vehicleType = json['vehicle_type'];
    driverId = json['driver_id'];
    userId = json['user_id'];
    bookingType = json['booking_type'];
    deliveryCost = json['delivery_cost'];
    orderImage1 = json['order_image1'];
    orderImage2 = json['order_image2'];
    orderImage3 = json['order_image3'];
    adminCost = json['admin_cost'];
    driverCost = json['driver_cost'];
    driverPlusAideCost = json['driver_plus_aide_cost'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
    pickupaddress = json['pickupaddress'];
    dropoffaddress = json['dropoffaddress'];
    createdAt = json['created_at'];
    storeName = json['store_name'];
    itemPurchaseBy = json['item_purchase_by'];
    purchaserName = json['purchaser_name'];
    purchaserNumber = json['purchaser_number'];
    unitOrApartment = json['unit_or_apartment'];
    staircase = json['staircase'];
    numberOfStairs = json['number_of_stairs'];
    elevators = json['elevators'];
    aideAndDriver = json['aide_and_driver'];
    itemQuantity = json['item_quantity'];
    sellerName = json['seller_name'];
    sellerNumber = json['seller_number'];
    unitOrApartment2 = json['unit_or_apartment2'];
    staircase2 = json['staircase2'];
    elevator2 = json['elevator2'];
    date = json['date'];
    pickupLat = json['pickup_lat'];
    pickupLong = json['pickup_long'];
    dropoffLat = json['dropoff_lat'];
    dropoffLong = json['dropoff_long'];
    deliveryStatus = json['delivery_status'];
    driverPhone = json['driver_phone'];
    driverName = json['driver_name'];
    driverImage = json['driver_image'];
    userPhone = json['user_phone'];
    userName = json['user_name'];
    userImage = json['user_image'];
    if (json['package'] != null) {
      package = <Package>[];
      json['package'].forEach((v) {
        package!.add(new Package.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['number_of_stairs2'] = this.numberOfStairs2;
    data['vehicle_type'] = this.vehicleType;
    data['driver_id'] = this.driverId;
    data['user_id'] = this.userId;
    data['booking_type'] = this.bookingType;
    data['delivery_cost'] = this.deliveryCost;
    data['order_image1'] = this.orderImage1;
    data['order_image2'] = this.orderImage2;
    data['order_image3'] = this.orderImage3;
    data['admin_cost'] = this.adminCost;
    data['driver_cost'] = this.driverCost;
    data['driver_plus_aide_cost'] = this.driverPlusAideCost;
    data['from_time'] = this.fromTime;
    data['to_time'] = this.toTime;
    data['pickupaddress'] = this.pickupaddress;
    data['dropoffaddress'] = this.dropoffaddress;
    data['created_at'] = this.createdAt;
    data['store_name'] = this.storeName;
    data['item_purchase_by'] = this.itemPurchaseBy;
    data['purchaser_name'] = this.purchaserName;
    data['purchaser_number'] = this.purchaserNumber;
    data['unit_or_apartment'] = this.unitOrApartment;
    data['staircase'] = this.staircase;
    data['number_of_stairs'] = this.numberOfStairs;
    data['elevators'] = this.elevators;
    data['aide_and_driver'] = this.aideAndDriver;
    data['item_quantity'] = this.itemQuantity;
    data['seller_name'] = this.sellerName;
    data['seller_number'] = this.sellerNumber;
    data['unit_or_apartment2'] = this.unitOrApartment2;
    data['staircase2'] = this.staircase2;
    data['elevator2'] = this.elevator2;
    data['date'] = this.date;
    data['pickup_lat'] = this.pickupLat;
    data['pickup_long'] = this.pickupLong;
    data['dropoff_lat'] = this.dropoffLat;
    data['dropoff_long'] = this.dropoffLong;
    data['delivery_status'] = this.deliveryStatus;
    data['driver_phone'] = this.driverPhone;
    data['driver_name'] = this.driverName;
    data['driver_image'] = this.driverImage;
    data['user_phone'] = this.userPhone;
    data['user_name'] = this.userName;
    data['user_image'] = this.userImage;
    if (this.package != null) {
      data['package'] = this.package!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Package {
  String? id;
  String? orderId;
  String? userId;
  String? categoryName;
  String? subcategory;
  String? quantity;
  String? instruction;
  String? extraSubcategory;
  String? createdAt;
  bool? packageImage;

  Package(
      {this.id,
        this.orderId,
        this.userId,
        this.categoryName,
        this.subcategory,
        this.quantity,
        this.instruction,
        this.extraSubcategory,
        this.createdAt,
        this.packageImage});

  Package.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    userId = json['user_id'];
    categoryName = json['category_name'];
    subcategory = json['subcategory'];
    quantity = json['quantity'];
    instruction = json['instruction'];
    extraSubcategory = json['extra_subcategory'];
    createdAt = json['created_at'];
    packageImage = json['package_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['category_name'] = this.categoryName;
    data['subcategory'] = this.subcategory;
    data['quantity'] = this.quantity;
    data['instruction'] = this.instruction;
    data['extra_subcategory'] = this.extraSubcategory;
    data['created_at'] = this.createdAt;
    data['package_image'] = this.packageImage;
    return data;
  }
}
