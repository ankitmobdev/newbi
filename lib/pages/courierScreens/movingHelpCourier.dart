import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant.dart';
import '../movingHelp/addItemMovingScreen2.dart';

class MovingHelpItemsCourierScreen extends StatefulWidget {
  const MovingHelpItemsCourierScreen({super.key});

  @override
  State<MovingHelpItemsCourierScreen> createState() => _MovingHelpItemsCourierScreenState();
}

class _MovingHelpItemsCourierScreenState extends State<MovingHelpItemsCourierScreen> {
  List<Map<String, dynamic>> items = [
    {
      "title": "Package",
      "subtitle": "All package in a box shouldn’t exceed lbs",
      "qty": 1
    },
    {"title": "Envelope", "subtitle": "", "qty": 0},
    {"title": "Letter", "subtitle": "", "qty": 0},
    {"title": "Document", "subtitle": "", "qty": 0},
    {
      "title": "Shopping Bag",
      "subtitle": "No shopping bag should exceed 25 lbs",
      "qty": 0
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,

      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child:  Icon(Icons.arrow_back_ios,
              size: 20, color: AppColor.primaryColor),
        ),
        title: Text(
          "Moving Help",
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: AppColor.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final item = items[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColor.secondaryColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color:AppColor.borderColor ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.06),
                          blurRadius: 6,
                          offset: const Offset(1, 3),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        // ICON BOX
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                "assets/images/movingHelp.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 14),

                        // TITLE & SUBTITLE
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["title"],
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                              if (item["subtitle"] != "")
                                Text(
                                  item["subtitle"],
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColor.textclr,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // QUANTITY BOX
                        Row(
                          children: [
                            _qtyButton(
                              icon: Icons.remove,
                              onTap: () {
                                setState(() {
                                  if (item["qty"] > 0) item["qty"]--;
                                });
                              },
                            ),

                            const SizedBox(width: 10),

                            Center(
                              child: Text(
                                item["qty"].toString().padLeft(2, "0"),
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            _qtyButton(
                              icon: Icons.add,
                              onTap: () {
                                setState(() {
                                  item["qty"]++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // NEXT BUTTON
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
                onPressed: () {
                  Helper.moveToScreenwithPush(context, AddItemsDetailMovingScreen2());
                },
                child: Text(
                  "Next",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColor.secondaryColor,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // ---------------- QTY BUTTON ----------------
  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color:AppColor.secondaryColor, size: 22),
      ),
    );
  }
}
