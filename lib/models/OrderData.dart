class OrderData {
  final String bookingType;
  final String pickupLocation;
  final String storeOrSellerName;
  final String sellerNumber;
  final String purchaserName;
  final String purchaserNumber;
  final String senderName;
  final String senderNumber;
  final String receiverName;
  final String receiverNumber;
  final String dropLocation;
  final String unit1;
  final String stairs1status;
  final String stairs1;
  final String unit2;
  final String stairs2status;
  final String stairs2;
  final String purchasedBy;
  final String elevators;
  final String elevators2;
  final String pickupLatitude;
  final String pickupLongitude;
  final String dropLatitude;
  final String dropLongitude;
// ⭐ Add new fields
  final String? driverAide;
  final String? vehicleType;
  final String? date;
  final String? startTime;
  final String? endTime;
  final String? movingType;
  final String? movingPrice;
  final String? totalCost;
  final String? driverCost;
  final String? adminCost;
  final String? driverAideCost;
  OrderData({
    required this.bookingType,
    required this.pickupLocation,
    required this.storeOrSellerName,
    required this.sellerNumber,
    required this.purchaserName,
    required this.purchaserNumber,
    required this.senderName,
    required this.senderNumber,
    required this.receiverName,
    required this.receiverNumber,
    required this.dropLocation,
    required this.unit1,
    required this.stairs1status,
    required this.stairs1,
    required this.unit2,
    required this.stairs2status,
    required this.stairs2,
    required this.purchasedBy,
    required this.elevators,
    required this.elevators2,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.dropLatitude,
    required this.dropLongitude,
    this.driverAide,
    this.vehicleType,
    this.date,
    this.startTime,
    this.endTime,
    this.movingType,
    this.movingPrice,
    this.totalCost,
    this.driverCost,
    this.adminCost,
    this.driverAideCost,
  });
// ⭐ Fully working copyWith
  OrderData copyWith({
    String? driverAide,
    String? vehicleType,
    String? date,
    String? startTime,
    String? endTime,
    String? movingType,
    String? movingPrice,
    String? totalCost,
    String? driverCost,
    String? adminCost,
    String? driverAideCost,
  }) {
    return OrderData(
      bookingType: bookingType,
      pickupLocation: pickupLocation,
      storeOrSellerName: storeOrSellerName,
      sellerNumber: sellerNumber,
      purchaserName: purchaserName,
      purchaserNumber: purchaserNumber,
      senderName: senderName,
      senderNumber: senderNumber,
      receiverName: receiverName,
      receiverNumber: receiverNumber,
      dropLocation: dropLocation,
      unit1: unit1,
      stairs1status: stairs1status,
      stairs1: stairs1,
      unit2: unit2,
      stairs2status: stairs2status,
      stairs2: stairs2,
      purchasedBy: purchasedBy,
      elevators: elevators,
      elevators2: elevators2,
      pickupLatitude: pickupLatitude,
      pickupLongitude: pickupLongitude,
      dropLatitude: dropLatitude,
      dropLongitude: dropLongitude,
// new fields
      driverAide: driverAide ?? this.driverAide,
      vehicleType: vehicleType ?? this.vehicleType,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      movingType: movingType ?? this.movingType,
      movingPrice: movingPrice ?? this.movingPrice,
      totalCost: totalCost ?? this.totalCost,
      driverCost: driverCost ?? this.driverCost,
      adminCost: adminCost ?? this.adminCost,
      driverAideCost: driverAideCost ?? this.driverAideCost,
    );
  }
}