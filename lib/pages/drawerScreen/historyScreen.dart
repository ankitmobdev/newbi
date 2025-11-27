import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant.dart';
import 'currentServiceDetailScreen.dart';
import 'drawerScreen.dart';

class HistoryServiceScreen extends StatelessWidget {
  HistoryServiceScreen({super.key});

  // ---------------- SAMPLE DATA (FROM API) ----------------
  final List<Map<String, dynamic>> serviceList = [
    {
      "vehicle": "Car",
      "date": "19 November, 2025, 07:15 PM",
      "pickup":
      "35, S Tukoganj Rd, Manorama Ganj, Dhar Kothi Colony, Indore, Madhya Pradesh",
      "drop":
      "24 Juni, Juni Indore, Indore, Madhya Pradesh, 452007, India",
      "status": "waiting"
    },
    {
      "vehicle": "Cargo Van",
      "date": "19 November, 2025, 03:26 PM",
      "pickup":
      "35, S Tukoganj Rd, Manorama Ganj, Dhar Kothi Colony, Indore, Madhya Pradesh",
      "drop":
      "24 Juni, Juni Indore, Indore, Madhya Pradesh, 452007, India",
      "status": "waiting"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomSideBar(),
      backgroundColor: const Color(0xffF4F4F4),

      // -------------------- APPBAR --------------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon:  Icon(Icons.menu, color:  AppColor.primaryColor),
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
                    Color(0xff04071980).withOpacity(0.50),
                    AppColor.primaryColor.withOpacity(0.77),
                  ],
                ),
              ),
            ),
          ),

          // ---------------- LISTVIEW BUILDER ----------------
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
            itemCount: serviceList.length,
            itemBuilder: (context, index) {
              final item = serviceList[index];

              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      Helper.moveToScreenwithPush(context, DetailsFormScreen());
                    },
                    child: _serviceCard(
                      vehicle: item["vehicle"],
                      date: item["date"],
                      pickup: item["pickup"],
                      drop: item["drop"],
                      status: item["status"],
                    ),
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

  // ====================== SERVICE CARD ======================
  Widget _serviceCard({
    required String vehicle,
    required String date,
    required String pickup,
    required String drop,
    required String status,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.secondaryColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:  AppColor.primaryColor.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
                        vehicle,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.primaryColor,
                        ),
                      ),
                      Text(
                        date,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),


              const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.black54),
            ],
          ),




          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PICKUP → DROP VERTICAL IMAGE
              Image.asset(
                "assets/images/pickupDropup.png",
                height: 120,          // adjust to match design height
                width: 22,
                fit: BoxFit.contain,
              ),

              const SizedBox(width: 14),

              // PICKUP & DROPOFF BLOCKS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _locationTile("Pickup", pickup),
                    Divider(
                      thickness: 1,
                      color: Colors.grey.shade300,
                    ),

                    _locationTile("Drop-Off", drop),
                  ],
                ),
              ),
            ],
          ),




          const SizedBox(height: 16),

         _waitingButton(),

        ],
      ),
    );
  }

  // ====================== LOCATION BLOCK ======================
  Widget _locationTile(String title, String address) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // DOT


        // TEXT BLOCK
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                address,
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  // ====================== BUTTONS ======================
  Widget _waitingButton() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: AppColor.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          "Completed",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColor.green,
          ),
        ),
      ),
    );
  }




}
