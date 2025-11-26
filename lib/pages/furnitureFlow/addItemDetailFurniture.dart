import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant.dart';
import '../retailScreenFlow/addItem2.dart';

class AddItemsDetailFurnitureScreen extends StatefulWidget {
  final String? selectedMainItem;
  const AddItemsDetailFurnitureScreen({super.key, this.selectedMainItem});

  @override
  State<AddItemsDetailFurnitureScreen> createState() => _AddItemsDetailFurnitureScreenState();
}

class _AddItemsDetailFurnitureScreenState extends State<AddItemsDetailFurnitureScreen> {
  final TextEditingController searchController = TextEditingController();
  String query = "";

  String selectedSubItem = "Queen Bed Frame";

  final List<String> subItems = [
    "Queen Bed Frame",
    "King Bed Frame",
    "Twin Bed Frame",
    "Full Bed Frame",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,

      // ------------------- APPBAR -------------------
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
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ------------------- BODY -------------------
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------- SEARCH BOX -------------------
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.selectedMainItem ?? "Bed Frame",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, size: 22),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ------------------- SUB ITEMS LIST -------------------
            Expanded(
              child: ListView.builder(
                itemCount: subItems.length,
                itemBuilder: (_, index) {
                  final item = subItems[index];
                  bool isSelected = item == selectedSubItem;

                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedSubItem = item
                      );
                      Helper.moveToScreenwithPush(context, AddItemsDetailScreen());
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),

                              // Radio Circle
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: isSelected
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
