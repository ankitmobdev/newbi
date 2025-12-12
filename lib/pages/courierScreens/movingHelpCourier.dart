import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../SharedPreference/AppSession.dart';
import '../../constant.dart';
import '../../helper_class_snackbar.dart';
import '../../models/Global.dart';
import '../../models/ItemDTO.dart';
import '../../models/OrderData.dart';
import '../../models/SettingsModel.dart';
import '../../services/api_constants.dart';
import '../movingHelp/addItemMovingScreen2.dart';
import '../retailScreenFlow/aideDriver.dart';

class MovingHelpItemsCourierScreen extends StatefulWidget {
  final OrderData? orderData;
  const MovingHelpItemsCourierScreen({super.key, this.orderData});
  @override
  State<MovingHelpItemsCourierScreen> createState() => _MovingHelpItemsCourierScreenState();
}

class _MovingHelpItemsCourierScreenState extends State<MovingHelpItemsCourierScreen> {

  // List<Map<String, dynamic>> items = [
  //   {
  //     "title": "Package",
  //     "subtitle": "All package in a box shouldn’t exceed lbs",
  //     "qty": 1
  //   },
  //   {"title": "Envelope", "subtitle": "", "qty": 0},
  //   {"title": "Letter", "subtitle": "", "qty": 0},
  //   {"title": "Document", "subtitle": "", "qty": 0},
  //   {
  //     "title": "Shopping Bag",
  //     "subtitle": "No shopping bag should exceed 25 lbs",
  //     "qty": 0
  //   },
  // ];

  int selectedIndex = 0; // Default to first card (Studio)
  List<Map<String, dynamic>> movingOptions = [];
  SettingsModel? settings;
  bool loading = true;

  double totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    callSettingsApi();
  }

  Future<SettingsModel?> fetchSettingsDio(String userId) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        BaseURl.baseUrl + ApiAction.getsettings,
        data: {"code": ApiCode.kcode, "user_id": userId},
        options: Options(
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );
      Map<String, dynamic> jsonData =
      response.data is String ? jsonDecode(response.data) : response.data;
      return SettingsModel.fromJson(jsonData);
    } catch (e) {
      print('❌ Dio error: $e');
      return null;
    }
  }

  Future<void> callSettingsApi() async {
    final fetchedSettings = await fetchSettingsDio(AppSession().userId);

    if (fetchedSettings == null || fetchedSettings.vehicle == null) {
      AppSnackBar.error('Failed to fetch settings.');
      return;
    }

    setState(() {
      settings = fetchedSettings;
      debugPrint("=====co_pa1=${{settings!.vehicle.courierPackage}}");
      debugPrint("=====co_pa2=${{settings!.vehicle.courierEnvelope}}");
      debugPrint("=====co_pa3=${{settings!.vehicle.packageLetters}}");
      debugPrint("=====co_pa4=${{settings!.vehicle.courierDocument}}");
      debugPrint("=====co_pa5=${{settings!.vehicle.shoppingBag}}");

      movingOptions = [
        {
          "title": "Package",
          "subtitle": "All package in a box shouldn’t exceed lbs",
          "price": settings!.vehicle.courierPackage ?? "0",
          "qty": 1
        },
        {
          "title": "Envelope",
          "subtitle": "",
          "price": settings!.vehicle.courierEnvelope ?? "0",
          "qty": 1
        },
        {
          "title": "Letter",
          "subtitle": "",
          "price": settings!.vehicle.packageLetters ?? "0",
          "qty": 1
        },
        {
          "title": "Document",
          "subtitle": "",
          "price": settings!.vehicle.courierDocument ?? "0",
          "qty": 1
        },
        {
          "title": "Shopping Bag",
          "subtitle": "No shopping bag should exceed 25 lbs",
          "price": settings!.vehicle.shoppingBag ?? "0",
          "qty": 1
        },
      ];
      selectedIndex = 0;
      loading = false;
    });
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
          child:  Icon(Icons.arrow_back_ios,
              size: 20, color: AppColor.primaryColor),
        ),
        title: Text(
          "Courier Service",
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
        itemCount: movingOptions.length,
          itemBuilder: (_, index) {
            final item = movingOptions[index];
            //bool active = selectedIndex2 == index;
            bool active = selectedIndex == index;
            return GestureDetector(
              onTap: () {
                setState(() => selectedIndex = index);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: active ? AppColor.primaryColor : AppColor.borderColor,
                    width: 1,
                  ),
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
                          child: Image.asset("assets/images/movingHelp.png"),
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
                              fontWeight: FontWeight.w600,
                              color: active ? AppColor.primaryColor : AppColor.primaryColor,
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
                              if (item["qty"] > 1) item["qty"]--;
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                        Text(
                          item["qty"].toString().padLeft(2, "0"),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
                    )
                  ],
                ),
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
                /*onPressed: () {

                  final selectedItem = movingOptions[selectedIndex];

                  int qty = selectedItem["qty"];
                  int price = int.tryParse(selectedItem["price"].toString()) ?? 0;

                  debugPrint("=====co_pa6=${{price}}");

                  setState(() {
                    totalPrice = qty * price;   // same as Kotlin logic
                  });

                  print("PRICE => $totalPrice");  // test output

                  debugPrint("=====co_pa7=${{totalPrice}}");

                  Global.packageList!.add(
                    ItemDTO(
                      categoryName: selectedItem["title"].toString(),
                      subcategory: "",
                      quantity: selectedItem["qty"].toString(),   // 🔥 must be String
                      instruction: "",
                      extraSubcategory: "",
                      price: totalPrice.toString(),               // already String ✔
                    ),
                  );

                  *//*final updatedOrder = widget.orderData!.copyWith(
                    movingType: selectedItem["title"],
                    movingPrice: totalPrice.toString(), // <-- Convert int → String
                  );*//*
                  //Helper.moveToScreenwithPush(context, AddItemsDetailMovingScreen2(orderData: updatedOrder));

                  //Helper.moveToScreenwithPush(context,
                  //  AideDriverScreen(orderData: widget.orderData),
                  //);

                },*/

                onPressed: () {

                  final selectedItem = movingOptions[selectedIndex];

                  int qty = selectedItem["qty"];
                  double price = double.tryParse(selectedItem["price"].toString()) ?? 0.0;

                  setState(() {
                    totalPrice = qty * price;
                  });

                  debugPrint("📌 Qty: $qty  |  Price: $price  |  Total: $totalPrice");

                  Global.packageList.add(
                    ItemDTO(
                      categoryName: selectedItem["title"].toString(),
                      subcategory: "",
                      quantity: qty.toString(),
                      instruction: "",
                      extraSubcategory: "",
                      price: totalPrice.toString(),
                    ),
                  );
                  Helper.moveToScreenwithPush(context,
                    AideDriverScreen(orderData: widget.orderData),
                  );
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