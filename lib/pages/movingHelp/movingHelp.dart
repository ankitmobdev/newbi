import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../SharedPreference/AppSession.dart';
import '../../constant.dart';
import '../../helper_class_snackbar.dart';
import '../../models/OrderData.dart';
import '../../models/SettingsModel.dart';
import '../../services/api_constants.dart';
import 'appliance.dart';

/*class MovingHelpScreen extends StatefulWidget {
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

  Future<SettingsModel?> fetchSettingsDio(String userId) async {
    final dio = Dio();
    try {
      final response = await dio.post(
        BaseURl.baseUrl + ApiAction.getsettings,
        data: {
          "code": ApiCode.kcode,
          "user_id": userId,
        },
        options: Options(
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
        ),
      );

      print('📥 Raw response: ${response.data}');

      // Decode if response is a String
      Map<String, dynamic> jsonData;
      if (response.data is String) {
        jsonData = jsonDecode(response.data);
      } else {
        jsonData = response.data;
      }

      print('📥 Parsed JSON: $jsonData');

      return SettingsModel.fromJson(jsonData);
    } catch (e) {
      print('❌ Dio error: $e');
      return null;
    }
  }

  // ------------------ CALL SETTINGS AND CALCULATE ------------------
  Future<void> callSettingsApi() async {
    //setState(() => _isLoading = true);

    try {
      final settings = await fetchSettingsDio(AppSession().userId);

      if (settings == null) {
        AppSnackBar.error('Failed to fetch settings.');
        return;
      }

      *//*final double finalPrice = calculateTotalPrice(
        settings: settings,
        bookingType: widget.orderData!.bookingType,
        vehicleType: widget.orderData!.vehicleType!,
        numberOfStairs1: double.tryParse(widget.orderData!.stairs1) ?? 0.0,
        numberOfStairs2: double.tryParse(widget.orderData!.stairs2) ?? 0.0,
        aideAndDriver: widget.orderData!.driverAide!,
        distanceInMiles: distanceInMiles,
        movingPrice: movingPrice,
        totalItemPrice: totalItemPrice,
      );

      debugPrint("📦 Final Price: $finalPrice");
      // Update the state to refresh UI
      setState(() {
        totalPrice = finalPrice;
      });*//*

    } catch (e) {
      print('❌ Settings API error: $e');
      AppSnackBar.error('Settings API failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }
}*/

class MovingHelpScreen extends StatefulWidget {
  final OrderData? orderData;
  const MovingHelpScreen({super.key, this.orderData});
  @override
  State<MovingHelpScreen> createState() => _MovingHelpScreenState();
}

class _MovingHelpScreenState extends State<MovingHelpScreen> {

  int selectedIndex = 0; // Default to first card (Studio)
  List<Map<String, dynamic>> movingOptions = [];
  SettingsModel? settings;
  //bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callSettingsApi();
    });
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
      Map<String, dynamic> jsonData = response.data is String ? jsonDecode(response.data) : response.data;
      return SettingsModel.fromJson(jsonData);
    } catch (e) {
      print('❌ Dio error: $e');
      return null;
    }
  }

  Future<void> callSettingsApi() async {
    _showLoader(); // show loading dialog

    try {
      final fetchedSettings = await fetchSettingsDio(AppSession().userId);

      // hide loader
      Navigator.of(context, rootNavigator: true).pop();

      if (fetchedSettings == null || fetchedSettings.vehicle == null) {
        AppSnackBar.error('Failed to fetch settings.');
        return;
      }

      setState(() {
        settings = fetchedSettings;
        movingOptions = [
          {
            "title": "Studio",
            "price":
            "${AppSession().currency == "NGN" ? "₦" : "£"}${settings!.vehicle.studio ?? "0"}",
            "desc":
            "This includes bed (bedframe, mattress, and boxspring), nightstand, dresser and chest of drawers, coffee table + 4 chairs, couch, tv, electronics, a/o bookshelf and up to 7 boxes (books, storage container, suitcase and duffel bags), lamp"
          },
          {
            "title": "1-Bedroom",
            "price":
            "${AppSession().currency == "NGN" ? "₦" : "£"}${settings!.vehicle.bedroom1 ?? "0"}",
            "desc":
            "This includes bed (bedframe, mattress, and boxspring), nightstand, dresser and chest of drawers, coffee table + 4 chairs, couch, tv, electronics, a/o bookshelf and up to 7 boxes (books, storage container, suitcase and duffel bags), lamp"
          },
          {
            "title": "2-Bedroom",
            "price":
            "${AppSession().currency == "NGN" ? "₦" : "£"}${settings!.vehicle.bedroom2 ?? "0"}",
            "desc":
            "This includes bed (bedframe, mattress, and boxspring), nightstand, dresser and chest of drawers, coffee table + 4 chairs, couch, tv, electronics, a/o bookshelf and up to 7 boxes (books, storage container, suitcase and duffel bags), lamp"
          },
        ];
        selectedIndex = 0;
      });
    } catch (e) {
      // hide loader on error also
      Navigator.of(context, rootNavigator: true).pop();
      print("❌ error = $e");
      AppSnackBar.error("Something went wrong!");
    }
  }

  void onNext() {
    if (movingOptions.isEmpty) return;

    final selectedItem = movingOptions[selectedIndex];

    /*final dto = widget.bookDTO ?? BookDTO.Datum();
    dto.movingType = selectedItem["title"];
    dto.movingPrice = selectedItem["price"];

    Helper.moveToScreenwithPush(
      context,
      ApplianceDetailsScreen(bookDTO: dto), // next screen
    );*/

    //if (selectedIndex == null) return;

    final updatedOrder = widget.orderData!.copyWith(
      movingType: selectedItem["title"],
      movingPrice: selectedItem["price"],
    );
    //Helper.moveToScreenwithPush(context, DateTimeScreen(orderData: updatedOrder));

    Helper.moveToScreenwithPush(context, ApplianceDetailsScreen(orderData: updatedOrder, settings: settings));
    // Navigate to next screen

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
    //if (false) return const Center(child: CircularProgressIndicator());

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
                      setState(() => selectedIndex = index);
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
                          Container(
                            height: 38,
                            width: 38,
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
                                  height: 24,
                                  width: 24,
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
                                Text(
                                  item["desc"],
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
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

            GestureDetector(
              onTap: onNext,
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
