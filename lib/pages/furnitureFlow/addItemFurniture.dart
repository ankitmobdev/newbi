import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant.dart';
import 'addItemDetailFurniture.dart';


class AddItemsFurnitureScreen extends StatefulWidget {
  const AddItemsFurnitureScreen({super.key});

  @override
  State<AddItemsFurnitureScreen> createState() => _AddItemsFurnitureScreenState();
}

class _AddItemsFurnitureScreenState extends State<AddItemsFurnitureScreen> {
  final TextEditingController searchController = TextEditingController();
  String query = "";

  final List<String> items = [
    "Bed Frame",
    "Headboard",
    "Mattress",
    "Box Spring",
    "Crib",
    "Nightstand",
    "Table",
    "Armoire",
    "Bookcase",
    "Desk",
    "Lamps",
    "Sofa",
    "Chair",
    "Rug/Carpet",
    "China Cabinet",
    "Patio Table",
    "Dresser",
    "Wardrobe",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,

      // -------------------- APPBAR --------------------
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

      // -------------------- BODY --------------------
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // -------------------- SEARCH BOX --------------------
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
                  SvgPicture.asset("assets/images/search_3_line.svg"),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search Items",
                        hintStyle: GoogleFonts.poppins(
                          color: AppColor.textclr,
                          fontSize: 16,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() => query = value.toLowerCase());
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // -------------------- ITEMS LIST --------------------
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final item = items[index];

                  // Apply search filter
                  if (!item.toLowerCase().contains(query)) return const SizedBox();

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => AddItemsDetailFurnitureScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down,
                                  color: Colors.black, size: 24),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
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
