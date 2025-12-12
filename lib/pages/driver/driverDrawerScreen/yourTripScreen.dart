import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as local_notifications;
import '../../../constant.dart';
import '../../../main.dart';
import '../../../models/getdriverDeliveriesModel.dart';
import 'detailScreenDriver.dart';
import 'drawerScreenDriver.dart';

import '../../../services/auth_service.dart';

import '../../../SharedPreference/AppSession.dart';

class YourTripsScreen extends StatefulWidget {
  const YourTripsScreen({super.key});

  @override
  State<YourTripsScreen> createState() => _YourTripsScreenState();
}

class _YourTripsScreenState extends State<YourTripsScreen> {
  int selectedTab = 0; // 0 = Current, 1 = History
  bool isLoading = false;

  List<Data> tripList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchTrips(); // ✅ SAFE
    });

    _listenFCMNotifications();   //
  // Load default (current trips)
  }

  void _listenFCMNotifications() {
    FirebaseMessaging.onMessage.listen((message) {
      print("📩 Foreground Notification Received");
      _showLocalNotification(message);

      // Auto refresh data
      fetchTrips();
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("📲 Notification opened from background");

      fetchTrips();
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("🚀 Opened from terminated state");

        fetchTrips();
      }
    });
  }

  void _showLocalNotification(RemoteMessage message) async {
    const androidDetails = local_notifications.AndroidNotificationDetails(
      'driver_channel',
      'Driver Notifications',
      importance: local_notifications.Importance.max,
      priority: local_notifications.Priority.high,
    );

    final platformDetails =
    local_notifications.NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification?.title ?? "New Notification",
      message.notification?.body ?? "",
      platformDetails,
    );
  }
  // ======================= GET DRIVER TRIPS API =======================
  Future<void> fetchTrips() async {
    _showLoader(); // ✅ SHOW LOADER

    try {
      debugPrint("📤 FETCH TRIPS REQUEST");

      final String driverId = AppSession().userId;
      final String type = selectedTab == 0 ? "1" : "2"; // 1 = current, 2 = history

      debugPrint("➡ driver_id: $driverId");
      debugPrint("➡ type: $type");

      final res = await AuthService.get_driver_deliveries(
        type: type,
        driver_id: driverId,
      );

      debugPrint("📥 FETCH TRIPS RESPONSE: $res");

      final model = GetDriverDeliveryModel.fromJson(res);

      if (model.result == "success") {
        setState(() {
          tripList = model.data ?? [];
        });
      } else {
        setState(() {
          tripList = [];
        });
      }
    } catch (e) {
      debugPrint("❌ FETCH TRIPS ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load trips")),
      );
    } finally {
      // ✅ SAFETY: ensure loader is closed
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        _hideLoader();
      }
    }
  }

  // ================= LOADER =================
  void _showLoader() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => Center(
        child: Lottie.asset('assets/animation/dots_loader.json'),
      ),
    );
  }

  void _hideLoader() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DriverCustomSideBar(),
      backgroundColor: AppColor.secondaryColor,

      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        elevation: 1,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          "Your Trips",
          style: GoogleFonts.poppins(
            color: AppColor.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Stack(
        children: [
          // BG
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/splashbackground.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Positioned.fill(
            child: Container(
              color: AppColor.primaryColor.withOpacity(0.85),
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 8),

              // -------------------- TABS --------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _tabButton("Current Trips", 0),
                    const SizedBox(width: 12),
                    _tabButton("History Trips", 1),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // -------------------- LIST --------------------
              Expanded(
                child: isLoading
                    ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
                    : tripList.isEmpty
                    ? Center(
                  child: Text(
                    "No Trips Found",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  itemCount: tripList.length,
                  itemBuilder: (context, index) {
                    final item = tripList[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: InkWell(
                        onTap: () {
                          Helper.moveToScreenwithPush(
                            context,
                            DetailsFormDriverScreen(
                              fromScreen: "trip",
                              orderId: item.orderId,
                            ),
                          );
                        },
                        child: _tripCard(item),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= TAB BUTTON =================
  Widget _tabButton(String title, int index) {
    bool active = selectedTab == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
          fetchTrips(); // 🔥 reload data on tab change
        },
        child: Container(
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColor.secondaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.secondaryColor, width: 1),
          ),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: active ? AppColor.primaryColor : AppColor.secondaryColor,
            ),
          ),
        ),
      ),
    );
  }

  // ================= TRIP CARD (DYNAMIC) =================
  Widget _tripCard(Data item) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- HEADER ----------------
          Row(
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_shipping,
                    color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.vehicleType ?? "N/A",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  Text(
                    "${item.date ?? ""}, ${item.fromTime ?? ""}",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColor.textclr,
                    ),
                  ),
                ],
              ),

              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/images/pickupDropup.png",
                height: 110,
                width: 24,
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  children: [
                    _locationTile(
                      "Pickup",
                      item.pickupaddress ?? "N/A",
                      Colors.green,
                    ),
                    Divider(height: 22, color: Colors.grey.shade300),
                    _locationTile(
                      "Drop-Off",
                      item.dropoffaddress ?? "N/A",
                      Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ---------------- STATUS BUTTON ----------------
          Container(
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              item.deliveryStatus ?? "Status",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // ---------------- CHAT BUTTON ----------------
          InkWell(
            onTap: () {
              openWhatsapp(
                item.phone_code.toString()+item.userPhone.toString(),
                message: "Hello, regarding your order ${item.orderId}",
              );
            },
            child: Container(
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColor.secondprimaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Chat",
                style: GoogleFonts.poppins(
                  color: AppColor.secondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  // ================= LOCATION TILE =================
  Widget _locationTile(String title, String address, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: AppColor.textclr,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          address,
          style: GoogleFonts.poppins(
            fontSize: 12,
            height: 1.3,
            fontWeight: FontWeight.w500,
            color: AppColor.primaryColor,
          ),
        ),
      ],
    );
  }

  Future<void> openWhatsapp(String phone, {String message = ""}) async {
    // ✅ Remove +, spaces, brackets, etc.
    final cleanPhone = phone
        .replaceAll("+", "")
        .replaceAll(" ", "")
        .replaceAll("-", "");

    debugPrint("📱 WhatsApp number => $cleanPhone");

    final Uri url = Uri.parse(
      "https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
    else {
      if (!await canLaunchUrl(url)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("WhatsApp not installed or Invalid Number")),
        );
        return;
      }

      throw "Could not open WhatsApp";
    }
  }
}
