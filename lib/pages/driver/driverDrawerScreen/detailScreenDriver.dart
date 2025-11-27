import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_eat_e_commerce_app/constant.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsFormDriverScreen extends StatefulWidget {
  const DetailsFormDriverScreen({super.key});

  @override
  State<DetailsFormDriverScreen> createState() => _DetailsFormDriverScreenState();
}

class _DetailsFormDriverScreenState extends State<DetailsFormDriverScreen> {
  bool byMe = true;
  bool bySomeoneElse = false;

  bool stair1 = false;
  bool elevator1 = true;

  bool stair2 = false;
  bool elevator2 = true;

  Color primary = const Color(0xff00C27A);
  Color border = Colors.grey.shade300;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ======================= APPBAR =======================
      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
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
          SvgPicture.asset("assets/images/track.svg", height: 34,width: 85,),
        ],
      ),

      // ======================= BODY =======================
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pickupDropCard(),

            const SizedBox(height: 18),
            sectionTitle("Send By"),
            const SizedBox(height: 10),

            Row(
              children: [
                checkbox(byMe, (v) {
                  setState(() {
                    byMe = true;
                    bySomeoneElse = false;
                  });
                }),
                const SizedBox(width: 8),
                label("By Me"),

                const SizedBox(width: 22),

                checkbox(bySomeoneElse, (v) {
                  setState(() {
                    bySomeoneElse = true;
                    byMe = false;
                  });
                }),
                const SizedBox(width: 8),
                label("Someone Else"),
              ],
            ),

            const SizedBox(height: 20),

            senderReceiverBlock(
              name: "Urvashi J.",
              phone: "+91 88157 89745",
              apartment: "987",
              stair: stair1,
              elevator: elevator1,
              onStairTap: () => setState(() => stair1 = !stair1),
              onElevatorTap: () => setState(() => elevator1 = !elevator1),
            ),

            const SizedBox(height: 10),

            senderReceiverBlock(
              name: "Ramesh J.",
              phone: "+44 62545 68277",
              apartment: "5877",
              stair: stair2,
              elevator: elevator2,
              onStairTap: () => setState(() => stair2 = !stair2),
              onElevatorTap: () => setState(() => elevator2 = !elevator2),
            ),

            const SizedBox(height: 18),
            sectionTitle("Total Items"),
            const SizedBox(height: 5),
            inputField("1. 8 Package"),
            const SizedBox(height: 150),
          ],
        ),
      ),

      // ======================= BOTTOM BAR =======================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, -2),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            priceText("Driver Price: ₹2000.00"),
            priceText("Add Price: ₹2660.00"),
            const SizedBox(height: 4),
            Divider(),
            Text(
              "Total Price: ₹4660.00",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color:AppColor.secondprimaryColor,
              ),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Accept",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red, width: 1.3),
                    ),
                    child: Center(
                      child: Text(
                        "Decline",
                        style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ======================= WIDGETS =======================

  Widget pickupDropCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFD),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 8, offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/images/pickupDropup.png",
              height: 120, width: 22, fit: BoxFit.contain),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                locationTile("Pickup",
                    "35, S Tukoganj Rd, Manorama Ganj, Dhar Kothi Colony, Indore, MP"),
                Divider(),
                locationTile("Drop-Off",
                    "24 Juni, Juni Indore, Indore, Madhya Pradesh, 452007"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget locationTile(String title, String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 13, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(
          address,
          style: GoogleFonts.poppins(fontSize: 12.5, height: 1.3),
        ),
      ],
    );
  }

  Widget senderReceiverBlock({
    required String name,
    required String phone,
    required String apartment,
    required bool stair,
    required bool elevator,
    required VoidCallback onStairTap,
    required VoidCallback onElevatorTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        inputLabel("Name"),
        inputField(name),

        const SizedBox(height: 14),
        inputLabel("Phone Number"),
        inputField(phone, keyboard: TextInputType.phone),

        const SizedBox(height: 14),
        inputLabel("Unit or Apartment"),
        inputField(apartment),

        const SizedBox(height: 14),
        toggleTile("Have to Use Staircase", stair, onStairTap),

        const SizedBox(height: 14),
        inputLabel("Number of Stairs"),
        inputField("Enter Number", keyboard: TextInputType.number),

        const SizedBox(height: 14),
        toggleTile("Can Use Elevators", elevator, onElevatorTap),
      ],
    );
  }

  Widget sectionTitle(String text) => Text(
    text,
    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
  );

  Widget inputLabel(String text) => Text(
    text,
    style: GoogleFonts.poppins(
        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
  );

  Widget inputField(String hint, {TextInputType keyboard = TextInputType.text}) {
    return TextField(
      keyboardType: keyboard,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.black45, fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: border)),
      ),
    );
  }

  Widget toggleTile(String title, bool value, VoidCallback tap) {
    return Row(
      children: [
        GestureDetector(
          onTap: tap,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              border: Border.all(color: border),
              borderRadius: BorderRadius.circular(6),
              color: value ? Colors.green.shade100 : Colors.white,
            ),
            child: value
                ? const Icon(Icons.check, size: 16, color: Colors.green)
                : null,
          ),
        ),
        const SizedBox(width: 10),
        Text(title, style: GoogleFonts.poppins(fontSize: 14)),
      ],
    );
  }

  Widget checkbox(bool v, Function(bool) change) {
    return GestureDetector(
      onTap: () => change(!v),
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColor.borderColor),
          color: v ? AppColor.secondprimaryColor : Colors.white,
        ),
        child: v
            ? Icon(Icons.check, size: 16, color: AppColor.secondaryColor)
            : const SizedBox(),
      ),
    );
  }

  Widget label(String text) => Text(
    text,
    style: GoogleFonts.poppins(
        fontSize: 15, fontWeight: FontWeight.w500, color: AppColor.primaryColor),
  );

  Widget priceText(String text) => Text(
    text,
    style: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColor.primaryColor
    ),
  );
}
