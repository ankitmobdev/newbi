import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../constant.dart';
import 'drawerScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController phone = TextEditingController();

  // Country picker
  String selectedDialCode = "+91";
  String selectedFlag = "🇮🇳";
  String selectedCountryCode = "IN";

  // Phone number rules
  Map<String, int> phoneLength = {
    "IN": 10,
    "US": 10,
    "AE": 9,
    "SA": 9,
    "PK": 10,
  };

  // Error Strings
  String? firstErr, lastErr, emailErr, passErr, phoneErr;

  // profile image
  File? profileImage;

  Future pickImage() async {
    final picker = ImagePicker();

    final XFile? img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() => profileImage = File(img.path));
    }
  }

  // -------- VALIDATION --------
  void validateAndUpdate() {
    setState(() {
      firstErr = lastErr = emailErr = passErr = phoneErr = null;

      if (firstName.text.isEmpty) firstErr = "First name required";
      if (lastName.text.isEmpty) lastErr = "Last name required";

      if (email.text.isEmpty) {
        emailErr = "Email is required";
      } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(email.text)) {
        emailErr = "Enter valid email";
      }

      if (password.text.isEmpty) {
        passErr = "Password required";
      } else if (password.text.length < 6) {
        passErr = "Minimum 6 characters";
      }

      int required = phoneLength[selectedCountryCode] ?? 8;
      if (phone.text.isEmpty) {
        phoneErr = "Phone number required";
      } else if (phone.text.length != required) {
        phoneErr = "Enter $required digits";
      }

      if (firstErr == null &&
          lastErr == null &&
          emailErr == null &&
          passErr == null &&
          phoneErr == null) {
        print("Profile Updated Successfully!");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      drawer: const CustomSideBar(),

      // -------------------- APPBAR --------------------
      appBar: AppBar(
        backgroundColor:AppColor.secondaryColor,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: AppColor.primaryColor),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            color: AppColor.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Stack(
        children: [
          // --------------- FULL-SCREEN IMAGE BACKGROUND ---------------
          Positioned.fill(
            child: Image.asset(
              "assets/images/splashbackground.png",
              fit: BoxFit.cover,
            ),
          ),

          // ---------- DARK OVERLAY ----------
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.45)),
          ),

          // ---------------- CONTENT ----------------
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 140, bottom: 80),
            child: Column(
              children: [
                // ---------------- PROFILE IMAGE ----------------
                GestureDetector(
                  onTap: pickImage,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        backgroundImage: profileImage != null
                            ? FileImage(profileImage!)
                            : const AssetImage("assets/images/profile.png")
                        as ImageProvider,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColor.secondaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Upload Image",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColor.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                buildField(
                    controller: firstName,
                    icon: "assets/images/user_3_line.svg",
                    hint: "Enter Your First Name"),
                showError(firstErr),

                const SizedBox(height: 14),

                buildField(
                    controller: lastName,
                    icon: "assets/images/user_3_line.svg",
                    hint: "Enter Your Last Name"),
                showError(lastErr),

                const SizedBox(height: 14),

                buildField(
                    controller: email,
                    icon: "assets/images/mail.svg",
                    hint: "Enter Your Email Id"),
                showError(emailErr),

                const SizedBox(height: 14),

                buildField(
                  controller: password,
                  icon: "assets/images/lock.svg",
                  hint: "Enter Your Password",
                  obscure: true,
                ),
                showError(passErr),

                const SizedBox(height: 14),

                phoneField(),
                showError(phoneErr),

                const SizedBox(height: 32),

                InkWell(
                    onTap: validateAndUpdate,
                    child: _buildButton("Update")),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ---------------- INPUT FIELD ----------------
  Widget buildField({
    required TextEditingController controller,
    required String icon,
    required String hint,
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
            Container(width: 1, height: 28, color: AppColor.textclr),
            const SizedBox(width: 14),
            Expanded(
              child: TextField(
                controller: controller,
                obscureText: obscure,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: AppColor.textclr,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey.shade400,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Button
  Widget _buildButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColor.primaryColor,
          borderRadius: BorderRadius.circular(12),
          border:  Border(
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

  // ---------------- PHONE FIELD ----------------
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
            const SizedBox(width: 10),

            GestureDetector(
              onTap: () {
                showCountryPicker(
                  context: context,
                  showPhoneCode: true,
                  onSelect: (country) {
                    setState(() {
                      selectedFlag = country.flagEmoji;
                      selectedDialCode = "+${country.phoneCode}";
                      selectedCountryCode = country.countryCode;
                    });
                  },
                );
              },
              child: Row(
                children: [
                  Text(selectedFlag, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 6),
                  Text(
                    selectedDialCode,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: AppColor.textclr,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
                ],
              ),
            ),

            const SizedBox(width: 10),
            Container(width: 1, height: 28, color: AppColor.textclr),
            const SizedBox(width: 14),

            Expanded(
              child: TextField(
                controller: phone,
                keyboardType: TextInputType.phone,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: AppColor.textclr,
                ),
                decoration: InputDecoration(
                  hintText: "Enter Your Number",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey.shade400,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- ERROR MESSAGE ----------------
  Widget showError(String? err) {
    if (err == null) return const SizedBox(height: 0);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 0, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          err,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}
