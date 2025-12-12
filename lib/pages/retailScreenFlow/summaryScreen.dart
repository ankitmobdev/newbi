import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_eat_e_commerce_app/SharedPreference/AppSession.dart';
import 'package:go_eat_e_commerce_app/pages/retailScreenFlow/paymentScreen.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../constant.dart';
import '../../helper_class_snackbar.dart';
import '../../models/Global.dart';
import '../../models/OrderData.dart';
import '../../models/SettingsModel.dart';
import '../../services/api_constants.dart';
import '../../services/auth_service.dart';
import '../homeScreen/homeScreen.dart';
import 'dart:math';

class SummaryScreen extends StatefulWidget {

  final OrderData? orderData;
  const SummaryScreen({super.key, this.orderData,});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool agreeTerms = false;

  bool _isLoading = false;
  double distanceInMiles = 0.0; // example
  //double movingPrice = 0.0; // example
  double totalItemPrice = 0.0; // example

  double totalPrice = 0.0;
  double driverAide = 0.0;
  double driverCost = 0.0;
  double adminCommission = 0.0;

  @override
  void initState() {
    super.initState();

    // Calculate distance in km
    double distanceInKm = calculateDistance(
      double.parse(widget.orderData!.pickupLatitude!),
      double.parse(widget.orderData!.pickupLongitude!),
      double.parse(widget.orderData!.dropLatitude!),
      double.parse(widget.orderData!.dropLongitude!),
    );

    debugPrint("=====distanceInKm=$distanceInKm");

    // Convert to miles
    distanceInMiles = distanceInKm / 1.609;
    debugPrint("=====distanceInMiles=$distanceInMiles");

    String json = jsonEncode(Global.packageList.map((item) => {
      "categoryName": item.categoryName,
      "subcategory": item.subcategory,
      "quantity": item.quantity,
      "instruction": item.instruction,
      "extraSubcategory": item.extraSubcategory,
      "price": item.price,
    }).toList());

    debugPrint("📦 package_list_json: $json");

    for (var item in Global.packageList) {
      totalItemPrice += double.tryParse(item.price ?? "0") ?? 0;
    }

    debugPrint("=====totalItemPrice=$totalItemPrice");

    debugPrint("=====ordertime=${widget.orderData!.startTime}");
    //debugPrint("=====movingPrice=${widget.orderData!.movingPrice}");

    callSettingsApi();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
        title: Text(
          "Summary",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColor.primaryColor,
          ),
        ),
      ),

      // ---------------- BODY ----------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- PICKUP & DROPOFF BOX ----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColor.secondaryColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // LEFT PICKUP → DROPOFF IMAGE
                  Image.asset(
                    "assets/images/pickupDropup.png",
                    height: 95,    // adjust height according your design
                    width: 20,     // slender vertical image
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(width: 12),

                  // RIGHT SIDE CONTENT (Pickup + Dropoff)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       Container(
                         width: MediaQuery.of(context).size.width,
                         decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(12),
                           border: Border.all(color: AppColor.borderColor),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               const SizedBox(height: 10),
                             Text(
                               "Pickup",
                               style: GoogleFonts.poppins(
                                 fontSize: 13,
                                 fontWeight: FontWeight.w500,
                                 color: AppColor.textclr,
                               ),
                             ),
                             Container(
                               padding: const EdgeInsets.all(5),
                               decoration: BoxDecoration(
                                 color: Colors.white,
                                 borderRadius: BorderRadius.circular(10),
                               ),
                               child: Text(
                                 widget.orderData!.pickupLocation,
                                 style: GoogleFonts.poppins(
                                   fontSize: 14,
                                   color: AppColor.primaryColor,
                                 ),
                               ),
                             ),
                           ],),
                         ),
                       ),
                        // ---------------- PICKUP ----------------
                        const SizedBox(height: 16),

                        // ---------------- DROPOFF ----------------
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColor.borderColor),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  "Drop–Off",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color:AppColor.textclr,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    widget.orderData!.dropLocation,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                ],
              ),
            ),


            const SizedBox(height: 20),

            // TITLE
            Text(
              "Total ${Global.packageList.length} Items",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColor.textclr,
              ),
            ),
            const SizedBox(height: 12),

            // LIST OF ITEMS
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: Global.packageList.length,
              itemBuilder: (context, index) {
                final item = Global.packageList[index];

                final bool showSubCategory =
                    widget.orderData!.bookingType == "FurnitureDelivery" ||
                        widget.orderData!.bookingType == "MovingHelp";

                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // FIRST ROW → Quantity + Category
                      Row(
                        children: [
                          Text(
                            item.quantity ?? "0",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 10),

                          // CATEGORY NAME
                          Text(
                            item.categoryName ?? "",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),

                      // SUBCATEGORY (Only for FurnitureDelivery / MovingHelp)
                      if (showSubCategory && (item.subcategory?.isNotEmpty ?? false)) ...[
                        const SizedBox(height: 6),
                        Text(
                          item.subcategory ?? "",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),

          SizedBox(
            height: MediaQuery.of(context).size.height*0.15,
          ),

            // ---------------- TOTAL PRICE ----------------
            Center(
              child: Text(
                "Total Price: "
                    "${AppSession().currency == "NGN" ? "₦" : "£"}"
                    "${totalPrice.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 20,
                  color: AppColor.secondprimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- TERMS CHECKBOX ----------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: AppColor.primaryColor,
                  value: agreeTerms,
                  onChanged: (v) {
                    setState(() => agreeTerms = v ?? false);
                  },
                ),
                Expanded(
                  child: Text(
                    "I agree to Pricing Policy, Terms of Service and Cancelation Policy",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color:  AppColor.primaryColor,fontWeight: FontWeight.w400
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ---------------- BOOK BUTTON ----------------
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: agreeTerms ? () {
                  //showConfirmPopup(context);
                  final updatedOrder = widget.orderData!.copyWith(
                    totalCost: totalPrice.toStringAsFixed(2),
                    driverCost: driverCost.toStringAsFixed(2),
                    adminCost: adminCommission.toStringAsFixed(2),
                    driverAideCost: driverAide.toStringAsFixed(2),
                  );
                  Helper.moveToScreenwithPush(context, PaymentMethodScreen(orderData: updatedOrder));
                } : null,
                child: Text(
                  "Book",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColor.secondaryColor,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void showConfirmPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must choose Cancel or Okay
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------------- TITLE ----------------
                Text(
                  "Confirm",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                // ---------------- MESSAGE ----------------
                Text(
                  "Please confirm to proceed this order",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                // ---------------- BUTTONS ROW ----------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // ❌ CANCEL BUTTON
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    // ✔ OKAY BUTTON
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor, // black
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        callBookingApi();
                        //Helper.moveToScreenwithPush(context, PaymentMethodScreen());
                        // Add next action here
                      },
                      child: Text(
                        "Okay",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: AppColor.secondaryColor, // white
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> callBookingApi() async {
    //setState(() => _isLoading = true);

    debugPrint("driver_cost_0: ${driverCost.toStringAsFixed(2)}");
    debugPrint("driver_cost_1: ${adminCommission.toStringAsFixed(2)}");
    debugPrint("driver_cost_2: ${driverAide.toStringAsFixed(2)}");

    _showLoader();
    try {
      final order = widget.orderData!;

      // Convert package list to JSON
      String packageInfoJson = jsonEncode(Global.packageList.map((e) => e.toJson()).toList());
      debugPrint("packageInfoJson: $packageInfoJson"); // ← debug print like Kotlin Log.e

      final response = await AuthService.booking(
        userId: AppSession().userId,
        vehicleType: order.vehicleType!,
        fromTime: order.startTime!,
        toTime: order.endTime!,
        date: order.date!,
        bookingTime: order.receiverName!,
        sellerName: order.storeOrSellerName!,
        sellerNumber: order.sellerNumber!,
        unitOrApartment2: order.unit2!,
        staircase2: order.stairs2status!,
        elevator2: order.elevators2!,
        numberOfStairs2: order.stairs2!,
        storeName: order.storeOrSellerName!,
        itemPurchaseBy: order.purchasedBy!,
        purchaserName: order.purchaserName!,
        purchaserNumber: order.purchaserNumber!,
        unitOrApartment: order.unit1!,
        pickupAddress: order.pickupLocation!,
        pickupLat: order.pickupLatitude!,
        pickupLong: order.pickupLongitude!,
        dropoffAddress: order.dropLocation!,
        dropoffLat: order.dropLatitude!,
        dropoffLong: order.dropLongitude!,
        staircase: order.stairs1status!,
        numberOfStairs: order.stairs1!,
        elevators: order.elevators!,
        aideAndDriver: order.driverAide!,
        bookingType: order.bookingType,
        packageInfoJson: packageInfoJson,
        deliveryCost: totalPrice.toStringAsFixed(2),
        adminCost: adminCommission.toStringAsFixed(2),
        driverCost: driverCost.toStringAsFixed(2),
        driverPlusAideCost: driverAide.toStringAsFixed(2),
        //stripeAmount: "0",
        //stripeToken: "0",
        paymentType: "cod",
      );

      if (response["result"] == "Success") {
        AppSnackBar.success(response["message"]);
        Helper.moveToScreenwithPush(context, HomeScreen());
      } else {
        AppSnackBar.error(response["message"]);
      }
    } catch (e) {
      print("❌ Booking error: $e");
      AppSnackBar.error("Error: $e");
      //AppSnackBar.success(response["message"]);
      //Helper.moveToScreenwithPush(context, HomeScreen());
    } finally {
      //setState(() => _isLoading = false);
    }
  }

  Future<SettingsModel?> fetchSettingsDio(String userId) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        BaseURl.baseUrl + ApiAction.getsettings,
        data: {
          "code": ApiCode.kcode,
          "user_id": userId,
        },
        options: Options(
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      print('📥 Raw response: ${response.data}');

      // Decode if response is a String
      Map<String, dynamic> jsonData;
      if (response.data is String) {
        jsonData = jsonDecode(response.data);
      } else {
        jsonData = response.data;
      }

      print('📥 Parsed JSON: $jsonData');

      return SettingsModel.fromJson(jsonData);
    } catch (e) {
      print('❌ Dio error: $e');
      return null;
    }
  }

  // ------------------ CALL SETTINGS AND CALCULATE ------------------
  Future<void> callSettingsApi() async {
    setState(() => _isLoading = true);

    try {
      final settings = await fetchSettingsDio(AppSession().userId);

      if (settings == null) {
        AppSnackBar.error('Failed to fetch settings.');
        return;
      }

      debugPrint("=====movingPrice=${widget.orderData!.movingPrice}");
      final movingPriceString = widget.orderData!.movingPrice ?? "0";

      // Remove any non-numeric characters except dot (.)
      final cleanedPrice = movingPriceString.replaceAll(RegExp(r'[^\d.]'), '');

      final double finalPrice = calculateTotalPrice(
        settings: settings,
        bookingType: widget.orderData!.bookingType,
        vehicleType: widget.orderData!.vehicleType!,
        numberOfStairs1: double.tryParse(widget.orderData!.stairs1) ?? 0.0,
        numberOfStairs2: double.tryParse(widget.orderData!.stairs2) ?? 0.0,
        aideAndDriver: widget.orderData!.driverAide!,
        distanceInMiles: distanceInMiles,
        movingPrice: double.tryParse(cleanedPrice) ?? 0.0,
        totalItemPrice: totalItemPrice,
      );

      debugPrint("📦 Final Price: $finalPrice");
      // Update the state to refresh UI
      setState(() {
        totalPrice = finalPrice;
      });

      // Update UI if needed
      // packageBinding.tvTotalPrice.text = "Total Price : ${finalPrice.toStringAsFixed(2)}";

    } catch (e) {
      print('❌ Settings API error: $e');
      AppSnackBar.error('Settings API failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ------------------ CALCULATE TOTAL PRICE ------------------
  double calculateTotalPrice({
    required SettingsModel settings,
    required String bookingType,
    required String vehicleType,
    required double numberOfStairs1,
    required double numberOfStairs2,
    required String aideAndDriver,
    required double distanceInMiles,
    required double movingPrice,
    required double totalItemPrice,
  }) {
    final v = settings.vehicle;

    // Base price
    double basePrice = 0.0;
    switch (bookingType) {
      case "RetailStore":
        basePrice = v.retailStoreBasePrice;
        break;
      case "OnlineMarket":
        basePrice = v.onlineMarketBasePrice;
        break;
      case "FurnitureDelivery":
        basePrice = v.furnitureDeliveryBasePrice;
        break;
      case "MovingHelp":
        debugPrint("=====movingPrice1=${movingPrice}");
        debugPrint("=====movingPrice2=${v.movingHelpBasePrice}");
        basePrice = v.movingHelpBasePrice + movingPrice;
        debugPrint("=====movingPrice3=${basePrice}");
        break;
      case "CourierService":
        basePrice = v.courierServiceBasePrice;
        break;
    }

    // Vehicle cost
    double vehicleCost = 0.0;
    switch (vehicleType) {
      case "Car":
        vehicleCost = v.car;
        break;
      case "Mini van":
        vehicleCost = v.miniVan;
        break;
      case "Cargo van":
        vehicleCost = v.cargoVan;
        break;
      case "Pickup truck":
        vehicleCost = v.pickupTruck;
        break;
      case "Box truck":
        vehicleCost = v.boxTruck;
        break;
    }

    driverAide = aideAndDriver == "driverPlusAide" ? v.driverAside : 0.0;
    final double distancePrice = distanceInMiles * v.perMileCharge;
    final double stairsPrice = (numberOfStairs1 + numberOfStairs2) * v.stairs;

    double totalCost = basePrice + vehicleCost + stairsPrice + distancePrice + totalItemPrice;
    double finalCost = totalCost + driverAide;

    driverCost = totalCost - ((totalCost * v.adminPercentage) / 100);
    adminCommission = totalCost - driverCost;

    debugPrint('💰 Base Price: $basePrice');
    debugPrint('💰 Vehicle Cost: $vehicleCost');
    debugPrint('💰 Distance Price: $distancePrice');
    debugPrint('💰 Stairs Price: $stairsPrice');
    debugPrint('💰 Driver Aide: $driverAide');
    debugPrint('💰 Total Cost: $totalCost');
    debugPrint('💰 Final Cost: $finalCost');
    debugPrint('💰 Item Cost: $totalItemPrice');
    debugPrint('💰 Driver Cost: $driverCost');
    debugPrint('💰 Admin Commission: $adminCommission');

    return finalCost;
  }

  double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String && value.isNotEmpty) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  void _showLoader() {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) => Center(
        child: Lottie.asset(
          'assets/animation/dots_loader.json',
          repeat: true,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // Haversine formula
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // km
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
            cos(_degToRad(lat1)) * cos(_degToRad(lat2)) *
                sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    return distance;
  }

  double _degToRad(double deg) {
    return deg * (pi / 180);
  }

}
