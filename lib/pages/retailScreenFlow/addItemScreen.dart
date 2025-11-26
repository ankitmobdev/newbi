import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant.dart';
import 'addItem2.dart';

class AddItemsScreen extends StatefulWidget {
  const AddItemsScreen({super.key});

  @override
  State<AddItemsScreen> createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  final List<String> items = [
    "Chair (Small Item)",
    "Chair (Medium Item)",
    "Chair (Large Item)",
    "Chair (X-Large Item)",
  ];

  final TextEditingController searchController = TextEditingController();
  String query = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,

      // ----------------- APPBAR -----------------
      appBar: AppBar(
        backgroundColor:AppColor.secondaryColor,
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

      // ---------------------- BODY ----------------------
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // ---------------------- SEARCH FIELD ----------------------
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  SvgPicture.asset("assets/images/search_3_line.svg"),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: GoogleFonts.poppins(fontSize: 15),
                      decoration: InputDecoration(
                        hintText: "Search Items",
                        hintStyle: GoogleFonts.poppins(
                          color: AppColor.textclr,
                          fontSize: 16,fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() => query = value.toLowerCase());
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------------- LIST ITEMS ----------------------
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final item = items[index];
                  if (!item.toLowerCase().contains(query)) return SizedBox();

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Helper.moveToScreenwithPush(context, AddItemsDetailScreen());

                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item,
                              style: GoogleFonts.poppins(
                                color: AppColor.primaryColor,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey.shade300,
                      )
                    ],
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
