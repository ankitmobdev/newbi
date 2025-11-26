import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_eat_e_commerce_app/pages/registrationScreen/loginUser.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constant.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/splashbackground.png',
              fit: BoxFit.cover,
            ),
          ),

          // Dark overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.45),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const Spacer(),
                // Center Logo

                const Spacer(),
                Image.asset(
                  'assets/images/unnamed 1copy 1.png',
                  height: 110,
                  width: 110,
                ),

                const Spacer(),

                // Login as User Button
                InkWell(
                  onTap: () {
                    Helper.moveToScreenwithPush(context, LoginUser());
                  },
                    child: _buildButton("Login as User")),

                const SizedBox(height: 16),

                // Login as Driver Button
                _buildButton("Login as Driver"),

                const SizedBox(height: 50),
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
      padding: const EdgeInsets.symmetric(horizontal: 40),
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
