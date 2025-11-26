import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant.dart';

class DetailsFormScreen extends StatefulWidget {
  const DetailsFormScreen({super.key});

  @override
  State<DetailsFormScreen> createState() => _DetailsFormScreenState();
}

class _DetailsFormScreenState extends State<DetailsFormScreen> {
  bool sendByMe = true;
  bool stair1 = false;
  bool elevator1 = false;
  bool stair2 = false;
  bool elevator2 = false;
  bool byMe = false;
  bool bySomeoneElse = false;
  bool useStairs = false;
  bool useElevators = false;

  Color primaryGreen = const Color(0xff00C27A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ---------------- APPBAR ----------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.6,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
        title: Text(
          "Details",
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColor.primaryColor,
          ),
        ),
        actions: [
          SvgPicture.asset(
            "assets/images/call.svg",
            height: 36,
            width: 36,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),
          SvgPicture.asset(
            "assets/images/chat.svg",
            height: 36,
            width: 36,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 14),
        ],
      ),

      // ---------------- BODY ----------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ✅ FIXED PICKUP/DROP CARD
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColor.secondaryColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primaryColor.withOpacity(0.10),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/pickupDropup.png",
                    height: 120,
                    width: 22,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _locationTile("Pickup",
                            "35, S Tukoganj Rd, Manorama Ganj, Dhar Kothi Colony, Indore, Madhya Pradesh"),
                        Divider(thickness: 1, color: Colors.grey.shade300),
                        _locationTile("Drop-Off",
                            "24 Juni, Juni Indore, Indore, Madhya Pradesh, 452007, India"),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            _sectionTitle("Send By"),
            const SizedBox(height: 8),
            Row(
              children: [
                checkBox(byMe, (v) {
                  setState(() {
                    byMe = v!;
                    if (v) bySomeoneElse = false;
                  });
                }),
                SizedBox(
                  width: 5,
                ),
                labelSmall("By Me"),

                const SizedBox(width: 20),

                checkBox(bySomeoneElse, (v) {
                  setState(() {
                    bySomeoneElse = v!;
                    if (v) byMe = false;
                  });
                }),
                SizedBox(
                  width: 5,
                ),
                labelSmall("Someone Else"),
              ],
            ),


            const SizedBox(height: 20),

            _inputLabel("Name"),
            SizedBox(
              height: 5,
            ),
            _inputField("Urvashi J."),
            const SizedBox(height: 16),

            _inputLabel("Phone Number"),
            SizedBox(
              height: 5,
            ),
            _inputField("+91 88157 89745", keyboard: TextInputType.phone),
            const SizedBox(height: 16),

            _inputLabel("Unit or Apartment"),
            SizedBox(
              height: 5,
            ),
            _inputField("987"),
            const SizedBox(height: 20),

            _checkboxTile("Have to Use Staircase", stair1, (v) => setState(() => stair1 = v)),
            const SizedBox(height: 20),
            _inputLabel("Number of Stairs"),
            SizedBox(
              height: 5,
            ),
            _inputField("965478425", keyboard: TextInputType.number),
            const SizedBox(height: 16),

            _checkboxTile("Can Use Elevators", elevator1, (v) => setState(() => elevator1 = v)),
            const SizedBox(height: 25),

            _inputLabel("Name"),
            SizedBox(
              height: 5,
            ),
            _inputField("Ramesh J."),
            const SizedBox(height: 16),

            _inputLabel("Phone Number"),
            SizedBox(
              height: 5,
            ),
            _inputField("Enter Number"),
            const SizedBox(height: 16),

            _inputLabel("Unit or Apartment"),
            SizedBox(
              height: 5,
            ),
            _inputField("5877"),
            const SizedBox(height: 20),

            _checkboxTile("Have to Use Staircase", stair2, (v) => setState(() => stair2 = v)),
            const SizedBox(height: 20),

            _inputLabel("Number of Stairs"),
            SizedBox(
              height: 5,
            ),
            _inputField("Enter Number of Stairs", keyboard: TextInputType.number),
            const SizedBox(height: 16),

            _checkboxTile("Can Use Elevators", elevator2, (v) => setState(() => elevator2 = v)),
            const SizedBox(height: 25),

            _inputLabel("Total 8 items"),
            SizedBox(
              height: 5,
            ),
            _inputField("1. 8 Package"),


          ],
        ),
      ),

      // ---------------- BOTTOM BAR ----------------
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 14),
        decoration:  BoxDecoration(
          color:AppColor.secondaryColor,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Total Price: 4660.00",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColor.secondprimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: AppColor.secondaryColor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ---------------- UI HELPERS ----------------
  Widget _locationTile(String title, String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 4),
        Text(address,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              color: Colors.black87,
              height: 1.3,
            )),
      ],
    );
  }

  Widget _sectionTitle(String text) {
    return Text(text,
        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600));
  }

  // ---------------- SMALL LABEL ----------------
  Widget labelSmall(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: AppColor.primaryColor,
        fontSize: 15,
      ),
    );
  }

  Widget _inputLabel(String text) {
    return Text(text,
        style: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87));
  }

  Widget _inputField(String hint, {TextInputType keyboard = TextInputType.text}) {
    return TextField(
      keyboardType: keyboard,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.black45),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:  BorderSide(color: AppColor.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColor.borderColor),
        ),
      ),
    );
  }

  Widget _checkboxTile(String title, bool value, Function(bool) onChanged) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => onChanged(!value),
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColor.borderColor,width: 1),
              color: value ? AppColor.secondprimaryColor : Colors.white,
            ),
            child: value ? Icon(Icons.check, size: 16, color: AppColor.primaryColor) : null,
          ),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87)),
      ],
    );
  }

  // ---------------- CHECKBOX ----------------
  Widget checkBox(bool value, Function(bool?) onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 22,
        height: 22,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: AppColor.borderColor,
            width: 1,
          ),
          color: value ? AppColor.secondprimaryColor : Colors.white,
        ),
        child: value
            ? Icon(
          Icons.check,
          size: 16,
          color: AppColor.primaryColor,
        )
            : const SizedBox(),
      ),
    );
  }





  Widget _selectBox(String text, bool active, VoidCallback tap) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: active ? primaryGreen : Colors.black26),
          color: active ? primaryGreen.withOpacity(.15) : Colors.white,
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            color: active ? primaryGreen : Colors.black87,
          ),
        ),
      ),
    );
  }
}
