import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as local_notifications;
import '../../../SharedPreference/AppSession.dart';
import '../../../constant.dart';
import '../../../main.dart';
import '../../../models/notificationModel.dart';
import '../../../services/auth_service.dart';
import 'drawerScreenDriver.dart';
import 'package:lottie/lottie.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Data> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchNotifications();
    });
    _listenFCMNotifications();   //
  }
  void _listenFCMNotifications() {
    FirebaseMessaging.onMessage.listen((message) {
      print("📩 Foreground Notification Received");
      _showLocalNotification(message);

      // Auto refresh data
      _listenFCMNotifications();   //
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("📲 Notification opened from background");

      _listenFCMNotifications();   //
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("🚀 Opened from terminated state");

        _listenFCMNotifications();   //
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
  // ================= LOADER =================
  // ===================== FETCH NOTIFICATIONS API =====================
  Future<void> fetchNotifications() async {
    _showLoader();
    try {
      final res = await AuthService.notifications(
        user_id: AppSession().userId,
      );

      print("📥 Notification API RAW Response → $res");

      final model = NotificationModel.fromJson(res);

      if (model.result == "success" || model.result == "true") {
        notifications = model.data ?? [];
      } else {
        notifications = [];
      }
    } catch (e) {
      print("❌ Notification API Error: $e");
      notifications = [];
    }

    _hideLoader();
    setState(() => isLoading = false);
  }

  // ========================= LOADER ===============================
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
    if (Navigator.canPop(context)) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  // =============================== UI ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColor.secondaryColor,
      drawer: DriverCustomSideBar(),

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: AppColor.primaryColor),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          "Notification",
          style: GoogleFonts.poppins(
            color: AppColor.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ---------------- BODY ----------------
      body: Stack(
        children: [
          // BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(
              "assets/images/splashbackground.png",
              fit: BoxFit.cover,
            ),
          ),

          // DARK OVERLAY
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.45),
            ),
          ),

          // BODY CONTENT
          Padding(
            padding: const EdgeInsets.only(top: 110),
            child: isLoading
                ? const SizedBox() // loader overlay already shown
                : notifications.isEmpty
                ? Center(
              child: Text(
                "No notifications found",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: notificationCard(
                    title: item.message ?? "No message",
                    time: "Just now",            // API has no timestamp
                    profileImage: item.profileImage,
                    firstName: item.firstname,
                    lastName: item.lastname,
                  ),
                );

              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- NOTIFICATION CARD ----------------
  Widget notificationCard({
    required String title,
    required String time,
    required String? profileImage,
    required String? firstName,
    required String? lastName,
  }) {
    final String displayName = [
      if (firstName != null) firstName,
      if (lastName != null) lastName,
    ].join(" ").trim();

    final bool hasImage = profileImage != null && profileImage!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.secondaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 7,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- PROFILE IMAGE ----------------
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white24,
            backgroundImage: hasImage ? NetworkImage(profileImage!) : null,
            child: !hasImage
                ? Icon(
              Icons.person,
              color: Colors.white,
              size: 26,
            )
                : null,
          ),

          const SizedBox(width: 12),

          // ---------------- MESSAGE AREA ----------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // USER NAME
                Text(
                  displayName.isEmpty ? "User" : displayName,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                // MESSAGE TEXT
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColor.primaryColor,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 6),

                // // TIME
                // Text(
                //   time,
                //   style: GoogleFonts.poppins(
                //     fontSize: 10,
                //     color: AppColor.primaryColor.withOpacity(0.7),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
