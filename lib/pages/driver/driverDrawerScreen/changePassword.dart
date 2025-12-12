import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_eat_e_commerce_app/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../SharedPreference/AppSession.dart';
import '../../../services/auth_service.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  // ================= LOADER =================
  void showLoader() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => Center(
        child: Lottie.asset(
          'assets/animation/dots_loader.json',
          repeat: true,
        ),
      ),
    );
  }

  void hideLoader() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // ================= SUBMIT =================
  Future<void> submitChangePassword() async {
    if (_oldPassword.text.isEmpty ||
        _newPassword.text.isEmpty ||
        _confirmPassword.text.isEmpty) {
      _showMessage("All fields are required");
      return;
    }

    if (_newPassword.text != _confirmPassword.text) {
      _showMessage("New password and confirm password do not match");
      return;
    }

    showLoader();

    try {
      final userId = AppSession().userId;

      final response = await AuthService.changePassword(
        userid: userId,
        old_password: _oldPassword.text.trim(),
        new_password: _newPassword.text.trim(),
      );

      hideLoader();

      if (response['result'] == "success") {
        _showMessage(response['message'] ?? "Password changed successfully");
        Navigator.pop(context);
      } else {
        _showMessage(response['message'] ?? "Failed to change password");
      }
    } catch (e) {
      hideLoader();
      _showMessage("Something went wrong. Try again");
      debugPrint("❌ Change Password Error: $e");
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.black87,
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        elevation: 1,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child:
          const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
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
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    buildField(
                      hint: "Enter Old Password",
                      icon: "assets/images/lock.svg",
                      controller: _oldPassword,
                      obscure: true,
                    ),
                    const SizedBox(height: 14),
                    buildField(
                      hint: "Enter New Password",
                      icon: "assets/images/lock.svg",
                      controller: _newPassword,
                      obscure: true,
                    ),
                    const SizedBox(height: 14),
                    buildField(
                      hint: "Enter Confirm Password",
                      icon: "assets/images/lock.svg",
                      controller: _confirmPassword,
                      obscure: true,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: submitChangePassword,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _buildButton("Submit"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= INPUT FIELD =================
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
              style: GoogleFonts.poppins(
                color: AppColor.textclr,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: GoogleFonts.poppins(
                  color: AppColor.textclr.withOpacity(0.7),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ================= BUTTON =================
  Widget _buildButton(String text) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColor.primaryColor,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          top: BorderSide(color: Colors.white, width: 1),
          left: BorderSide(color: Colors.white, width: 1),
          right: BorderSide(color: Colors.white, width: 1),
          bottom: BorderSide(color: Colors.white, width: 6),
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
    );
  }
}
