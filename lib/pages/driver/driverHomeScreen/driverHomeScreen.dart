import 'package:flutter/material.dart';
import 'package:go_eat_e_commerce_app/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../driverDrawerScreen/drawerScreenDriver.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  GoogleMapController? mapController;

  LatLng driverLocation = const LatLng(22.717807, 75.8780294);
  bool isOnline = true;

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
          "Home",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: customOnlineSwitch()),
          ),
        ],
      ),

      body: Stack(
        children: [
          // ================== GOOGLE MAP ==================
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: driverLocation,
              zoom: 14,
            ),
            mapType: MapType.normal,
            onMapCreated: (controller) => mapController = controller,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
          ),



          // ================== MAP PIN ICON (CENTER) ==================
           Center(
            child:Image.asset( "assets/images/mapIcon.png",)
          ),

          // ================== BOTTOM NEARBY DELIVERIES BUTTON ==================
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () {

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Nearby Deliveries",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColor.secondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget customOnlineSwitch() {
    return GestureDetector(
      onTap: () => setState(() => isOnline = !isOnline),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 22,
        width: 42,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isOnline ? Colors.green : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Align(
          alignment: isOnline ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            height: 17,
            width: 17,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

}
