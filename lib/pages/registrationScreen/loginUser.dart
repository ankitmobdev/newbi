import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_eat_e_commerce_app/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../SharedPreference/AppSession.dart';
import '../../models/usermodel.dart';
import '../../services/api_client.dart';
import '../../services/api_constants.dart';
import '../driver/driverHomeScreen/driverHomeScreen.dart';
import '../driver/registration/signupDriver.dart';
import '../homeScreen/homeScreen.dart';
import '../registrationScreen/signupScreenUser.dart';

class LoginUser extends StatefulWidget {
  final String? loginas;
  const LoginUser({super.key, this.loginas});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initFCM();
  }
  Future<void> _initFCM() async {
    try {
      // ✅ Request notification permission
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // ✅ Get device token
      await getDeviceTokenToSendNotification();
    } catch (e) {
      debugPrint("❌ FCM init error: $e");
    }
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  Future<void> getDeviceTokenToSendNotification() async {
    try {
      final FirebaseMessaging fcm = FirebaseMessaging.instance;
      final token = await fcm.getToken();

      if (token != null && token.isNotEmpty) {
        AppSession().deviceToken = token;

        debugPrint("✅ DEVICE TOKEN SAVED: $token");
      }
    } catch (e) {
      debugPrint("❌ FCM TOKEN ERROR: $e");
    }
  }


  // ----------------------------------------------------------------------
  // LOGIN API (FINAL & CORRECT)
  // ----------------------------------------------------------------------
  Future<Map<String, dynamic>> loginAPI({
    required String email,
    required String password,
    required String deviceToken,
    required String deviceType,
    required String userType,
  }) async {
    final formData = FormData.fromMap({
      'code': ApiCode.kcode,
      'email': email,
      'password': password,
      'device_token': deviceToken,
      'user_type': userType,
      'device_type': deviceType,
    });

    print("📤 Login Request → $formData");

    final response = await ApiClient.dio.post(ApiAction.login, data: formData);

    print("📥 Login Raw Response → ${response.data}");

    if (response.data is Map<String, dynamic>) {
      return response.data;
    } else if (response.data is String) {
      return jsonDecode(response.data);
    }

    throw Exception("Unexpected response format");
  }

  // ----------------------------------------------------------------------
  // VALIDATE + LOGIN API CALL
  // ----------------------------------------------------------------------
  Future<void> _validateAndLogin() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    // EMAIL VALIDATION
    if (_emailController.text.isEmpty) {
      setState(() => _emailError = "Email is required");
      return;
    }

    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(_emailController.text)) {
      setState(() => _emailError = "Enter a valid email");
      return;
    }

    // PASSWORD VALIDATION
    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = "Password is required");
      return;
    }

    // -------- PRINT REQUEST BEFORE API --------
    print("📤 LOGIN REQUEST");
    print("Email: ${_emailController.text.trim()}");
    print("Password: ${_passwordController.text.trim()}");
    print("Device Token: 123456");
    print("Device Type: android");
    print("User Type: ${widget.loginas == "driver" ? "2" : "1"}");

    print("➡️ FINAL REQUEST MAP: ${{
      "email": _emailController.text.trim(),
      "password": _passwordController.text.trim(),
      "device_token": AppSession().deviceToken,
      "device_type": Platform.isIOS ? "ios" : "android",
      "user_type": widget.loginas == "driver" ? "2" : "1",
    }}");

    _showLoader();

    try {
      final response = await loginAPI(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        deviceToken: AppSession().deviceToken,
        deviceType: Platform.isIOS ? "ios" : "android", // ✅ FIXED
        userType: widget.loginas == "driver" ? "2" : "1",
      );


      Navigator.pop(context); // close loader

      // -------- FIXED: JSON HANDLING --------
      final jsonMap = response is String ? jsonDecode(response.toString()) : response;

      final model = LoginModel.fromJson(jsonMap);

      if (model.result == "success" && model.data != null) {
        await AppSession().saveUser(model);

        _printAppSessionData();   // ← PRINT ALL SAVED SESSION VALUES

        if (widget.loginas == "driver") {
          Helper.moveToScreenwithPush(context, DriverHomeScreen());
        } else {
          Helper.moveToScreenwithPush(context, HomeScreen());
        }
      }
      else {
        _showError(model.message ?? "Login failed");
      }
    } catch (e) {
      Navigator.pop(context);
      print("❌ Login Error: $e");
      _showError("Something went wrong");
    }
  }

  void _printAppSessionData() {
    final session = AppSession();

    print("======================================");
    print("🟦 APP SESSION STORED DATA");
    print("======================================");
    print("User ID:          ${session.userId}");
    print("Email:            ${session.email}");
    print("First Name:       ${session.firstname}");
    print("Last Name:        ${session.lastname}");
    print("Phone:            ${session.phone}");
    print("User Type:        ${session.userType}");
    print("Vehicle Type:     ${session.vehicleType}");
    print("Profile Image:    ${session.profileImage}");
    print("Latitude:         ${session.lat}");
    print("Longitude:        ${session.long}");
    print("Country Code:     ${session.countryCode}");
    print("Phone Code:       ${session.phoneCode}");
    print("Licence Front:    ${session.licenceFront}");
    print("Licence Back:     ${session.licenceBack}");
    print("Vehicle Reg:      ${session.vehicleReg}");
    print("Licence Plate:    ${session.licencePlate}");
    print("Social Type:      ${session.socialType}");
    print("Social ID:        ${session.socialId}");
    print("Email Check:      ${session.emailCheck}");
    print("Notification:     ${session.notification}");
    print("With Helper:      ${session.withHelper}");
    print("Aide Name:        ${session.aideName}");
    print("Aide Email:       ${session.aideEmail}");
    print("Aide Phone:       ${session.aidePhone}");
    print("Aide Profile:     ${session.aideProfile}");
    print("Aide Phone Code:  ${session.aidePhoneCode}");
    print("Help Aide Status: ${session.helpAideStatus}");
    print("Is Logged In:     ${session.isLoggedIn}");
    print("======================================");
  }



  // ----------------------------------------------------------------------
  void _showLoader() {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) => Center(
        child: Lottie.asset(
          'assets/animation/dots_loader.json',
          repeat: true,
          fit: BoxFit.contain,
        ),
      ),
    );
  }



  // ----------------------------------------------------------------------
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  // ----------------------------------------------------------------------
  // UI
  // ----------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/splashbackground.png", fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.45)),
          ),

          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                const Spacer(),

                Center(
                  child: Image.asset(
                    'assets/images/unnamed 1copy 1.png',
                    height: 110,
                    width: 110,
                  ),
                ),

                const SizedBox(height: 40),

                // Email
                _buildInputField(
                  hint: "Enter Your Email I'd",
                  icon: "assets/images/mail.svg",
                  controller: _emailController,
                ),
                if (_emailError != null) _errorText(_emailError!),

                const SizedBox(height: 16),

                // Password
                _buildInputField(
                  hint: "Enter Your Password",
                  icon: "assets/images/lock.svg",
                  controller: _passwordController,
                  obscureText: true,
                ),
                if (_passwordError != null) _errorText(_passwordError!),

                const SizedBox(height: 10),

                // Forgot Password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot your password?",
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),

                const Spacer(),

                GestureDetector(

                  onTap:
                  // () {
                  //   Helper.moveToScreenwithPush(context, HomeScreen());
                  // },
                   _validateAndLogin,
                  child: _buildButton("Login"),
                ),

                const SizedBox(height: 16),

                InkWell(
                  onTap: () {
                    widget.loginas == "driver"
                        ? Helper.moveToScreenwithPush(context, DriverSignupScreen())
                        : Helper.moveToScreenwithPush(context, SignupUser());
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                      children: [
                        TextSpan(
                          text: "Sign Up",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------
  Widget _buildInputField({
    required String hint,
    required String icon,
    required TextEditingController controller,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
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
                obscureText: obscureText,
                style: GoogleFonts.poppins(color: AppColor.textclr, fontSize: 15),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: GoogleFonts.poppins(color: AppColor.textclr),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  Widget _errorText(String error) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          error,
          style: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 12),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------
  Widget _buildButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColor.primaryColor,
          borderRadius: BorderRadius.circular(10),
          border: Border(
            top: BorderSide(color: AppColor.secondaryColor, width: 1),
            left: BorderSide(color: AppColor.secondaryColor, width: 1),
            right: BorderSide(color: AppColor.secondaryColor, width: 1),
            bottom: BorderSide(color: AppColor.secondaryColor, width: 6),
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
