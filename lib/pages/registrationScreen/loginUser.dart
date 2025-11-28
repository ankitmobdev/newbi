import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_eat_e_commerce_app/pages/registrationScreen/signupScreenUser.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant.dart';
import '../driver/driverHomeScreen/driverHomeScreen.dart';
import '../driver/registration/signupDriver.dart';
import '../homeScreen/homeScreen.dart';

class LoginUser extends StatefulWidget {
  final loginas;
  const LoginUser({super.key,this.loginas});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateAndLogin() {
    setState(() {
      _emailError = null;
      _passwordError = null;

      if (_emailController.text.isEmpty) {
        _emailError = "Email is required";
      } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(_emailController.text)) {
        _emailError = "Enter a valid email";
      }

      if (_passwordController.text.isEmpty) {
        _passwordError = "Password is required";
      } else if (_passwordController.text.length < 6) {
        _passwordError = "Password must be at least 6 characters";
      }

      if (_emailError == null && _passwordError == null) {
        Helper.moveToScreenwithPush(context, HomeScreen());
        // Both valid, perform login
        print("Email: ${_emailController.text}");
        print("Password: ${_passwordController.text}");
      }
    });
  }

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

          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                const Spacer(),

                // LOGO centered
                Center(
                  child: Image.asset(
                    'assets/images/unnamed 1copy 1.png',
                    height: 110,
                    width: 110,
                  ),
                ),

                const SizedBox(height: 40),

                // EMAIL INPUT
                _buildInputField(
                  hint: "Enter Your Email I'd",
                  icon: "assets/images/mail.svg",
                  controller: _emailController,
                ),
                if (_emailError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _emailError!,
                        style: GoogleFonts.poppins(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // PASSWORD INPUT
                _buildInputField(
                  hint: "Enter Your Password",
                  icon: "assets/images/lock.svg",
                  controller: _passwordController,
                  obscureText: true,
                ),
                if (_passwordError != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _passwordError!,
                        style: GoogleFonts.poppins(
                          color: Colors.redAccent,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 10),

                // Forgot Password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot your password?",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // LOGIN BUTTON
                GestureDetector(
                  onTap: () {
                    widget.loginas=="driver"?
                    Helper.moveToScreenwithPush(context, DriverHomeScreen()):
                    Helper.moveToScreenwithPush(context, HomeScreen());
                  },

                  // _validateAndLogin,
                  child: _buildButton("Login"),
                ),

                const SizedBox(height: 16),

                // Bottom Text
                InkWell(
                  onTap: () {
                    widget.loginas=="driver"?
                    Helper.moveToScreenwithPush(context, DriverSignupScreen()):
                    Helper.moveToScreenwithPush(context, SignupUser());
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                      ),
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

  // 🔹 INPUT FIELD
  Widget _buildInputField({
    required String hint,
    required String icon,
    TextEditingController? controller,
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

            // ICON
            SvgPicture.asset(
              icon,
              height: 22,
              width: 22,
            ),

            const SizedBox(width: 14),

            // VERTICAL DIVIDER
            Container(
              width: 1,
              height: 26,
              color: AppColor.textclr,
            ),

            const SizedBox(width: 14),

            // TEXT FIELD
            Expanded(
              child: TextFormField(
                controller: controller,
                obscureText: obscureText,
                cursorColor: Colors.blue,
                style: GoogleFonts.poppins(
                  color: AppColor.textclr,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: GoogleFonts.poppins(
                    color: AppColor.textclr,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 BUTTON
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
