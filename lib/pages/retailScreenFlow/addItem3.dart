import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant.dart';
import '../../models/Global.dart';
import '../../models/OrderData.dart';
import '../furnitureFlow/addItemFurniture.dart';
import '../movingHelp/appliance.dart';
import 'addItemScreen.dart';
import 'aideDriver.dart';

class AddItemsSummaryScreen extends StatefulWidget {
  final OrderData? orderData;
  const AddItemsSummaryScreen({
    super.key,
    this.orderData,
  });
  @override
  State<AddItemsSummaryScreen> createState() => _AddItemsSummaryScreenState();
}

class _AddItemsSummaryScreenState extends State<AddItemsSummaryScreen> {
  final List<String> itemList = [
    "Chair (Small Item)",
    "Table (Medium Item)",
    "Fridge (Large Item)",
    "Box (Small Item)",
  ];

  @override
  void initState() {
    super.initState();

    String json = jsonEncode(Global.packageList.map((item) => {
      "categoryName": item.categoryName,
      "subcategory": item.subcategory,
      "quantity": item.quantity,
      "instruction": item.instruction,
      "extraSubcategory": item.extraSubcategory,
      "price": item.price,
    }).toList());

    debugPrint("📦 package_list_json: $json");

  }

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
          child: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        ),
        title: Text(
          "Add Items",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),

      // ---------------- BODY ----------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TITLE
            Text(
              "Total ${Global.packageList.length} Items",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColor.textclr,
              ),
            ),
            const SizedBox(height: 12),

            // LIST OF ITEMS
            // LIST OF ITEMS
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: Global.packageList.length,
            itemBuilder: (context, index) {
              final item = Global.packageList[index];

              final bool showSubCategory =
                  widget.orderData!.bookingType == "FurnitureDelivery" ||
                      widget.orderData!.bookingType == "MovingHelp";

              return Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // FIRST ROW → Quantity + Category
                    Row(
                      children: [
                        Text(
                          item.quantity ?? "0",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 10),

                        // CATEGORY NAME
                        Text(
                          item.categoryName ?? "",
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),

                    // SUBCATEGORY (Only for FurnitureDelivery / MovingHelp)
                    if (showSubCategory && (item.subcategory?.isNotEmpty ?? false)) ...[
                      const SizedBox(height: 6),
                      Text(
                        item.subcategory ?? "",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 40),

            // ---------------- ADD ANOTHER ITEM ----------------
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {

                  debugPrint("=====screen_9=${widget.orderData!.bookingType}");
                  if (widget.orderData!.bookingType == "FurnitureDelivery"/* || widget.orderData!.bookingType == "MovingHelp"*/) {
                    Helper.moveToScreenwithPush(
                      context,
                      AddItemsFurnitureScreen(orderData: widget.orderData),
                    );
                  } else if (widget.orderData!.bookingType == "MovingHelp") {
                    Helper.moveToScreenwithPush(
                      context,
                      ApplianceDetailsScreen(orderData: widget.orderData),
                    );
                  } else {
                    Helper.moveToScreenwithPush(
                      context,
                      AddItemsScreen(orderData: widget.orderData),
                    );
                  }

                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black, width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.white,
                ),
                child: Text(
                  "+   Add Another Item",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ---------------- NEXT BUTTON ----------------
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Helper.moveToScreenwithPush(context,
                    AideDriverScreen(orderData: widget.orderData),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
