import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant.dart';
import '../../models/OrderData.dart';
import 'addItem2.dart';

class AddItemsScreen extends StatefulWidget {
  final OrderData? orderData;
  const AddItemsScreen({super.key, this.orderData});
  @override
  State<AddItemsScreen> createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //debugPrint("=====order=${widget.orderData}");
    debugPrint("=====pick_1=${widget.orderData!.pickupLatitude}");
    debugPrint("=====pick_2=${widget.orderData!.pickupLongitude}");
    debugPrint("=====pick_3=${widget.orderData!.dropLatitude}");
    debugPrint("=====pick_4=${widget.orderData!.dropLongitude}");

  }

  @override
  Widget build(BuildContext context) {
    String searchText = searchController.text.trim();

    // ---------- Generate result items exactly like Kotlin code ----------
    List<String> filteredItems = [];
    if (searchText.isNotEmpty) {
      filteredItems = [
        "$searchText (Small Item)",
        "$searchText (Medium Item)",
        "$searchText (Large Item)",
        "$searchText (X-Large Item)",
      ];
    }

    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
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
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {}); // refresh UI
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
                itemCount: filteredItems.length,
                itemBuilder: (_, index) {
                  final item = filteredItems[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Helper.moveToScreenwithPush(context, AddItemsDetailScreen(itemName: item, orderData: widget.orderData),);
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
