import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constant.dart';
import 'detailScreenDriver.dart';
import 'drawerScreenDriver.dart';

class YourTripsScreen extends StatefulWidget {
  const YourTripsScreen({super.key});

  @override
  State<YourTripsScreen> createState() => _YourTripsScreenState();
}

class _YourTripsScreenState extends State<YourTripsScreen> {
  int selectedTab = 0; // 0 = Current Trips, 1 = History Trips

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DriverCustomSideBar(),
      backgroundColor: AppColor.secondaryColor,

      // -------------------- APPBAR --------------------
      appBar: AppBar(
        backgroundColor:  AppColor.secondaryColor,
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
            color:  AppColor.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),



      body: Stack(
        children: [
          // BACKGROUND IMAGE
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

          // Dark overlay
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

              // -------------------- TRIP CARD --------------------
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  itemCount: 5, // TODO: replace with API list length
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: InkWell(
                        onTap:() {
                          Helper.moveToScreenwithPush(context, DetailsFormDriverScreen(fromScreen: "trip",));
                        } ,
                          child: _tripCard()),
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
          setState(() => selectedTab = index);
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

  // ================= TRIP CARD UI =================
  Widget _tripCard() {
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
          // TOP ROW
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
                    "Car",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,color:AppColor.primaryColor,
                    ),
                  ),
                  Text(
                    "19 November, 2025, 03:45 PM",
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
                      "35, S Tukoganj Rd, Manorama Ganj, Dhar Kothi Colony, Indore, Madhya Pradesh",
                      Colors.green,
                    ),
                    Divider(height: 22, color: Colors.grey.shade300),
                    _locationTile(
                      "Drop-Off",
                      "24 Juni, Juni Indore, Indore, Madhya Pradesh, 452007, India",
                      Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // STATUS BUTTON
          Container(
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Accepted",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // CHAT BUTTON
          Container(
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
        ],
      ),
    );
  }

  // ================= LOCATION ROW =================
  Widget _locationTile(String title, String address, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 13,color: AppColor.textclr,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          address,
          style: GoogleFonts.poppins(
            fontSize: 12,
            height: 1.3,fontWeight: FontWeight.w500,
            color: AppColor.primaryColor,
          ),
        ),
      ],
    );
  }
}
