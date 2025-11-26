import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant.dart';
import 'dateTimeScreen.dart';

class AideDriverScreen extends StatefulWidget {
  const AideDriverScreen({super.key});

  @override
  State<AideDriverScreen> createState() => _AideDriverScreenState();
}

class _AideDriverScreenState extends State<AideDriverScreen> {
  String selectedAide = "";
  String selectedVehicle = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,

      // ---------------------- APP BAR ----------------------
      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child:  Icon(Icons.arrow_back_ios, size: 20, color: AppColor.primaryColor),
        ),
        title: Text(
          "Aide and Driver",
          style: GoogleFonts.poppins(
            color: AppColor.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ---------------------- BODY ----------------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle(""),

            // ------ DRIVER OPTIONS ------
            _driverCard(
              icon: "assets/images/justdriver.png",
              title: "Just Driver",
              desc:
              "If items in your projects requires 2 people to lift safely and you are unable to provide help, please select driver + aide",
              value: "driver",
            ),
            const SizedBox(height: 14),

            _driverCard(
              icon: "assets/images/aidedriver.png",
              title: "Driver + Aide",
              desc:
              "If items in your projects requires 2 people to lift safely and you are unable to provide help, please select driver + aide",
              value: "driver_aide",
            ),

            const SizedBox(height: 20),

            // ------ SECTION TITLE ------
            _sectionTitle("Select Vehicle"),

            // ------ VEHICLE CARDS ------
            _vehicleCard(
              icon: "assets/images/carpackers.png",
              title: "Car",
              desc:
              "If items in your projects requires 2 people to lift safely and you are unable to provide help, please select driver + aide",
              value: "car",
            ),
            const SizedBox(height: 14),

            _vehicleCard(
              icon: "assets/images/minivan.png",
              title: "Mini Van",
              desc:
              "If items in your projects requires 2 people to lift safely and you are unable to provide help, please select driver + aide",
              value: "minivan",
            ),
            const SizedBox(height: 14),

            _vehicleCard(
              icon: "assets/images/cargo.png",
              title: "Cargo Van",
              desc:
              "If items in your projects requires 2 people to lift safely and you are unable to provide help, please select driver + aide",
              value: "cargo",
            ),
            const SizedBox(height: 14),

            _vehicleCard(
              icon: "assets/images/pickuptruck.png",
              title: "Pickup Truck",
              desc:
              "If items in your projects requires 2 people to lift safely and you are unable to provide help, please select driver + aide",
              value: "pickup",
            ),
            const SizedBox(height: 14),

            _vehicleCard(
              icon: "assets/images/boxtruck.png",
              title: "Box Truck",
              desc:
              "If items in your projects requires 2 people to lift safely and you are unable to provide help, please select driver + aide",
              value: "box",
            ),

            const SizedBox(height: 30),

            // ------ NEXT BUTTON ------
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Helper.moveToScreenwithPush(context, DateTimeScreen());
                },
                child: Text(
                  "Next",
                  style: GoogleFonts.poppins(
                    color: AppColor.secondaryColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // SECTION TITLE
  // =========================================================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColor.primaryColor,
        ),
      ),
    );
  }

  // =========================================================
  // DRIVER SELECTION CARD
  // =========================================================
  Widget _driverCard({
    required String icon,
    required String title,
    required String desc,
    required String value,
  }) {
    return GestureDetector(
      onTap: () => setState(() => selectedAide = value),
      child: _selectionCard(
        icon: icon,
        title: title,
        desc: desc,
        selected: selectedAide == value,
      ),
    );
  }

  // =========================================================
  // VEHICLE SELECTION CARD
  // =========================================================
  Widget _vehicleCard({
    required String icon,
    required String title,
    required String desc,
    required String value,
  }) {
    return GestureDetector(
      onTap: () => setState(() => selectedVehicle = value),
      child: _selectionCard(
        icon: icon,
        title: title,
        desc: desc,
        selected: selectedVehicle == value,
      ),
    );
  }

  // =========================================================
  // REUSABLE CARD UI
  // =========================================================

  Widget _customRadio(bool isSelected) {
    return Container(
      height: 22,
      width: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColor.radiobutton,
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
        child: Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: AppColor.radiobutton,
            shape: BoxShape.circle,
          ),
        ),
      )
          : null,
    );
  }

  Widget _selectionCard({
    required String icon,
    required String title,
    required String desc,
    required bool selected,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColor.radiobutton,
          width: selected ? 1.6 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // left black icon box
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Image.asset(
                icon,
                height: 26,
                width: 26,
                color: AppColor.secondaryColor,
              ),
            ),
          ),

          const SizedBox(width: 14),

          // Title & Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    color: Colors.black54,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),

          // Radio
          _customRadio(selected)

        ],
      ),
    );
  }
}
