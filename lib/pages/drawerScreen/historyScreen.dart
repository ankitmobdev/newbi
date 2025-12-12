import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as local_notifications;
import '../../constant.dart';
import '../../main.dart';
import '../../services/auth_service.dart';
import '../../SharedPreference/AppSession.dart';
import '../../models/getdriverDeliveriesModel.dart';
import 'currentServiceDetailScreen.dart';
import 'drawerScreen.dart';

class HistoryServiceScreen extends StatefulWidget {
  const HistoryServiceScreen({super.key});

  @override
  State<HistoryServiceScreen> createState() => _HistoryServiceScreenState();
}

class _HistoryServiceScreenState extends State<HistoryServiceScreen> {
  List<Data> serviceList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchHistoryServices();
    });


    _listenFCMNotifications();   //
  }
  void _listenFCMNotifications() {
    FirebaseMessaging.onMessage.listen((message) {
      print("📩 Foreground Notification Received");
      _showLocalNotification(message);

      // Auto refresh data
      fetchCurrentServices(); // ✅ SAFE
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("📲 Notification opened from background");

      fetchCurrentServices(); // ✅ SAFE
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("🚀 Opened from terminated state");

        fetchCurrentServices(); // ✅ SAFE
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
  // ================= FETCH CURRENT SERVICES =================
  Future<void> fetchCurrentServices() async {
    setState(() => isLoading = true);
    _showLoader();

    try {
      final res = await AuthService.get_user_deliveries(
        user_id: AppSession().userId,
        type: "1", // ✅ CURRENT
      );

      final model = GetDriverDeliveryModel.fromJson(res);

      setState(() {
        serviceList = model.data ?? [];
      });
    } catch (e) {
      debugPrint("❌ Current services error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load current services")),
      );
    } finally {
      _hideLoader();
      setState(() => isLoading = false);
    }
  }
  // ================= FETCH HISTORY SERVICES =================
  Future<void> fetchHistoryServices() async {
    setState(() => isLoading = true);
    _showLoader();

    try {
      final res = await AuthService.get_user_deliveries(
        user_id: AppSession().userId,
        type: "2", // ✅ History
      );

      final model = GetDriverDeliveryModel.fromJson(res);

      setState(() {
        serviceList = model.data ?? [];
      });
    } catch (e) {
      debugPrint("❌ History services error: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load history")),
      );
    } finally {
      _hideLoader();
      setState(() => isLoading = false);
    }
  }

  // ================= LOADER =================
  void _showLoader() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => Center(
        child: Lottie.asset(
          'assets/animation/dots_loader.json',
          repeat: true,
        ),
      ),
    );
  }

  void _hideLoader() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomSideBar(),
      backgroundColor: const Color(0xffF4F4F4),

      // ---------------- APPBAR ----------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: AppColor.primaryColor),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          "Service History",
          style: GoogleFonts.poppins(
            color: AppColor.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Stack(
        children: [
          // BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              "assets/images/splashbackground.png",
              fit: BoxFit.cover,
            ),
          ),

          // GRADIENT OVERLAY
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xff04071980).withOpacity(0.50),
                    AppColor.primaryColor.withOpacity(0.77),
                  ],
                ),
              ),
            ),
          ),

          // ---------------- CONTENT ----------------
          if (isLoading)
            const SizedBox()
          else if (serviceList.isEmpty)
            Center(
              child: Text(
                "No History Found",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            )
          else
            ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
              itemCount: serviceList.length,
              itemBuilder: (context, index) {
                final item = serviceList[index];
                return Column(
                  children: [
                    InkWell(
                        onTap: () {
                          Helper.moveToScreenwithPush(
                            context,
                            DetailsFormScreen(
                              orderId: item.orderId!,
                            ),
                          );
                        },
                        child: _serviceCard(item)),
                    const SizedBox(height: 22),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  // ================= SERVICE CARD =================
  Widget _serviceCard(Data item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.secondaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(item),
          const SizedBox(height: 14),
          _routes(item),
          const SizedBox(height: 16),
          _completedButton(item.deliveryStatus.toString()),
        ],
      ),
    );
  }

  // ================= HEADER =================
  Widget _header(Data item) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundColor: Colors.black12,
          child: Icon(Icons.local_shipping, color: Colors.black),
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
                color: Colors.black54,
              ),
            ),
          ],
        ),

        const Spacer(),
        const Icon(Icons.arrow_forward_ios, size: 16),
      ],
    );
  }

  // ================= ROUTES =================
  Widget _routes(Data item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          "assets/images/pickupDropup.png",
          height: 120,
          width: 22,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _locationTile("Pickup", item.pickupaddress ?? "N/A",item.deliveryStatus ?? "N/A"),
              Divider(color: Colors.grey.shade300),
              _locationTile("Drop-Off", item.dropoffaddress ?? "N/A",item.deliveryStatus ?? "N/A"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _locationTile(String title, String address,String status) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          address,
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            height: 1.3,
          ),
        ),
      ],
    );
  }

  // ================= COMPLETED BUTTON =================
  Widget _completedButton(String status) {
    return Container(
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColor.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColor.secondaryColor,
        ),
      ),
    );
  }
}
