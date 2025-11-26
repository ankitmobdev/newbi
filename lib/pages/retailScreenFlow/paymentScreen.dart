import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant.dart';
import '../homeScreen/homeScreen.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String selectedPayment = "";

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
          child: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
        title: Text(
          "Payment Method",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),

      // ---------------- BODY ----------------
      body: Column(
        children: [
          const SizedBox(height: 10),

          // ---------------- PAYMENT OPTIONS ----------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _paymentCard(
                  icon: "assets/images/card.svg",
                  title: "Card Payment",
                  value: "card",
                ),
                const SizedBox(height: 12),

                _paymentCard(
                  icon: "assets/images/mywallet.svg",
                  title: "My wallet",
                  value: "wallet",
                ),
                const SizedBox(height: 12),

                _paymentCard(
                  icon: "assets/images/cod.svg",
                  title: "Cash on Delivery",
                  value: "cod",
                ),
              ],
            ),
          ),

          const Spacer(),

          // ---------------- CONTINUE BUTTON ----------------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: selectedPayment.isEmpty ? null : () {
                  showConfirmPopup(context);
                },
                child: Text(
                  "Continue to Pay",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColor.secondaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
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
                  "Successfully",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                // ---------------- MESSAGE ----------------
                Text(
                  "Booking added Successfully",
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

                        Helper.moveToScreenwithPush(context, HomeScreen());

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

  // =========================================================
  // PAYMENT OPTION CARD
  // =========================================================
  Widget _paymentCard({
    required String icon,
    required String title,
    required String value,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() => selectedPayment = value);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColor.secondaryColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            // LEFT ICON
            SvgPicture.asset(
              icon,
              height: 20,
              width: 25,
            ),

            const SizedBox(width: 14),

            // TITLE
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // CUSTOM RADIO
            _customRadio(selectedPayment == value),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // CUSTOM RADIO BUTTON (matches screenshot)
  // =========================================================
  Widget _customRadio(bool isSelected) {
    return Container(
      height: 22,
      width: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.primaryColor, width: 2),
      ),
      child: isSelected
          ? Center(
        child: Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
      )
          : null,
    );
  }
}
