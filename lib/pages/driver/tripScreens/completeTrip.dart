import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_eat_e_commerce_app/constant.dart';
import 'package:google_fonts/google_fonts.dart';

class CompleteTripScreen extends StatefulWidget {
  const CompleteTripScreen({super.key});

  @override
  State<CompleteTripScreen> createState() => _CompleteTripScreenState();
}

class _CompleteTripScreenState extends State<CompleteTripScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ----------------- APP BAR -----------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
        title: Text(
          "Complete Trip",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColor.primaryColor,
          ),
        ),
      ),

      // ----------------- BODY -----------------
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/splashbackground.png",
              fit: BoxFit.cover,
            ),
          ),

          // White overlay
          Positioned.fill(
            child: Container(
              color:  AppColor.primaryColor.withOpacity(0.50),
            ),
          ),

          // Main Content
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 6),

                // ----------------- PROFILE IMAGE -----------------
                CircleAvatar(
                  radius: 38,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage("assets/images/user.png"),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Urvashti J.",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColor.secondaryColor,
                  ),
                ),

                const SizedBox(height: 18),

                // ----------------- UPLOAD IMAGE BOX -----------------
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColor.borderColor),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/images/photo_album_2_fill.svg",
                          height: 40,
                          width: 40,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Upload Parcel Image at Destination",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColor.textclr,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Divider(
                  color: AppColor.secondaryColor ,thickness: 2,
                ),
                const SizedBox(height: 24),
                // ----------------- SIGNATURE TITLE ROW -----------------

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Digital Signature",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                         color:  AppColor.secondaryColor
                      ),
                    ),
                    Text(
                      "Clear",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                          color:  AppColor.secondaryColor
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // ----------------- SIGNATURE BOX -----------------
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.secondaryColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color:AppColor.borderColor),
                  ),
                ),

                const SizedBox(height: 30),

                // ----------------- DELIVERED BUTTON -----------------
                SizedBox(height: MediaQuery.of(context).size.height*0.06),
                _buildButton("Delivered"),
                SizedBox(height: MediaQuery.of(context).size.height*0.05),

              ],
            ),
          ),
        ],
      ),
    );
  }

  // Reusable Button
  Widget _buildButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColor.primaryColor, // dark background
          borderRadius: BorderRadius.circular(12),

          // Only bottom border
          border: Border(
            top: const BorderSide(
              color: Colors.white,
              width: 1,
            ),
            left: const BorderSide(
              color: Colors.white,
              width: 1,
            ),
            right: const BorderSide(
              color: Colors.white,
              width: 1,
            ),
            bottom: const BorderSide(
              color: Colors.white,
              width: 6,  // thicker bottom border
            ),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColor.secondaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
