import 'package:flutter/material.dart';
import 'package:go_eat_e_commerce_app/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../SharedPreference/AppSession.dart';
import '../../models/Global.dart';
import '../../models/ItemDTO.dart';
import '../../models/OrderData.dart';
import '../../models/SettingsModel.dart';
import '../retailScreenFlow/addItem3.dart';

class ApplianceDetailsScreen extends StatefulWidget {
  final OrderData? orderData;
  final SettingsModel? settings;
  const ApplianceDetailsScreen({super.key, this.orderData, this.settings});
  @override
  State<ApplianceDetailsScreen> createState() => _ApplianceDetailsScreenState();
}

class _ApplianceDetailsScreenState extends State<ApplianceDetailsScreen> {
  bool yes = false;
  bool no = false;
  int selectedIndex = -1;

  late List<Map<String, dynamic>> applianceList;

  @override
  void initState() {
    super.initState();

    final vehicle = widget.settings?.vehicle;

    applianceList = [
      {"name": "Dishwasher", "price": vehicle?.dishwasher ?? 0},
      {"name": "Refrigerator", "price": vehicle?.refrigerator ?? 0},
      {"name": "Washer", "price": vehicle?.washer ?? 0},
      {"name": "Dryer", "price": vehicle?.dryer ?? 0},
      {"name": "Oven", "price": vehicle?.oven ?? 0},
      {"name": "Other", "price": vehicle?.other ?? 0},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.8,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
        title: Text(
          "Details",
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColor.primaryColor,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // TITLE
            Text(
              "I have appliance large to move:",
              style: GoogleFonts.poppins(
                fontSize: 14,fontWeight: FontWeight.w400,
                color: AppColor.primaryColor,
              ),
            ),

            const SizedBox(height: 10),

            // YES / NO ROW
            Row(
              children: [
                checkBox(yes, (v) {
                  setState(() {
                    yes = v!;
                    if (yes) no = false;
                  });
                }),
                Text("Yes", style: GoogleFonts.poppins(fontSize: 14)),
                const SizedBox(width: 20),
                checkBox(no, (v) {
                  setState(() {
                    no = v!;
                    if (no) yes = false;
                  });
                }),
                Text("NO", style: GoogleFonts.poppins(fontSize: 14)),
              ],
            ),

            const SizedBox(height: 10),

            // ---------------- APPLIANCE LIST ----------------
            if (yes)
              Expanded(
                child: ListView.builder(
                  itemCount: applianceList.length,
                  itemBuilder: (context, index) {
                    final item = applianceList[index];

                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() => selectedIndex = index);

                            debugPrint("=====cb_0=$yes");

                            // Add movingType item only once
                            if (Global.packageList != null && Global.packageList!.isEmpty) {
                              if ((widget.orderData?.movingType ?? "").isNotEmpty) {
                                Global.packageList!.add(
                                  ItemDTO(
                                    categoryName: widget.orderData!.movingType!,
                                    subcategory: "Includes:",
                                    quantity: "1",
                                    instruction: "",
                                    extraSubcategory: "",
                                    price: "0",
                                  ),
                                );
                              }
                            }

                            // Add selected appliance only when YES is selected
                            if (yes) {
                              Global.packageList!.add(
                                ItemDTO(
                                  categoryName: item["name"],      // DYNAMIC NAME
                                  subcategory: "",
                                  quantity: "1",
                                  instruction: "",
                                  extraSubcategory: "",
                                  price: item["price"].toString(), // DYNAMIC PRICE
                                ),
                              );
                            }

                            // Navigate
                            Helper.moveToScreenwithPush(
                              context,
                              AddItemsSummaryScreen(orderData: widget.orderData),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                // RADIO BUTTON
                                Icon(
                                  selectedIndex == index
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  color: selectedIndex == index
                                      ? Colors.black
                                      : AppColor.borderColor,
                                  size: 22,
                                ),
                                const SizedBox(width: 10),

                                // APPLIANCE NAME
                                Expanded(
                                  child: Text(
                                    item["name"],
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                ),

                                // PRICE
                                Text(
                                  "${AppSession().currency == "NGN" ? "₦" : "£"}${item["price"]}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.secondprimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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

  // ---------- CHECKBOX (YES/NO STYLE) ----------
  Widget checkBox(bool value, Function(bool?) onChanged) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      activeColor: AppColor.primaryColor,
      side:  BorderSide(color: AppColor.borderColor, width: 1.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    );
  }
}
