import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_eat_e_commerce_app/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../SharedPreference/AppSession.dart';
import '../../helper_class_snackbar.dart';
import '../../models/Global.dart';
import '../../models/ItemDTO.dart';
import '../../models/OrderData.dart';
import '../../models/SettingsModel.dart';
import '../../services/api_constants.dart';
import 'addItem3.dart';

class AddItemsDetailScreen extends StatefulWidget {
  final String? itemName;
  final OrderData? orderData;
  const AddItemsDetailScreen({super.key, this.itemName, this.orderData});
  @override
  State<AddItemsDetailScreen> createState() => _AddItemsDetailScreenState();
}

class _AddItemsDetailScreenState extends State<AddItemsDetailScreen> {

  final TextEditingController description = TextEditingController();

  int qty = 1;
  bool isChecked = false;
  bool isProfileFromApi = false;
  XFile? profileImage;

  double small = 0;
  double medium = 0;
  double large = 0;
  double xlarge = 0;

  String type = "small";

  SettingsModel? settings;

  @override
  void initState() {
    super.initState();

    if (widget.itemName != null) {
      if (widget.itemName!.contains("Small")) {
        type = "small";
      } else if (widget.itemName!.contains("Medium")) {
        type = "medium";
      } else if (widget.itemName!.contains("Large")) {
        type = "large";
      } else if (widget.itemName!.contains("X-Large")) {
        type = "xlarge";
      }
    }

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

      // Check booking type and assign accordingly
      if (widget.orderData!.bookingType != null && widget.orderData!.bookingType == "RetailStore") {
        small = settings!.vehicle.retailStoreSmall;
        medium = settings!.vehicle.retailStoreMedium;
        large = settings!.vehicle.retailStoreLarge;
        xlarge = settings!.vehicle.retailStoreXLarge;
      } else {
        small = settings!.vehicle.onlineMarketSmall;
        medium = settings!.vehicle.onlineMarketMedium;
        large = settings!.vehicle.onlineMarketLarge;
        xlarge = settings!.vehicle.onlineMarketXLarge;
      }

      debugPrint("=====small=$small, medium=$medium, large=$large, xlarge=$xlarge");
    });
  }

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

      // ----------------- BODY -----------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ----------------- SEARCH BOX -----------------
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black12, width: 0.7),
              ),
              child: Row(
                children: [
                  SvgPicture.asset("assets/images/search_3_line.svg"),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: widget.itemName,
                        hintStyle: GoogleFonts.poppins(
                          color: AppColor.textclr,
                          fontSize: 16,fontWeight: FontWeight.w400
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // ----------------- QUANTITY -----------------
            Container(
              decoration: BoxDecoration(
                color: AppColor.secondaryColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(1, 3),
                  )
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "How Many?",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        // Minus Button
                        _qtyButton(
                          icon: Icons.remove,
                          onTap: () {
                            setState(() {
                              if (qty > 1) qty--;
                            });
                          },
                        ),
                        const SizedBox(width: 10),
                        // Quantity Number
                        Container(
                          height: 38,
                          width: 38,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black12),
                          ),
                          child: Center(
                            child: Text(
                              qty.toString().padLeft(2, '0'),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Plus Button
                        _qtyButton(
                          icon: Icons.add,
                          onTap: () {
                            setState(() {
                              qty++;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ----------------- CHECKBOX -----------------
            Row(
              children: [
                Checkbox(
                  activeColor: Colors.black,
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value ?? false;
                    });
                  },
                ),
                Text(
                  "Request Breakdown to Move",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ----------------- DESCRIPTION -----------------
            Container(
              height: 120,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColor.borderColor),
              ),
              child: TextField(
                controller: description,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: GoogleFonts.poppins(
                    color: AppColor.textclr,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),

            //const SizedBox(height: 20),

            // ----------------- UPLOAD BOX -----------------
            /*Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.shade300,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  showImagePicker();
                },
                child: profileImage == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/images/photo_album_2_fill.svg"),
                    const SizedBox(height: 10),
                    Text(
                      "Upload Your Image",
                      style: GoogleFonts.poppins(
                        color: AppColor.textclr,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: isProfileFromApi ? FadeInImage.assetNetwork(
                    placeholder: "assets/images/photo_album_2_fill.svg",
                    image: profileImage!.path,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                  )
                      : Image.file(
                    File(profileImage!.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                  ),
                ),
              ),
            ),*/

            const SizedBox(height: 40),

            // ----------------- NEXT BUTTON -----------------
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  int qtyValue = qty;
                  double price = 0;

                  // ------------------ SAME LOGIC AS YOUR KOTLIN CODE ------------------
                  if (type == "small") {
                    price = small * qtyValue;
                  } else if (type == "medium") {
                    price = medium * qtyValue;
                  } else if (type == "large") {
                    price = large * qtyValue;
                  } else if (type == "xlarge") {
                    price = xlarge * qtyValue;
                  }

                  debugPrint("=====price_ca_0=${type}");
                  debugPrint("=====price_ca_1=${qtyValue}");
                  debugPrint("=====price_ca_2=${price}");

                  // CREATE ITEM OBJECT
                  ItemDTO itemDTO = ItemDTO(
                    categoryName: widget.itemName,
                    subcategory: "",
                    quantity: qtyValue.toString(),
                    instruction: description.text,
                    extraSubcategory: "",
                    price: price.toString(),
                  );

                  // ---------- ADD TO GLOBAL LIST (same as Global.packageList.add(itemDTO)) ----------
                  Global.packageList.add(itemDTO);

                  String json = jsonEncode(Global.packageList.map((item) => {
                    "categoryName": item.categoryName,
                    "subcategory": item.subcategory,
                    "quantity": item.quantity,
                    "instruction": item.instruction,
                    "extraSubcategory": item.extraSubcategory,
                    "price": item.price,
                  }).toList());

                  debugPrint("📦 package_list_json1: $json");

                  // ---------- MOVE TO SUMMARY SCREEN ----------
                  Helper.moveToScreenwithPush(
                    context,
                    AddItemsSummaryScreen(orderData: widget.orderData),
                  );
                },
                child: Text(
                  "Add",
                  style: GoogleFonts.poppins(fontSize: 16,color: AppColor.secondaryColor,),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ----------------- QUANTITY BUTTON REUSABLE -----------------
  Widget _qtyButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          color: AppColor.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColor.secondaryColor),
      ),
    );
  }

  // Image pickers - when user picks an image, mark source as local (not API)
  Future<XFile?> pickFromCamera() async {
    return await ImagePicker().pickImage(source: ImageSource.camera);
  }

  Future<XFile?> pickFromGallery() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  void showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () async {
                  Navigator.pop(context);
                  final img = await pickFromCamera();
                  if (img != null) {
                    setState(() {
                      profileImage = img;
                      isProfileFromApi = false;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  final img = await pickFromGallery();
                  if (img != null) {
                    setState(() {
                      profileImage = img;
                      isProfileFromApi = false;
                    });
                  }
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text("Cancel"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

}
