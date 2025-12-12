import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../constant.dart';
import '../../services/auth_service.dart';
import '../driver/driverDrawerScreen/drawerScreenDriver.dart';
import 'drawerScreen.dart';

class HelpScreen extends StatefulWidget {
  final fromScreen;
  const HelpScreen({super.key, this.fromScreen});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController message = TextEditingController();

  // Country picker
  String selectedDialCode = "+91";
  String selectedFlag = "🇮🇳";

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

  // ================= SUBMIT HELP =================
  Future<void> submitHelp() async {
    if (firstName.text.isEmpty ||
        email.text.isEmpty ||
        phone.text.isEmpty ||
        message.text.isEmpty) {
      _showMessage("All fields are required");
      return;
    }

    final fullPhone = "$selectedDialCode${phone.text.trim()}";

    // ✅ PRINT REQUEST DATA
    debugPrint("📤 needHelp REQUEST:");
    debugPrint("Name    : ${firstName.text.trim()}");
    debugPrint("Email   : ${email.text.trim()}");
    debugPrint("Phone   : $fullPhone");
    debugPrint("Message : ${message.text.trim()}");

    showLoader();

    try {
      final response = await AuthService.needHelp(
        name: firstName.text.trim(),
        email: email.text.trim(),
        phone: fullPhone,
        message: message.text.trim(),
      );

      hideLoader();

      debugPrint("📥 needHelp RESPONSE: $response");

      if (response['result'] == "success") {
        _showMessage(response['message'] ?? "Request submitted successfully");
        firstName.clear();
        email.clear();
        phone.clear();
        message.clear();
      } else {
        _showMessage(response['message'] ?? "Failed to submit request");
      }
    } catch (e, st) {
      hideLoader();
      debugPrint("❌ needHelp ERROR: $e");
      debugPrint("❌ STACKTRACE: $st");
      _showMessage("Something went wrong. Please try again");
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
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      drawer: widget.fromScreen == "driver"
          ? DriverCustomSideBar()
          : CustomSideBar(),
      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: AppColor.primaryColor),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          "Help",
          style: GoogleFonts.poppins(
            color: AppColor.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
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
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 100, bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "We're Happy to hear from you!",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Let us know your queries & feedback",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                buildInputField(
                  controller: firstName,
                  hint: "Enter Your First Name",
                  icon: "assets/images/user_3_line.svg",
                ),
                const SizedBox(height: 14),

                buildInputField(
                  controller: email,
                  hint: "Enter Your Email Id",
                  icon: "assets/images/mail.svg",
                ),
                const SizedBox(height: 14),

                phoneField(),
                const SizedBox(height: 14),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 150,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColor.secondaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: message,
                      maxLines: null,
                      expands: true,
                      style: GoogleFonts.poppins(fontSize: 15),
                      decoration: const InputDecoration(
                        hintText: "Your Message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * 0.2),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: submitHelp,
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border(
                          top: BorderSide(color: AppColor.secondaryColor, width: 1),
                          left: BorderSide(color: AppColor.secondaryColor, width: 1),
                          right: BorderSide(color: AppColor.secondaryColor, width: 1),
                          bottom:
                          BorderSide(color: AppColor.secondaryColor, width: 6),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Submit Now",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppColor.secondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= INPUT FIELD =================
  Widget buildInputField({
    required TextEditingController controller,
    required String icon,
    required String hint,
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
            SvgPicture.asset(icon, height: 22),
            const SizedBox(width: 14),
            Container(width: 1, height: 28, color: AppColor.textclr),
            const SizedBox(width: 14),
            Expanded(
              child: TextField(
                controller: controller,
                style: GoogleFonts.poppins(fontSize: 15),
                decoration:
                InputDecoration(hintText: hint, border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= PHONE FIELD =================
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
                    });
                  },
                );
              },
              child: Row(
                children: [
                  Text(selectedFlag, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 6),
                  Text(selectedDialCode,
                      style: GoogleFonts.poppins(fontSize: 15)),
                  const Icon(Icons.keyboard_arrow_down),
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
                  fontSize: 16,
                  color: AppColor.primaryColor, // text color while typing
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: "Enter Your Number",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black, // hint color
                    fontWeight: FontWeight.w400,
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
}
