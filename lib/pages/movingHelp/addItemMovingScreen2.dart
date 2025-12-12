import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant.dart';
import '../../models/OrderData.dart';
import '../retailScreenFlow/aideDriver.dart';

class AddItemsDetailMovingScreen2 extends StatefulWidget {
  final OrderData? orderData;
  const AddItemsDetailMovingScreen2({super.key, this.orderData});
  @override
  State<AddItemsDetailMovingScreen2> createState() => _AddItemsDetailMovingScreen2State();
}

class _AddItemsDetailMovingScreen2State extends State<AddItemsDetailMovingScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      // ---------------- APPBAR ----------------
      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios,
              color: Colors.black, size: 20),
        ),
        title: Text(
          "Add Items",
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ---------------- BODY ----------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---------------- DESCRIPTION BOX ----------------
            Container(
              height: 130,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black12,
                ),
              ),
              child: TextField(
                maxLines: 6,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Description",
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.poppins(
                    color: AppColor.textclr,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            //const SizedBox(height: 20),

            // ---------------- UPLOAD IMAGE BOX ----------------
            /*Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade400,
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/photo_album_2_fill.svg",
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Upload Your Image",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColor.textclr,
                      ),
                    )
                  ],
                ),
              ),
            ),*/

            const SizedBox(height: 40),

            // ---------------- NEXT BUTTON ----------------
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  // Helper.moveToScreenwithPush(context, AddItemsSummaryScreen());
                  Helper.moveToScreenwithPush(context, AideDriverScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "Next",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
