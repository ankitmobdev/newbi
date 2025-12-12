import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../SharedPreference/AppSession.dart';
import '../../../constant.dart';
import '../../../models/nearbyModel.dart';
import '../../../services/api_constants.dart';
import '../../../services/auth_service.dart';
import 'detailScreenDriver.dart';
import 'drawerScreenDriver.dart';

class AvailableDeliveriesScreen extends StatefulWidget {
  const AvailableDeliveriesScreen({super.key});

  @override
  State<AvailableDeliveriesScreen> createState() =>
      _AvailableDeliveriesScreenState();
}

class _AvailableDeliveriesScreenState extends State<AvailableDeliveriesScreen> {
  bool isLoading = true;
  List<NearByData> deliveryList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchNearByDeliveries();   // now context is safe ✔
    });
  }

  Future<void> fetchNearByDeliveries() async {
    try {
      _showLoader(); // 🔥 Show lottie loader

      String userId = AppSession().userId;

      final loc = await getCurrentLocation();
      String lat = loc["lat"].toString();
      String lng = loc["lng"].toString();

      print("📤 Sending nearbyDelivery request → ");
      print({
        "code": ApiCode.kcode,
        "user_id": userId,
        "latitude": lat,
        "longitude": lng,
      });

      final response = await AuthService.nearbyDelivery(
        user_id: userId,
        latitude: lat,
        longitude: lng,
      );

      print("📥 nearbyDelivery API Raw Response → $response");

      if (mounted) Navigator.pop(context); // 🔥 Close loader

      final model = NearByDeliveryModel.fromJson(response);

      if (model.result == "true" || model.result == "success") {
        setState(() {
          deliveryList = model.data ?? [];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }

    } catch (e) {
      if (mounted) Navigator.pop(context); // 🔥 Close loader on error

      setState(() => isLoading = false);
      print("❌ Error in fetchNearByDeliveries: $e");
    }
  }




  Future<void> acceptOrder(String orderId) async {
    try {
      print("📤 Sending acceptDeliveryRequest → ");
      print({
        "code": ApiCode.kcode,
        "driver_id": AppSession().userId,
        "order_id": orderId,
      });

      _showLoader();

      final res = await AuthService.acceptDeliveryRequest(
        driver_id: AppSession().userId,
        order_id: orderId,
      );

      Navigator.pop(context);

      print("📥 acceptDeliveryRequest API Response → $res");

      if (res["result"] == "true" || res["result"] == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Delivery Accepted")),
        );

        setState(() {
          deliveryList.removeWhere((d) => d.orderId == orderId);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res["message"] ?? "Failed to Accept")),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      print("❌ Error in acceptOrder: $e");
    }
  }

  void _showLoader() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Lottie.asset(
          'assets/animation/dots_loader.json',
          repeat: true,         // important!
          fit: BoxFit.contain,
        ),
      ),
    );
  }


  Future<Map<String, double>> getCurrentLocation() async {
    LocationPermission permission;

    // Check permission
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw "Location permission denied";
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw "Location permission permanently denied";
    }

    // Get current lat/long
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return {"lat": pos.latitude, "lng": pos.longitude};
  }

  Future<void> declineOrder(String orderId) async {
    try {
      print("📤 Sending decline_order_driver → ");
      print({
        "code": ApiCode.kcode,
        "driver_id": AppSession().userId,
        "order_id": orderId,
      });

      _showLoader();

      final res = await AuthService.decline_order_driver(
        driver_id: AppSession().userId,
        order_id: orderId,
      );

      Navigator.pop(context);

      print("📥 decline_order_driver API Response → $res");

      if (res["result"] == "true" || res["result"] == "Success") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Delivery Declined")),
        );

        setState(() {
          deliveryList.removeWhere((d) => d.orderId == orderId);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res["message"] ?? "Failed to Decline")),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      print("❌ Error in declineOrder: $e");
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DriverCustomSideBar(),
      backgroundColor: AppColor.secondaryColor,

      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
        ),
        title: Text(
          "Available Deliveries",
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColor.primaryColor,
          ),
        ),
      ),

      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset("assets/images/splashbackground.png", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF040719).withOpacity(0.5),
                    AppColor.primaryColor.withOpacity(0.75),
                  ],
                ),
              ),
            ),
          ),

          // -------------------- LOADER --------------------



          // -------------------- EMPTY STATE --------------------
          if (!isLoading && deliveryList.isEmpty)
            Center(
              child: Text(
                "No Nearby Deliveries",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),

          // -------------------- LIST VIEW --------------------
          if (!isLoading && deliveryList.isNotEmpty)
            ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
              itemCount: deliveryList.length,
              itemBuilder: (context, i) {
                final d = deliveryList[i];

                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Helper.moveToScreenwithPush(
                            context, DetailsFormDriverScreen(orderId: d.orderId!));
                      },
                      child: _deliveryCard(
                        vehicle: d.vehicleType ?? "",
                        date: "${d.date}   ${d.fromTime} - ${d.toTime}",
                        pickup: d.pickupaddress ?? "",
                        drop: d.dropoffaddress ?? "",orderId: d.orderId ?? ""
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }



  void showConfirmPopup({
    required BuildContext context,
    required String orderId,
    required bool isAccept,   // true = accept, false = decline
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
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

                /// TITLE
                Text(
                  isAccept ? "Accept Delivery" : "Decline Delivery",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                /// MESSAGE
                Text(
                  isAccept
                      ? "Do you want to accept this delivery?"
                      : "Do you want to decline this delivery?",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),

                /// BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "No",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
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

                        // 🔥 Call correct API
                        if (isAccept) {
                          await acceptOrder(orderId);
                        } else {
                          await declineOrder(orderId);
                        }
                      },
                      child: Text(
                        "Yes",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: AppColor.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  // -------------------- CARD UI --------------------
  Widget _deliveryCard({
    required String vehicle,
    required String date,
    required String pickup,
    required String drop,
    required String orderId,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- TOP ROW ----------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 38,
                    width: 38,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.local_shipping,
                        size: 18, color: Colors.white),
                  ),
                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vehicle,
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      Text(
                        date,
                        style: GoogleFonts.poppins(
                            fontSize: 11.5, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),

              const Icon(Icons.arrow_forward_ios,
                  size: 14, color: Colors.black45),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset("assets/images/pickupDropup.png", height: 110, width: 20),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _locationTile(title: "Pickup", address: pickup),
                    Divider(thickness: 1, color: Colors.grey.shade300),
                    _locationTile(title: "Drop-Off", address: drop),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Accept / Decline
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    showConfirmPopup(
                      context: context,
                      orderId: orderId,
                      isAccept: true,   // ✔ Accept
                    );
                  },

                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Accept",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InkWell(
                  onTap: () {
                    showConfirmPopup(
                      context: context,
                      orderId: orderId,
                      isAccept: false,  // ❌ Decline
                    );
                  },

                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red, width: 1.3),
                    ),
                    child: Center(
                      child: Text(
                        "Decline",
                        style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _locationTile({
    required String title,
    required String address,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
          GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          address,
          style: GoogleFonts.poppins(
              fontSize: 12.5, height: 1.3, color: Colors.black87),
        ),
      ],
    );
  }
}
