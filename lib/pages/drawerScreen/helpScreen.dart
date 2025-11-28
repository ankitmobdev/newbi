import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant.dart';
import '../driver/driverDrawerScreen/drawerScreenDriver.dart';
import 'drawerScreen.dart';

class HelpScreen extends StatefulWidget {
  final fromScreen;
  const HelpScreen({super.key,this.fromScreen});

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
  String selectedCountryCode = "IN";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      drawer: widget.fromScreen=="driver"?DriverCustomSideBar():CustomSideBar(),

      // -------------------- APPBAR --------------------
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
          // ---------------- BACKGROUND IMAGE ----------------
          Positioned.fill(
            child: Image.asset(
              "assets/images/splashbackground.png",
              fit: BoxFit.cover,
            ),
          ),

          // ---------------- DARK OVERLAY ----------------
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.45)),
          ),

          // ---------------- CONTENT ----------------
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 100, bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ------- PAGE TITLE BLOCK -------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "We're Happy into hear from you!",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Let us know your queries & feedbacks",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ---------------- FIRST NAME ----------------
                buildInputField(
                  controller: firstName,
                  hint: "Enter Your First Name",
                  icon: "assets/images/user_3_line.svg",
                ),

                const SizedBox(height: 14),

                // ---------------- EMAIL ----------------
                buildInputField(
                  controller: email,
                  hint: "Enter Your Email I'd",
                  icon: "assets/images/mail.svg",
                ),

                const SizedBox(height: 14),

                // ---------------- PHONE FIELD ----------------
                phoneField(),

                const SizedBox(height: 14),

                // ---------------- MESSAGE BOX ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 150,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColor.secondaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: message,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      expands: true,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Your Message",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                 SizedBox(height: MediaQuery.of(context).size.height*0.2),

                // ---------------- SUBMIT BUTTON ----------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      print("Submit: ${firstName.text} / ${email.text} / ${phone.text} / ${message.text}");
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border(
                          top: BorderSide(color: AppColor.secondaryColor, width: 1),
                          left: BorderSide(color: AppColor.secondaryColor, width: 1),
                          right: BorderSide(color: AppColor.secondaryColor, width: 1),
                          bottom: BorderSide(color: AppColor.secondaryColor, width: 6),
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

  // ---------------- INPUT FIELD ----------------
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
            SvgPicture.asset(icon, height: 22, width: 22),
            const SizedBox(width: 14),
            Container(width: 1, height: 28, color: AppColor.textclr),
            const SizedBox(width: 14),

            // INPUT
            Expanded(
              child: TextField(
                controller: controller,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey.shade500,
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
                      color: Colors.black87,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                ],
              ),
            ),

            const SizedBox(width: 10),
            Container(width: 1, height: 28, color: AppColor.textclr),
            const SizedBox(width: 14),

            // PHONE INPUT
            Expanded(
              child: TextField(
                controller: phone,
                keyboardType: TextInputType.phone,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: "Enter Your Number",
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.grey.shade500,
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
