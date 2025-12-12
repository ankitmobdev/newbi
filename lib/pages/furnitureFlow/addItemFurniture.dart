import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../constant.dart';
import '../../models/BookDTO.dart';
import '../../models/OrderData.dart';
import '../../services/api_client.dart';
import '../../services/api_constants.dart';
import 'addItemDetailFurniture.dart';

// class AddItemsFurnitureScreen extends StatefulWidget {
//   final OrderData? orderData;
//   const AddItemsFurnitureScreen({super.key, this.orderData});
//   @override
//   State<AddItemsFurnitureScreen> createState() => _AddItemsFurnitureScreenState();
// }
//
// class _AddItemsFurnitureScreenState extends State<AddItemsFurnitureScreen> {
//   final TextEditingController searchController = TextEditingController();
//   String query = "";
//
//   final List<String> items = [
//     "Bed Frame",
//     "Headboard",
//     "Mattress",
//     "Box Spring",
//     "Crib",
//     "Nightstand",
//     "Table",
//     "Armoire",
//     "Bookcase",
//     "Desk",
//     "Lamps",
//     "Sofa",
//     "Chair",
//     "Rug/Carpet",
//     "China Cabinet",
//     "Patio Table",
//     "Dresser",
//     "Wardrobe",
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.secondaryColor,
//
//       // -------------------- APPBAR --------------------
//       appBar: AppBar(
//         backgroundColor: AppColor.secondaryColor,
//         elevation: 0,
//         centerTitle: true,
//         leading: GestureDetector(
//           onTap: () => Navigator.pop(context),
//           child: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
//         ),
//         title: Text(
//           "Add Items",
//           style: GoogleFonts.poppins(
//             fontSize: 18,
//             color: Colors.black,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//
//       // -------------------- BODY --------------------
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//         child: Column(
//           children: [
//             // -------------------- SEARCH BOX --------------------
//             Container(
//               height: 48,
//               padding: const EdgeInsets.symmetric(horizontal: 14),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(color: Colors.grey.shade300),
//               ),
//               child: Row(
//                 children: [
//                   SvgPicture.asset("assets/images/search_3_line.svg"),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: TextField(
//                       controller: searchController,
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: "Search Items",
//                         hintStyle: GoogleFonts.poppins(
//                           color: AppColor.textclr,
//                           fontSize: 16,
//                         ),
//                       ),
//                       onChanged: (value) {
//                         setState(() => query = value.toLowerCase());
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 16),
//
//             // -------------------- ITEMS LIST --------------------
//             Expanded(
//               child: ListView.builder(
//                 itemCount: items.length,
//                 itemBuilder: (_, index) {
//                   final item = items[index];
//                   // Apply search filter
//                   if (!item.toLowerCase().contains(query)) return const SizedBox();
//                   return Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (_) => AddItemsDetailFurnitureScreen()),
//                           );
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           height: 48,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(color: Colors.grey.shade300),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 item,
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 15,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               const Icon(Icons.keyboard_arrow_down,
//                                   color: Colors.black, size: 24),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class AddItemsFurnitureScreen extends StatefulWidget {
  final OrderData? orderData;
  const AddItemsFurnitureScreen({super.key, this.orderData});
  @override
  State<AddItemsFurnitureScreen> createState() =>
      _AddItemsFurnitureScreenState();
}

class _AddItemsFurnitureScreenState extends State<AddItemsFurnitureScreen> {
  final TextEditingController searchController = TextEditingController();
  String query = "";
  //bool loading = true;

  List<Datum> categoryList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadCategories();
    });
  }

  Future<void> loadCategories() async {
    _showLoader();
    final result = await callCategoryListApi("Furniture");
    Navigator.of(context, rootNavigator: true).pop();
    if (result != null && result.result == "success") {
      setState(() {
        categoryList = result.data;
        //loading = false;
      });
    } else {
      //setState(() => loading = false);
    }
  }

  void _showLoader() {
    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) => Center(
        child: Lottie.asset(
          'assets/animation/dots_loader.json',
          repeat: true,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        elevation: 0,
        title: const Text("Add Items"),
        leading: BackButton(color: Colors.black),
      ),
      body: /*loading
          ? const Center(child: CircularProgressIndicator())
          :*/ Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ---------------- SEARCH ----------------
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
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search Category",
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

            // ---------------- CATEGORY LIST ----------------
            Expanded(
              child: ListView.builder(
                itemCount: categoryList
                    .where((cat) => cat.categoryName.toLowerCase().contains(query.toLowerCase()))
                    .length,
                itemBuilder: (_, index) {
                  final filteredList = categoryList
                      .where((cat) => cat.categoryName.toLowerCase().contains(query.toLowerCase()))
                      .toList();
                  final cat = filteredList[index];

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Helper.moveToScreenwithPush(
                            context,
                            AddItemsDetailFurnitureScreen(
                              selectedMainItem: cat.categoryName,
                              orderData: widget.orderData,
                            ),
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
                                cat.categoryName,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_right,
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

  Future<BookDTO?> callCategoryListApi(String movingType) async {
    try {
      final body = {
        "code": ApiCode.kcode,
      };

      if (movingType == "Furniture") {
        body["type"] = "Furniture";
      } else {
        body["type"] = "Moving";
        body["type1"] = "Miscellaneous";
      }

      final response = await ApiClient.dio.post(
        BaseURl.baseUrl + ApiAction.menuCategory,
        data: FormData.fromMap(body),
      );

      print("API RAW RESPONSE: ${response.data}");

      if (response.statusCode == 200) {

        /// -------------------------------------
        /// 🔥 IMPORTANT FIX
        /// Convert STRING → JSON Map
        /// -------------------------------------
        final Map<String, dynamic> jsonMap = response.data is String ? jsonDecode(response.data) : response.data;

        return BookDTO.fromJson(jsonMap);
      }
    } catch (e) {
      print("DIO API ERROR: $e");
    }

    return null;
  }

}
