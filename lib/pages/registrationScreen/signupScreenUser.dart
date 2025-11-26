import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant.dart';
import 'loginUser.dart';

class SignupUser extends StatefulWidget {
  const SignupUser({super.key});

  @override
  State<SignupUser> createState() => _SignupUserState();
}

class _SignupUserState extends State<SignupUser> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  // Country variables
  String selectedCountryCode = "IN"; // ISO
  String selectedDialCode = "+91"; // Dial
  String selectedFlag = "🇮🇳";

  // Phone length rule per country (you may add more)
  Map<String, int> phoneLength = {
    "IN": 10,
    "US": 10,
    "AE": 9,
    "SA": 9,
    "PK": 10,
    "CH": 9,
  };

  String? firstErr, lastErr, emailErr, passErr, phoneErr;

  void validateAndSignup() {
    setState(() {
      firstErr = lastErr = emailErr = passErr = phoneErr = null;

      if (_firstName.text.isEmpty) firstErr = "First name required";
      if (_lastName.text.isEmpty) lastErr = "Last name required";

      if (_email.text.isEmpty) {
        emailErr = "Email is required";
      } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(_email.text)) {
        emailErr = "Enter a valid email";
      }

      if (_password.text.isEmpty) {
        passErr = "Password is required";
      } else if (_password.text.length < 6) {
        passErr = "Min 6 characters";
      }

      int requiredLength = phoneLength[selectedCountryCode] ?? 8;

      if (_phone.text.isEmpty) {
        phoneErr = "Phone number required";
      } else if (_phone.text.length != requiredLength) {
        phoneErr =
        "Enter valid number ($requiredLength digits for $selectedDialCode)";
      }

      if (firstErr == null &&
          lastErr == null &&
          emailErr == null &&
          passErr == null &&
          phoneErr == null) {
        final fullPhone = "$selectedDialCode${_phone.text}";
        print("Signup Successful");
        print("Full Number → $fullPhone");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child:Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset(
              "assets/images/back.svg",height: 42,width: 42,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          "Sign Up",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,   // important for overlay background
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/splashbackground.png",
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.45)),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  Center(
                    child: Image.asset(
                      'assets/images/unnamed 1copy 1.png',
                      height: 110,
                      width: 110,
                    ),
                  ),

                  const SizedBox(height: 40),

                  buildField(
                    hint: "Enter Your First Name",
                    icon: "assets/images/user_3_line.svg",
                    controller: _firstName,
                  ),
                  showError(firstErr),

                  const SizedBox(height: 14),

                  buildField(
                    hint: "Enter Your Last Name",
                    icon: "assets/images/user_3_line.svg",
                    controller: _lastName,
                  ),
                  showError(lastErr),

                  const SizedBox(height: 14),

                  buildField(
                    hint: "Enter Your Email I'd",
                    icon: "assets/images/mail.svg",
                    controller: _email,
                  ),
                  showError(emailErr),

                  const SizedBox(height: 14),

                  buildField(
                    hint: "Enter Your Password",
                    icon: "assets/images/lock.svg",
                    controller: _password,
                    obscure: true,
                  ),
                  showError(passErr),

                  const SizedBox(height: 14),

                  phoneField(),
                  showError(phoneErr),

                  const SizedBox(height: 40),

                  GestureDetector(
                    onTap: validateAndSignup,
                    child: buildButton("Sign Up"),
                  ),

                  const SizedBox(height: 20),

                  InkWell(
                    onTap: () {
                      Helper.moveToScreenwithPush(context, LoginUser(loginas: 'user',));
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "I have already an account? ",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: "Login",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // ===============================
  // GENERAL INPUT FIELD
  // ===============================
  Widget buildField({
    required String hint,
    required String icon,
    required TextEditingController controller,
    bool obscure = false,
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
                obscureText: obscure,
                style: GoogleFonts.poppins(
                  color: AppColor.textclr,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================
  // CUSTOM PHONE FIELD
  // ===============================
  Widget phoneField() {
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
            const SizedBox(width: 12),

            // Country Picker Button
            GestureDetector(
              onTap: () {
                showCountryPicker(
                  context: context,
                  showPhoneCode: true,
                  onSelect: (Country country) {
                    setState(() {
                      selectedCountryCode = country.countryCode;
                      selectedDialCode = "+${country.phoneCode}";
                      selectedFlag = country.flagEmoji;
                    });
                  },
                );
              },
              child: Row(
                children: [
                  Text(
                    selectedFlag,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    selectedDialCode,
                    style: GoogleFonts.poppins(
                      color: AppColor.textclr,
                      fontSize: 15,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Container(width: 1, height: 26, color: AppColor.textclr),

            const SizedBox(width: 14),

            Expanded(
              child: TextField(
                controller: _phone,
                keyboardType: TextInputType.number,
                style: GoogleFonts.poppins(
                  color: AppColor.textclr,
                  fontSize: 15,
                ),
                decoration: const InputDecoration(
                  hintText: "Enter Your Number",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================
  // ERROR TEXT (LEFT ALIGN)
  // ===============================
  Widget showError(String? err) {
    if (err == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 0, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          err,
          style: GoogleFonts.poppins(
            color: Colors.redAccent,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // ===============================
  // BUTTON
  // ===============================
  Widget buildButton(String text) {
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
              color: AppColor.secondaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
