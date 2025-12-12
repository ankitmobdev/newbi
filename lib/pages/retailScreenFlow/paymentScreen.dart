import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_eat_e_commerce_app/Stripe/PaymentServiceBooking.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../SharedPreference/AppSession.dart';
import '../../Stripe/PaymentService.dart';
import '../../constant.dart';
import '../../helper_class_snackbar.dart';
import '../../models/Global.dart';
import '../../models/OrderData.dart';
import '../../services/auth_service.dart';
import '../homeScreen/homeScreen.dart';

class PaymentMethodScreen extends StatefulWidget {
  final OrderData? orderData;
  const PaymentMethodScreen({super.key, this.orderData,});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {

  String selectedPayment = "";

  @override
  void initState() {
    super.initState();
    PaymentService().initializeStripe();
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
          child: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
        title: Text(
          "Payment Method",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),

      // ---------------- BODY ----------------
      body: Column(
        children: [
          const SizedBox(height: 10),

          // ---------------- PAYMENT OPTIONS ----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _paymentCard(
                  icon: "assets/images/card.svg",
                  title: "Card Payment",
                  value: "stripe",
                ),
                const SizedBox(height: 12),

                _paymentCard(
                  icon: "assets/images/mywallet.svg",
                  title: "My wallet",
                  value: "wallet",
                ),
                const SizedBox(height: 12),

                _paymentCard(
                  icon: "assets/images/cod.svg",
                  title: "Cash on Delivery",
                  value: "cod",
                ),
              ],
            ),
          ),

          const Spacer(),

          // ---------------- CONTINUE BUTTON ----------------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: selectedPayment.isEmpty ? null : () {
                  showConfirmPopup(context);
                },
                child: Text(
                  "Continue to Pay",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColor.secondaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
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
                      onPressed: () async {
                        Navigator.pop(context);

                        if (selectedPayment == "stripe") {
                          bool success = await PaymentServiceBooking().makePayment(
                            context,
                            widget.orderData!.totalCost.toString(),
                            AppSession().currency == "NGN" ? "ngn" : "gbp",
                          );
                          if (success) {
                            callBookingApi();   // <-- Now correct
                          }
                        } else {
                          callBookingApi();
                        }

                        //Helper.moveToScreenwithPush(context, HomeScreen());
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

  // =========================================================
  // PAYMENT OPTION CARD
  // =========================================================
  Widget _paymentCard({
    required String icon,
    required String title,
    required String value,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() => selectedPayment = value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColor.secondaryColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            // LEFT ICON
            SvgPicture.asset(
              icon,
              height: 20,
              width: 25,
            ),

            const SizedBox(width: 14),

            // TITLE
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // CUSTOM RADIO
            _customRadio(selectedPayment == value),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // CUSTOM RADIO BUTTON (matches screenshot)
  // =========================================================
  Widget _customRadio(bool isSelected) {
    return Container(
      height: 22,
      width: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.primaryColor, width: 2),
      ),
      child: isSelected
          ? Center(
        child: Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
      )
          : null,
    );
  }

  Future<void> callBookingApi() async {
    //setState(() => _isLoading = true);

    debugPrint("driver_cost_0: ${widget.orderData!.totalCost!}");
    debugPrint("driver_cost_1: ${widget.orderData!.driverCost!}");
    debugPrint("driver_cost_2: ${widget.orderData!.adminCost!}");
    debugPrint("driver_cost_3: ${widget.orderData!.driverAideCost!}");
    debugPrint("driver_cost_4: ${selectedPayment}");

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
        deliveryCost: order.totalCost!,
        adminCost: order.adminCost!,
        driverCost: order.driverCost!,
        driverPlusAideCost: order.driverAideCost!,
        //stripeAmount: "0",
        //stripeToken: "0",
        paymentType: selectedPayment,
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

}
