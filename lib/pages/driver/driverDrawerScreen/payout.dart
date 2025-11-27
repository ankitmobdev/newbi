import 'package:flutter/material.dart';
import 'package:go_eat_e_commerce_app/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'drawerScreenDriver.dart';

class PayoutScreen extends StatefulWidget {
  const PayoutScreen({super.key});

  @override
  State<PayoutScreen> createState() => _PayoutScreenState();
}

class _PayoutScreenState extends State<PayoutScreen> {
  final TextEditingController withdrawController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DriverCustomSideBar(),
      backgroundColor: Colors.white,

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          "Payout",
          style: GoogleFonts.poppins(
            color: AppColor.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ------------------ BODY ------------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------ TOP CARD ------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(
                color: AppColor.secondaryColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primaryColor.withOpacity(0.10),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Hello, Urvashi Jain",
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Your Total Earning",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColor.textclr,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$1510000.00",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColor.secondprimaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // ------------------ WITHDRAW TITLE ------------------
            Text(
              "Withdraw Money",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColor.primaryColor,
              ),
            ),

            const SizedBox(height: 10),

            // ------------------ INPUT FIELD ------------------
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppColor.secondaryColor,
                border: Border.all(color: AppColor.borderColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: withdrawController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Amount to Withdraw",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.black45,
                    fontSize: 14,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 26),

            // ------------------ PAYOUT BUTTON ------------------
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print("Withdraw: ${withdrawController.text}");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Payout",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: AppColor.secondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
