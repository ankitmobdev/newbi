import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constant.dart';
import 'drawerScreenDriver.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final List<Map<String, String>> notifications = [
    {
      "title": "Your withdrawal request has been accepted by the admin.",
      "time": "9:56 AM"
    },
    {
      "title": "Your order #2456 has been shipped successfully.",
      "time": "8:21 AM"
    },
    {
      "title": "A new message received from support team.",
      "time": "Yesterday"
    }
  ];

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
            icon:  Icon(Icons.menu, color: AppColor.primaryColor),
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
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: notificationCard(
                    title: item["title"]!,
                    time: item["time"]!,
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
  Widget notificationCard({required String title, required String time}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.secondaryColor,
        borderRadius: BorderRadius.circular(12),

        // SHADOW LIKE THE UI
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [

          // TIME
          Text(
            time,textAlign: TextAlign.end,
            style: GoogleFonts.poppins(
              fontSize: 10,fontWeight: FontWeight.w500,
              color: AppColor.primaryColor,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // MESSAGE TEXT
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,fontWeight: FontWeight.w500,
                    color: AppColor.primaryColor,
                    height: 1.4,
                  ),
                ),
              ),


            ],
          ),
        ],
      ),
    );
  }
}
