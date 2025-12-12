import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as local_notifications;
import '../../constant.dart';
import '../../main.dart';
import '../../services/auth_service.dart';
import '../../SharedPreference/AppSession.dart';
import '../../models/getdriverDeliveriesModel.dart';

import 'currentServiceDetailScreen.dart';
import 'drawerScreen.dart';

class CurrentServiceScreen extends StatefulWidget {
  const CurrentServiceScreen({super.key});

  @override
  State<CurrentServiceScreen> createState() => _CurrentServiceScreenState();
}

class _CurrentServiceScreenState extends State<CurrentServiceScreen> {
  List<Data> serviceList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCurrentServices(); // ✅ SAFE
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

  // ================= LOADER =================
  void _showLoader() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => Center(
        child: Lottie.asset(
          "assets/animation/dots_loader.json",
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
          "Current Service",
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
                "No Current Services",
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
                      child: _serviceCard(item),
                    ),
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
          _statusSection(item.deliveryStatus,item.phone_code.toString(),item.userPhone.toString()),
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
              style: GoogleFonts.poppins(fontSize: 12),
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
              _location("Pickup", item.pickupaddress),
              Divider(color: Colors.grey.shade300),
              _location("Drop-Off", item.dropoffaddress),
            ],
          ),
        ),
      ],
    );
  }

  Widget _location(String title, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value ?? "N/A",
          style: GoogleFonts.poppins(fontSize: 12.5),
        ),
      ],
    );
  }

  // ================= STATUS SECTION =================
  Widget _statusSection(String? status,String phone_code,String phone) {
    if (status == "Inprogress") {
      return _button("Waiting For Acceptance", const Color(0xffD4D4D4));
    } else {
      return Column(
        children: [
          _button(status.toString(), Colors.black),
          const SizedBox(height: 10),
          InkWell(
              onTap: () {
                openWhatsapp(
                  phone_code.toString()+phone.toString(),
                  message: "Hello",
                );
              },
              child: _button("Chat", AppColor.secondprimaryColor)),
        ],
      );
    }
  }

  Widget _button(String text, Color color) {
    return Container(
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: AppColor.secondaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
