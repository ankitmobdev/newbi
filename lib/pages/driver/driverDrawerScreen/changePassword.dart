import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_eat_e_commerce_app/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'drawerScreenDriver.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        elevation: 1,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
        ),
        title: Text(
          "Change Password",
          style: GoogleFonts.poppins(
            color: AppColor.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ---------------- BODY WITH FULL SCREEN BG ----------------
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/splashbackground.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              AppColor.primaryColor.withOpacity(0.30),
              BlendMode.darken,
            ),
          ),
        ),

        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Container(
            height: MediaQuery.of(context).size.height/1.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // --------------- Password ----------------
                Column(
                  children: [
                    // PASSWORD
                    buildField(
                      hint: "Enter Old Password",
                      icon: "assets/images/lock.svg",
                      controller: _password,
                      obscure: true,
                    ),
                    const SizedBox(height: 14),

                    buildField(
                      hint: "Enter New Password",
                      icon: "assets/images/lock.svg",
                      controller: _password,
                      obscure: true,
                    ),
                    const SizedBox(height: 14),

                    // CONFIRM PASSWORD
                    buildField(
                      hint: "Enter Confirm Password",
                      icon: "assets/images/lock.svg",
                      controller: _confirmPassword,
                      obscure: true,
                    ),

                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: _buildButton("Submit"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // TEXT FIELD BUILDER
  Widget buildField({
    required String hint,
    required String icon,
    required TextEditingController controller,
    bool obscure = false,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColor.secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          SvgPicture.asset(icon, height: 22, width: 22),
          const SizedBox(width: 14),
          Container(width: 1, height: 26, color: AppColor.textclr),
          const SizedBox(width: 14),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscure,
              style: GoogleFonts.poppins(color: AppColor.textclr, fontSize: 15),
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle:
                GoogleFonts.poppins(color: AppColor.textclr.withOpacity(0.7)),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ---------------- CUSTOM SWITCH ----------------
  Widget customSwitch({
    required bool value,
    required VoidCallback onChanged,
  }) {
    return GestureDetector(
      onTap: onChanged,
      child: AnimatedContainer(
        duration:  Duration(milliseconds: 200),
        height: 22,
        width: 42,
        padding:  EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: value ? Colors.green : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            height: 17,
            width: 17,
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.secondaryColor,
            ),
          ),
        ),
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
