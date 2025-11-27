import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constant.dart';
import 'detailScreenDriver.dart';
import 'drawerScreenDriver.dart';


class AvailableDeliveriesScreen extends StatelessWidget {
  AvailableDeliveriesScreen({super.key});

  final List<Map<String, dynamic>> serviceList = [
    {
      "vehicle": "Car",
      "date": "19 November, 2025, 03:45 PM",
      "pickup":
      "35, S Tukoganj Rd, Manorama Ganj, Dhar Kothi Colony, Indore, Madhya Pradesh",
      "drop":
      "24 Juni, Juni Indore, Indore, Madhya Pradesh, 452007, India",
      "highlight": true
    },
    {
      "vehicle": "Cargo Van",
      "date": "19 November, 2025, 03:26 PM",
      "pickup":
      "35, S Tukoganj Rd, Manorama Ganj, Dhar Kothi Colony, Indore, Madhya Pradesh",
      "drop":
      "24 Juni, Juni Indore, Indore, Madhya Pradesh, 452007, India",
      "highlight": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      // ------------------ APP BAR ------------------


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
          "Available Deliveries",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ------------------ BODY ------------------
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
                    const Color(0xFF040719).withOpacity(0.5),
                    AppColor.primaryColor.withOpacity(0.75),
                  ],
                ),
              ),
            ),
          ),

          // ------------------ LIST VIEW ------------------
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 30),
            itemCount: serviceList.length,
            itemBuilder: (context, index) {
              final item = serviceList[index];

              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      Helper.moveToScreenwithPush(context, DetailsFormDriverScreen());
                    },
                    child: _deliveryCard(
                      vehicle: item["vehicle"],
                      date: item["date"],
                      pickup: item["pickup"],
                      drop: item["drop"],
                      highlight: item["highlight"],
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

  // ---------------------------------------------------------------------
  //                        DELIVERY CARD UI
  // ---------------------------------------------------------------------
  Widget _deliveryCard({
    required String vehicle,
    required String date,
    required String pickup,
    required String drop,
    required bool highlight,
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
          // ------------------ TOP ROW ------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // BLACK ICON CIRCLE
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

                  // TEXT
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
              // PICKUP–DROP VERTICAL IMAGE
              Image.asset(
                "assets/images/pickupDropup.png",
                height: 110,
                width: 20,
              ),

              const SizedBox(width: 14),

              // PICKUP + DROP
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _locationTile(
                      title: "Pickup",
                      address: pickup,
                      color: Colors.green,
                    ),
                    Divider(thickness: 1, color: Colors.grey.shade300),
                    _locationTile(
                      title: "Drop-Off",
                      address: drop,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ------------------ ACCEPT / DECLINE BUTTONS ------------------
          Row(
            children: [
              Expanded(
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
              const SizedBox(width: 12),
              Expanded(
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
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  //                        PICKUP / DROP TILE
  // ---------------------------------------------------------------------
  Widget _locationTile({
    required String title,
    required String address,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // COLORED DOT


        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                    fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                address,
                style: GoogleFonts.poppins(
                    fontSize: 12.5, height: 1.3, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
