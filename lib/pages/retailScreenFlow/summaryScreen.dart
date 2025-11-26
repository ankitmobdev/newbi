import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_eat_e_commerce_app/pages/retailScreenFlow/paymentScreen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool agreeTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
        title: Text(
          "Summary",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColor.primaryColor,
          ),
        ),
      ),

      // ---------------- BODY ----------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---------------- PICKUP & DROPOFF BOX ----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColor.secondaryColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // LEFT PICKUP → DROPOFF IMAGE
                  Image.asset(
                    "assets/images/pickupDropup.png",
                    height: 95,    // adjust height according your design
                    width: 20,     // slender vertical image
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(width: 12),

                  // RIGHT SIDE CONTENT (Pickup + Dropoff)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       Container(
                         width: MediaQuery.of(context).size.width,
                         decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(12),
                           border: Border.all(color: AppColor.borderColor),
                         ),
                         child: Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 8.0),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               const SizedBox(height: 10),
                             Text(
                               "Pickup",
                               style: GoogleFonts.poppins(
                                 fontSize: 13,
                                 fontWeight: FontWeight.w500,
                                 color: AppColor.textclr,
                               ),
                             ),

                             Container(
                               padding: const EdgeInsets.all(5),
                               decoration: BoxDecoration(
                                 color: Colors.white,
                                 borderRadius: BorderRadius.circular(10),
                               ),
                               child: Text(
                                 "Moscow–City, Empire – K2 484P4",
                                 style: GoogleFonts.poppins(
                                   fontSize: 14,
                                   color: AppColor.primaryColor,
                                 ),
                               ),
                             ),
                           ],),
                         ),
                       ),
                        // ---------------- PICKUP ----------------


                        const SizedBox(height: 16),

                        // ---------------- DROPOFF ----------------
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColor.borderColor),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  "Drop–Off",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color:AppColor.textclr,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "105 William St, Chicago, US",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                ],
              ),
            ),


            const SizedBox(height: 20),

            // ---------------- ITEM TITLE ----------------
            Text(
              "Total 1 Items",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColor.textclr,
              ),
            ),
            const SizedBox(height: 8),

            // ---------------- ITEM CARD ----------------
            Container(
              height: 150,
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColor.secondaryColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.borderColor, width: 1),
              ),
              child: Text(
                "1. Chair (Small Item)",maxLines: 4,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: AppColor.primaryColor,
                ),
              ),
            ),

          SizedBox(
            height: MediaQuery.of(context).size.height*0.15,
          ),

            // ---------------- TOTAL PRICE ----------------
            Center(
              child: Text(
                "Total Price: 4660:00",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: AppColor.secondprimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- TERMS CHECKBOX ----------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: AppColor.primaryColor,
                  value: agreeTerms,
                  onChanged: (v) {
                    setState(() => agreeTerms = v ?? false);
                  },
                ),
                Expanded(
                  child: Text(
                    "I agree to Pricing Policy, Terms of Service and Cancelation Policy",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color:  AppColor.primaryColor,fontWeight: FontWeight.w400
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ---------------- BOOK BUTTON ----------------
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: agreeTerms ? () {
                  showConfirmPopup(context);
                } : null,
                child: Text(
                  "Book",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColor.secondaryColor,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  void showConfirmPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must choose Cancel or Okay
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ---------------- TITLE ----------------
                Text(
                  "Confirm",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                // ---------------- MESSAGE ----------------
                Text(
                  "Please confirm to proceed this order",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),

                // ---------------- BUTTONS ROW ----------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    // ❌ CANCEL BUTTON
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(width: 24),

                    // ✔ OKAY BUTTON
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor, // black
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Helper.moveToScreenwithPush(context, PaymentMethodScreen());

                        // Add next action here
                      },
                      child: Text(
                        "Okay",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: AppColor.secondaryColor, // white
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

}
