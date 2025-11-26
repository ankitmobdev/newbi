import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant.dart';
import 'appliance.dart';

class MovingHelpScreen extends StatefulWidget {
  const MovingHelpScreen({super.key});

  @override
  State<MovingHelpScreen> createState() => _MovingHelpScreenState();
}

class _MovingHelpScreenState extends State<MovingHelpScreen> {
  int? selectedIndex;

  final List<Map<String, dynamic>> movingOptions = [
    {
      "title": "Studio",
      "price": "\$350",
      "desc":
      "This includes bed (bedframe, mattress, and boxspring), nightstand, dresser and chest of drawers, coffee table + 4 chairs, couch, tv, electronics, a/o bookshelf and up to 7 boxes (books, storage container, suitcase and duffel bags), lamp"
    },
    {
      "title": "1-Bedroom",
      "price": "\$450",
      "desc":
      "This includes bed (bedframe, mattress, and boxspring), nightstand, dresser and chest of drawers, coffee table + 4 chairs, couch, tv, electronics, a/o bookshelf and up to 7 boxes (books, storage container, suitcase and duffel bags), lamp"
    },
    {
      "title": "2-Bedroom",
      "price": "\$850",
      "desc":
      "This includes bed (bedframe, mattress, and boxspring), nightstand, dresser and chest of drawers, coffee table + 4 chairs, couch, tv, electronics, a/o bookshelf and up to 7 boxes (books, storage container, suitcase and duffel bags), lamp"
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
          child: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: movingOptions.length,
                itemBuilder: (_, index) {
                  final item = movingOptions[index];
                  bool active = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: active ? AppColor.primaryColor : Colors.grey.shade300,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(1, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Icon
                          Container(
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor,        // 🔥 black background
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  "assets/images/movingHelp.png",
                                   height: 24,width: 24,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title + Price
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item["title"],
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      item["price"],
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColor.secondprimaryColor,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                // Description
                                Text(
                                  item["desc"],
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,fontWeight: FontWeight.w400,
                                    color: AppColor.textclr,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ---------------- NEXT BUTTON ----------------
            GestureDetector(
              onTap: () {
                if (selectedIndex == null) return;

                Helper.moveToScreenwithPush(context, ApplianceDetailsScreen());
                // Navigate to next screen
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Next",
                    style: GoogleFonts.poppins(
                      color: AppColor.secondaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
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
}
