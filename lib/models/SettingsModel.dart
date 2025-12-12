class SettingsModel {
  final String result;
  final String message;
  final Vehicle vehicle;
  SettingsModel({required this.result, required this.message, required this.vehicle});
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      result: json['result'] ?? '',
      message: json['message'] ?? '',
      vehicle: Vehicle.fromJson(json['vehicle'] ?? {}),
    );
  }
}
class Vehicle {
  final double cargoVan;
  final double pickupTruck;
  final double car;
  final double miniVan;
  final double boxTruck;
  final double stairs;
  final double driverAside;
  final double retailStoreBasePrice;
  final double onlineMarketBasePrice;
  final double furnitureDeliveryBasePrice;
  final double movingHelpBasePrice;
  final double courierServiceBasePrice;
  final double perMileCharge;
  final double adminPercentage;
// Moving Help fields
  final double studio;
  final double bedroom1;
  final double bedroom2;
// Appliance prices
  final double dishwasher;
  final double refrigerator;
  final double washer;
  final double dryer;
  final double oven;
  final double other;
// NEW fields (courier)
  final double courierPackage;
  final double courierEnvelope;
  final double courierDocument;
  final double packageLetters;
  final double shoppingBag;
// NEW fields (retail & online sizes)
  final double retailStoreSmall;
  final double retailStoreMedium;
  final double retailStoreLarge;
  final double retailStoreXLarge;
  final double onlineMarketSmall;
  final double onlineMarketMedium;
  final double onlineMarketLarge;
  final double onlineMarketXLarge;
  Vehicle({
    required this.cargoVan,
    required this.pickupTruck,
    required this.car,
    required this.miniVan,
    required this.boxTruck,
    required this.stairs,
    required this.driverAside,
    required this.retailStoreBasePrice,
    required this.onlineMarketBasePrice,
    required this.furnitureDeliveryBasePrice,
    required this.movingHelpBasePrice,
    required this.courierServiceBasePrice,
    required this.perMileCharge,
    required this.adminPercentage,
    required this.studio,
    required this.bedroom1,
    required this.bedroom2,
    required this.dishwasher,
    required this.refrigerator,
    required this.washer,
    required this.dryer,
    required this.oven,
    required this.other,
    required this.courierPackage,
    required this.courierEnvelope,
    required this.courierDocument,
    required this.packageLetters,
    required this.shoppingBag,
    required this.retailStoreSmall,
    required this.retailStoreMedium,
    required this.retailStoreLarge,
    required this.retailStoreXLarge,
    required this.onlineMarketSmall,
    required this.onlineMarketMedium,
    required this.onlineMarketLarge,
    required this.onlineMarketXLarge,
  });
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        return double.tryParse(value.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0.0;
      }
      return 0.0;
    }
    return Vehicle(
      cargoVan: parseDouble(json['cargo_van']),
      pickupTruck: parseDouble(json['pickup_truck']),
      car: parseDouble(json['car']),
      miniVan: parseDouble(json['mini_van']),
      boxTruck: parseDouble(json['box_truck']),
      stairs: parseDouble(json['stairs']),
      driverAside: parseDouble(json['driver_aside']),
      retailStoreBasePrice: parseDouble(json['retail_store_base_price']),
      onlineMarketBasePrice: parseDouble(json['online_market_base_price']),
      furnitureDeliveryBasePrice: parseDouble(json['furniture_delivery_base_price']),
      movingHelpBasePrice: parseDouble(json['moving_help_base_price']),
      courierServiceBasePrice: parseDouble(json['courier_service_base_price']),
      perMileCharge: parseDouble(json['per_mile_charge']),
      adminPercentage: parseDouble(json['admin_percentage']),
      studio: parseDouble(json['studio']),
      bedroom1: parseDouble(json['bedroom1']),
      bedroom2: parseDouble(json['bedroom2']),
      dishwasher: parseDouble(json['Dishwasher']),
      refrigerator: parseDouble(json['Refrigerator']),
      washer: parseDouble(json['Washer']),
      dryer: parseDouble(json['Dryer']),
      oven: parseDouble(json['Oven']),
      other: parseDouble(json['Other']),
// courier
      courierPackage: parseDouble(json['courier_package']),
      courierEnvelope: parseDouble(json['courier_envelope']),
      courierDocument: parseDouble(json['courier_document']),
      packageLetters: parseDouble(json['package_letters']),
      shoppingBag: parseDouble(json['shopping_bag']),
// retail & online sizes
      retailStoreSmall: parseDouble(json['retail_store_small']),
      retailStoreMedium: parseDouble(json['retail_store_medium']),
      retailStoreLarge: parseDouble(json['retail_store_large']),
      retailStoreXLarge: parseDouble(json['retail_store_xlarge']),
      onlineMarketSmall: parseDouble(json['online_market_small']),
      onlineMarketMedium: parseDouble(json['online_market_medium']),
      onlineMarketLarge: parseDouble(json['online_market_large']),
      onlineMarketXLarge: parseDouble(json['online_market_xlarge']),
    );
  }
}