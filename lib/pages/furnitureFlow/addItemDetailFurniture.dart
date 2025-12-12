import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant.dart';
import '../../models/OrderData.dart';
import '../../models/SubcategoryDatum.dart';
import '../../services/api_client.dart';
import '../../services/api_constants.dart';
import '../retailScreenFlow/addItem2.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'addItemCategory.dart';

class AddItemsDetailFurnitureScreen extends StatefulWidget {
  final String? selectedMainItem;
  final OrderData? orderData;

  const AddItemsDetailFurnitureScreen({super.key, this.selectedMainItem, this.orderData});

  @override
  State<AddItemsDetailFurnitureScreen> createState() => _AddItemsDetailFurnitureScreenState();
}

class _AddItemsDetailFurnitureScreenState extends State<AddItemsDetailFurnitureScreen> {
  final TextEditingController searchController = TextEditingController();
  String query = "";

  bool loading = true;
  bool error = false;
  List<SubcategoryDatum> subCategoryList = [];
  String? selectedSubItem;
  String? selectedSubItemPrice;

  @override
  void initState() {
    super.initState();
    loadSubcategories();
  }

  Future<void> loadSubcategories() async {
    setState(() {
      loading = true;
      error = false;
    });

    final result = await callSubCategoryListApi(widget.selectedMainItem ?? '');

    if (result == null) {
      // API error
      setState(() {
        loading = false;
        error = true;
      });
      return;
    }

    setState(() {
      subCategoryList = result;
      loading = false;
    });

    // optionally set default selected item
    // if (subCategoryList.isNotEmpty) {
    //   selectedSubItem = subCategoryList.first.subcategory;
    //   selectedSubItemPrice = subCategoryList.first.price;
    // }

  }

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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header showing selected main item
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
                      widget.selectedMainItem ?? "Category",
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

            // content
            Expanded(
              child: Builder(builder: (_) {
                if (loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (error) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Failed to load subcategories'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: loadSubcategories,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (subCategoryList.isEmpty) {
                  return const Center(child: Text('No subcategories found'));
                }

                final filtered = subCategoryList.where((s) => s.subcategory.toLowerCase().contains(query)).toList();

                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, index) {
                    final item = filtered[index];
                    final itemTitle = item.subcategory;
                    final isSelected = itemTitle == selectedSubItem;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedSubItem = itemTitle;
                          selectedSubItemPrice = item.price;
                        });

                        // Navigate to next screen with selected subcategory (pass whatever you need)
                        Helper.moveToScreenwithPush(
                          context,
                          AddItemsCategoryScreen(
                            // pass the data you need in AddItemsDetailScreen constructor
                            selectedMainItem: widget.selectedMainItem,
                            selectedSubItem: selectedSubItem,
                            selectedSubItemPrice: selectedSubItemPrice,
                            orderData: widget.orderData,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                itemTitle,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                  color: isSelected ? Colors.black : Colors.grey,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<SubcategoryDatum>?> callSubCategoryListApi(String categoryName) async {
    try {
      final body = {
        'code': ApiCode.kcode, // or 'app_token' if you use token
        'category_name': categoryName,
        // add driver id or other params if required:
        // 'driver_id': AppSession(...).user.data.userId.toString(),
      };

      final response = await ApiClient.dio.post(
        BaseURl.baseUrl + ApiAction.menuSubcategory, // <-- replace ApiAction.subCategory with actual action constant
        data: FormData.fromMap(body),
      );

      // response.data can be String or already a Map
      final dynamic raw = response.data;
      final Map<String, dynamic> jsonMap = raw is String ? jsonDecode(raw) : raw;

      if (jsonMap['result'] != null && jsonMap['result'].toString().toLowerCase() == 'success') {
        final List data = jsonMap['deliverydata'] ?? jsonMap['data'] ?? [];
        return data.map((e) => SubcategoryDatum.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        return [];
      }
    } catch (e, st) {
      print('callSubCategoryListApi ERROR: $e\n$st');
      return null;
    }
  }

}
