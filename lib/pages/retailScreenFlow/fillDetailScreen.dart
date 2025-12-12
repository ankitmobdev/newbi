import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant.dart';
import '../../helper_class_snackbar.dart';
import '../../models/Global.dart';
import '../../models/OrderData.dart';
import '../courierScreens/movingHelpCourier.dart';
import '../furnitureFlow/addItemFurniture.dart';
import '../mapScreens/mapScreen.dart';
import '../movingHelp/movingHelp.dart';
import 'addItemScreen.dart';

class DetailsScreen extends StatefulWidget {
  final String fromScreen; // retail, online, furniture, moving, courier
  final String bookingType;
  const DetailsScreen({super.key, required this.fromScreen, required this.bookingType});
  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  // CONTROLLERS
  final TextEditingController pickupLocation = TextEditingController();
  final TextEditingController storeOrSellerName = TextEditingController();
  final TextEditingController sellerNumber = TextEditingController();
  final TextEditingController purchaserName = TextEditingController();
  final TextEditingController purchaserNumber = TextEditingController();
  final TextEditingController senderName = TextEditingController();
  final TextEditingController senderNumber = TextEditingController();
  final TextEditingController receiverName = TextEditingController();
  final TextEditingController receiverNumber = TextEditingController();
  final TextEditingController dropLocation = TextEditingController();
  final TextEditingController unit1 = TextEditingController();
  final TextEditingController stairs1 = TextEditingController();
  final TextEditingController unit2 = TextEditingController();
  final TextEditingController stairs2 = TextEditingController();

  String? locationAddress;
  String? pickupLatitude;
  String? pickupLongitude;

  String? dropLatitude;
  String? dropLongitude;

  bool byMe = false;
  bool bySomeoneElse = false;
  bool useStairs1 = false;
  bool useElevators1 = false;
  bool useStairs2 = false;
  bool useElevators2 = false;

  String purchasedBy = "";
  String useStairs1Status = "0";
  String useStairs2Status = "0";

  String useElevators1Status = "0";
  String useElevators2Status = "0";

  @override
  void initState() {
    super.initState();
    Global.packageList.clear();
    debugPrint("=====screen=${widget.fromScreen}");
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
          "Details",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColor.primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- PICKUP LOCATION ----------------
            label("Pickup Location"),
            SizedBox(height: 5),
            boxField("Location", pickupLocation),

            const SizedBox(height: 16),

            // RETAIL / ONLINE / COURIER ONLY
            if (widget.fromScreen == "retail" ||
                widget.fromScreen == "online" ||
                widget.fromScreen == "courier")
              buildRetailOnlineCourierTop(),

            // ---------------- FURNITURE / MOVING PICKUP DETAILS ----------------
            if (widget.fromScreen == "furniture" ||
                widget.fromScreen == "moving")
              buildPickupBlockFurnitureMoving(),

            const SizedBox(height: 16),

            // ---------------- DROP OFF LOCATION ----------------
            label("Drop Off Location"),
            SizedBox(height: 5),
            boxField("Location", dropLocation),

            const SizedBox(height: 16),

            // ---------------- DROP-OFF DETAILS ----------------
            if (widget.fromScreen == "retail" ||
                widget.fromScreen == "online")
              buildDropBlockRetailOnline(),

            if (widget.fromScreen == "furniture" ||
                widget.fromScreen == "moving")
              buildDropBlockFurnitureMoving(),

            if (widget.fromScreen == "courier")
              buildDropCourier(),

            const SizedBox(height: 20),

            // ---------------- NEXT BUTTON ----------------
            nextButton(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // ----------------------- RETAIL / ONLINE / COURIER BLOCKS -----------------------
  Widget buildRetailOnlineCourierTop() {
    if (widget.fromScreen == "retail") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label("Store Name"),
          SizedBox(height: 5),
          boxField("Store Name", storeOrSellerName),
          const SizedBox(height: 16),

          label("Item Purchased By"),
          const SizedBox(height: 6),
          buildByMeRow(),
          const SizedBox(height: 16),

          label("Purchaser Name"),
          SizedBox(height: 5),
          boxField("Purchaser Name", purchaserName),
          const SizedBox(height: 16),

          label("Purchaser Number"),
          SizedBox(height: 5),
          boxFieldStairs("Purchaser Number", purchaserNumber),
        ],
      );
    }

    if (widget.fromScreen == "online") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label("Seller Name"),
          SizedBox(height: 5),
          boxField("Seller Name", storeOrSellerName),
          const SizedBox(height: 16),

          label("Seller Number"),
          SizedBox(height: 5),
          boxFieldStairs("Seller Number", sellerNumber),
          const SizedBox(height: 16),

          label("Item Purchased By"),
          const SizedBox(height: 6),
          buildByMeRow(),
          const SizedBox(height: 16),

          label("Purchaser Name"),
          SizedBox(height: 5),
          boxField("Purchaser Name", purchaserName),
          const SizedBox(height: 16),

          label("Purchaser Number"),
          SizedBox(height: 5),
          boxFieldStairs("Purchaser Number", purchaserNumber),
        ],
      );
    }

    if (widget.fromScreen == "courier") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label("Sender Name"),
          SizedBox(height: 5),
          boxField("Sender Name", senderName),
          const SizedBox(height: 16),

          label("Sender Number"),
          SizedBox(height: 5),
          boxFieldStairs("Sender Number", senderNumber),
        ],
      );
    }
    return SizedBox();
  }

  // ----------------------- FURNITURE / MOVING PICKUP BLOCK -----------------------
  Widget buildPickupBlockFurnitureMoving() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label("Unit or Apartment"),
        SizedBox(height: 5),
        boxField("Unit or Apartment", unit1),
        const SizedBox(height: 16),
        Row(
          children: [
            checkBox(useStairs1, (v) {
              setState(() {
                useStairs1 = v!;
                useStairs1Status = useStairs1 ? "1" : "0";  // <-- Like Kotlin code
                debugPrint("useStairs1Status: $useStairs1Status");
              });
            }),
            labelSmall("Have to Use Staircase"),
          ],
        ),
        const SizedBox(height: 12),

        label("Number of Stairs"),
        SizedBox(height: 5),
        boxFieldStairs("Number of Stairs", stairs1),
        const SizedBox(height: 16),

        Row(
          children: [
            checkBox(useElevators1, (v) {
              setState(() {
                useElevators1 = v!;
                useElevators1Status = useElevators1 ? "1" : "0";
                print("useElevators1Status: $useElevators1Status");
              });
            }),
            labelSmall("Can Use Elevators"),
          ],
        ),
      ],
    );
  }

  // ----------------------- DROPOFF FOR RETAIL/ONLINE -----------------------
  Widget buildDropBlockRetailOnline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label("Unit or Apartment"),
        SizedBox(height: 5),
        boxField("Unit or Apartment", unit2),
        SizedBox(height: 16),
        Row(
          children: [
            checkBox(useStairs2, (v) {
              setState(() {
                useStairs2 = v!;
                useStairs2Status = useStairs2 ? "1" : "0";
                print("useStairs2Status: $useStairs2Status");
              });
            }),
            labelSmall("Have to Use Staircase"),
          ],
        ),
        SizedBox(height: 12),

        label("Number of Stairs"),
        SizedBox(height: 5),
        boxFieldStairs("Number of Stairs", stairs2),
        SizedBox(height: 16),

        Row(
          children: [
            checkBox(useElevators2, (v) {
              setState(() {
                useElevators2 = v!;
                useElevators2Status = useElevators2 ? "1" : "0";
                print("useElevators2Status: $useElevators2Status");
              });
            }),
            labelSmall("Can Use Elevators"),
          ],
        ),
      ],
    );
  }

  // ----------------------- DROPOFF FOR FURNITURE/MOVING -----------------------
  Widget buildDropBlockFurnitureMoving() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label("Unit or Apartment"),
        SizedBox(height: 5),
        boxField("Unit or Apartment", unit2),
        SizedBox(height: 16),

        Row(
          children: [
            checkBox(useStairs2, (v) {
              setState(() => useStairs2 = v!);
            }),
            labelSmall("Have to Use Staircase"),
          ],
        ),
        SizedBox(height: 12),

        label("Number of Stairs"),
        SizedBox(height: 5),
        boxFieldStairs("Number of Stairs", stairs2),
        SizedBox(height: 16),

        Row(
          children: [
            checkBox(useElevators2, (v) {
              setState(() => useElevators2 = v!);
            }),
            labelSmall("Can Use Elevators"),
          ],
        ),
      ],
    );
  }

  // ----------------------- COURIER DROPOFF -----------------------
  Widget buildDropCourier() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label("Receiver Name"),
        SizedBox(height: 5),
        boxField("Receiver Name", receiverName),
        const SizedBox(height: 16),

        label("Receiver Number"),
        SizedBox(height: 5),
        boxFieldStairs("Receiver Number", receiverNumber),
        const SizedBox(height: 16),

        label("Unit or Apartment"),
        SizedBox(height: 5),
        boxField("Unit or Apartment", unit1),
        const SizedBox(height: 16),

        Row(
          children: [
            checkBox(useStairs1, (v) {
              setState(() => useStairs1 = v!);
            }),
            labelSmall("Have to Use Staircase"),
          ],
        ),
        const SizedBox(height: 12),

        label("Number of Stairs"),
        SizedBox(height: 5),
        boxFieldStairs("Number of Stairs", stairs1),
        const SizedBox(height: 16),

        Row(
          children: [
            checkBox(useElevators1, (v) {
              setState(() => useElevators1 = v!);
            }),
            labelSmall("Can Use Elevators"),
          ],
        ),
      ],
    );
  }

  // ----------------------- BY ME ROW -----------------------
  Widget buildByMeRow() {
    return Row(
      children: [
        checkBox(byMe, (v) {
          setState(() {
            purchasedBy = "1";
            debugPrint("📦 purchasedBy: ${purchasedBy}");
            byMe = v!;
            if (v) bySomeoneElse = false;
          });
        }),
        labelSmall("By Me"),
        const SizedBox(width: 20),
        checkBox(bySomeoneElse, (v) {
          setState(() {
            purchasedBy = "2";
            debugPrint("📦 purchasedBy: ${purchasedBy}");
            bySomeoneElse = v!;
            if (v) byMe = false;
          });
        }),
        labelSmall("Someone Else"),
      ],
    );
  }

  // ---------------- LABEL ----------------
  Widget label(String text) {
    return Text(text,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: AppColor.primaryColor,
          fontWeight: FontWeight.w500,
        ));
  }

  // ---------------- SMALL LABEL ----------------
  Widget labelSmall(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: AppColor.primaryColor,
        fontSize: 15,
      ),
    );
  }

  // ---------------- TEXT FIELD ----------------
  Widget boxField(String hint, TextEditingController controller) {
    final isLocationField =
        controller == pickupLocation || controller == dropLocation;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(1, 3),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: isLocationField,   // 🔥 only pickup/drop are read-only
        onTap: () {
          if (controller == pickupLocation) {
            Helper.moveToScreenwithPush(
              context,
              LocationWidget(
                callback: (String location, double latitude, double longitude) {
                  setState(() {
                    pickupLocation.text = location;
                    pickupLatitude = latitude.toString();
                    pickupLongitude = longitude.toString();
                  });
                },
              ),
            );
          } else if (controller == dropLocation) {
            Helper.moveToScreenwithPush(
              context,
              LocationWidget(
                callback: (String location, double latitude, double longitude) {
                  setState(() {
                    dropLocation.text = location;
                    dropLatitude = latitude.toString();
                    dropLongitude = longitude.toString();
                  });
                },
              ),
            );
          }
        },
        style: GoogleFonts.poppins(
          color: AppColor.primaryColor,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          hintText: hint,
          border: InputBorder.none,
          hintStyle: GoogleFonts.poppins(
            color: AppColor.textclr,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget boxFieldStairs(String hint, TextEditingController controller) {
    final isLocationField =
        controller == pickupLocation || controller == dropLocation;
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(1, 3),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: isLocationField,   // 🔥 only pickup/drop are read-only
        keyboardType: isLocationField
            ? TextInputType.text
            : TextInputType.number,
        onTap: () {
          if (controller == pickupLocation) {
            Helper.moveToScreenwithPush(
              context,
              LocationWidget(
                callback: (String location, double latitude, double longitude) {
                  setState(() {
                    pickupLocation.text = location;
                    pickupLatitude = latitude.toString();
                    pickupLongitude = longitude.toString();
                  });
                },
              ),
            );
          } else if (controller == dropLocation) {
            Helper.moveToScreenwithPush(
              context,
              LocationWidget(
                callback: (String location, double latitude, double longitude) {
                  setState(() {
                    dropLocation.text = location;
                    dropLatitude = latitude.toString();
                    dropLongitude = longitude.toString();
                  });
                },
              ),
            );
          }
        },
        style: GoogleFonts.poppins(
          color: AppColor.primaryColor,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
          hintText: hint,
          border: InputBorder.none,
          hintStyle: GoogleFonts.poppins(
            color: AppColor.textclr,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // ---------------- CHECKBOX ----------------
  Widget checkBox(bool value, Function(bool?) onChanged) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      activeColor: Colors.black,
      side: const BorderSide(color: Colors.black, width: 1.2),
    );
  }

  Widget nextButton() {
    return ElevatedButton(
      onPressed: () {
        print("🔹 Next button pressed");
        print("pickupLocation: ${pickupLocation.text}, lat: $pickupLatitude, long: $pickupLongitude");
        print("storeOrSellerName: ${storeOrSellerName.text}");

        // ------------------- VALIDATION -------------------
        if (pickupLocation.text.isEmpty || pickupLatitude == null || pickupLongitude == null) {
          AppSnackBar.error1(context, "Please enter Pickup Location");
          print("❌ Pickup Location validation failed");
          return;
        }

        if ((widget.fromScreen == "retail" || widget.fromScreen == "online") &&
            storeOrSellerName.text.isEmpty) {
          AppSnackBar.error1(context, "Please enter Store/Seller Name");
          print("❌ Store/Seller Name validation failed");
          return;
        }

        if (widget.fromScreen == "online" && sellerNumber.text.isEmpty) {
          AppSnackBar.error1(context, "Please enter Seller Number");
          print("❌ Seller Number validation failed");
          return;
        }

        if ((widget.fromScreen == "retail" || widget.fromScreen == "online") &&
            purchaserName.text.isEmpty) {
          AppSnackBar.error1(context, "Please enter Purchaser Name");
          print("❌ Purchaser Name validation failed");
          return;
        }

        if ((widget.fromScreen == "retail" || widget.fromScreen == "online") &&
            purchaserNumber.text.isEmpty) {
          AppSnackBar.error1(context, "Please enter Purchaser Number");
          print("❌ Purchaser Number validation failed");
          return;
        }

        if (widget.fromScreen == "courier") {
          if (senderName.text.isEmpty) {
            AppSnackBar.error1(context, "Please enter Sender Name");
            print("❌ Sender Name validation failed");
            return;
          }
          if (senderNumber.text.isEmpty) {
            AppSnackBar.error1(context, "Please enter Sender Number");
            print("❌ Sender Number validation failed");
            return;
          }
        }

        if (dropLocation.text.isEmpty || dropLatitude == null || dropLongitude == null) {
          AppSnackBar.error1(context, "Please enter Drop Location");
          print("❌ Drop Location validation failed");
          return;
        }
        print("❌ Unit1 validation res ${unit1.text.isEmpty}");
        print("❌ Unit1 validation res ${unit1.text}");
        // if (unit1.text.isEmpty) {
        //   AppSnackBar.error1(context, "Please enter Unit/Apartment");
        //   print("❌ Unit1 validation failed");
        //   return;
        // }

        if ((widget.fromScreen == "furniture" || widget.fromScreen == "moving") &&
            stairs1.text.isEmpty) {
          AppSnackBar.error1(context, "Please enter Number of Stairs");
          print("❌ Stairs1 validation failed");
          return;
        }

        // if (unit2.text.isEmpty) {
        //   AppSnackBar.error1(context, "Please enter Unit/Apartment for Drop-off");
        //   print("❌ Unit2 validation failed");
        //   return;
        // }

        if ((widget.fromScreen == "furniture" || widget.fromScreen == "moving") &&
            stairs2.text.isEmpty) {
          AppSnackBar.error1(context, "Please enter Number of Stairs for Drop-off");
          print("❌ Stairs2 validation failed");
          return;
        }

        if (widget.fromScreen == "courier") {
          if (receiverName.text.isEmpty) {
            AppSnackBar.error1(context, "Please enter Receiver Name");
            print("❌ Receiver Name validation failed");
            return;
          }
          if (receiverNumber.text.isEmpty) {
            AppSnackBar.error1(context, "Please enter Receiver Number");
            print("❌ Receiver Number validation failed");
            return;
          }
        }

        // Optional: check "by me/by someone else"
        if ((widget.fromScreen == "retail" || widget.fromScreen == "online") &&
            purchasedBy.isEmpty) {
          AppSnackBar.error1(context, "Please select who purchased the item");
          print("❌ purchasedBy validation failed");
          return;
        }

        // ------------------- NAVIGATION -------------------
        print("✅ All validation passed. Navigating...");

        if (widget.fromScreen == "furniture") {
          Helper.moveToScreenwithPush(context,
              AddItemsFurnitureScreen(
                orderData: OrderData(
                  bookingType: widget.bookingType,
                  pickupLocation: pickupLocation.text,
                  storeOrSellerName: storeOrSellerName.text,
                  sellerNumber: sellerNumber.text,
                  purchaserName: purchaserName.text,
                  purchaserNumber: purchaserNumber.text,
                  senderName: senderName.text,
                  senderNumber: senderNumber.text,
                  receiverName: receiverName.text,
                  receiverNumber: receiverNumber.text,
                  dropLocation: dropLocation.text,
                  unit1: unit1.text,
                  stairs1status: useStairs1Status,
                  stairs1: stairs1.text,
                  unit2: unit2.text,
                  stairs2status: useStairs2Status,
                  stairs2: stairs2.text,
                  purchasedBy: purchasedBy,
                  elevators: useElevators1Status,
                  elevators2: useElevators2Status,
                  pickupLatitude: pickupLatitude!,
                  pickupLongitude: pickupLongitude!,
                  dropLatitude: dropLatitude!,
                  dropLongitude: dropLongitude!,
                ),
              ));
        } else if (widget.fromScreen == "moving") {
          Helper.moveToScreenwithPush(context,
              MovingHelpScreen(
                orderData: OrderData(
                  bookingType: widget.bookingType,
                  pickupLocation: pickupLocation.text,
                  storeOrSellerName: storeOrSellerName.text,
                  sellerNumber: sellerNumber.text,
                  purchaserName: purchaserName.text,
                  purchaserNumber: purchaserNumber.text,
                  senderName: senderName.text,
                  senderNumber: senderNumber.text,
                  receiverName: receiverName.text,
                  receiverNumber: receiverNumber.text,
                  dropLocation: dropLocation.text,
                  unit1: unit1.text,
                  stairs1status: useStairs1Status,
                  stairs1: stairs1.text,
                  unit2: unit2.text,
                  stairs2status: useStairs2Status,
                  stairs2: stairs2.text,
                  purchasedBy: purchasedBy,
                  elevators: useElevators1Status,
                  elevators2: useElevators2Status,
                  pickupLatitude: pickupLatitude!,
                  pickupLongitude: pickupLongitude!,
                  dropLatitude: dropLatitude!,
                  dropLongitude: dropLongitude!,
                ),
              ));
        } else if (widget.fromScreen == "courier") {
          Helper.moveToScreenwithPush(context,
              MovingHelpItemsCourierScreen(
                orderData: OrderData(
                  bookingType: widget.bookingType,
                  pickupLocation: pickupLocation.text,
                  storeOrSellerName: storeOrSellerName.text,
                  sellerNumber: sellerNumber.text,
                  purchaserName: purchaserName.text,
                  purchaserNumber: purchaserNumber.text,
                  senderName: senderName.text,
                  senderNumber: senderNumber.text,
                  receiverName: receiverName.text,
                  receiverNumber: receiverNumber.text,
                  dropLocation: dropLocation.text,
                  unit1: unit1.text,
                  stairs1status: useStairs1Status,
                  stairs1: stairs1.text,
                  unit2: unit2.text,
                  stairs2status: useStairs2Status,
                  stairs2: stairs2.text,
                  purchasedBy: purchasedBy,
                  elevators: useElevators1Status,
                  elevators2: useElevators2Status,
                  pickupLatitude: pickupLatitude!,
                  pickupLongitude: pickupLongitude!,
                  dropLatitude: dropLatitude!,
                  dropLongitude: dropLongitude!,
                ),
              ));
        } else {
          Helper.moveToScreenwithPush(
            context,
            AddItemsScreen(
              orderData: OrderData(
                bookingType: widget.bookingType,
                pickupLocation: pickupLocation.text,
                storeOrSellerName: storeOrSellerName.text,
                sellerNumber: sellerNumber.text,
                purchaserName: purchaserName.text,
                purchaserNumber: purchaserNumber.text,
                senderName: senderName.text,
                senderNumber: senderNumber.text,
                receiverName: receiverName.text,
                receiverNumber: receiverNumber.text,
                dropLocation: dropLocation.text,
                unit1: unit1.text,
                stairs1status: useStairs1Status,
                stairs1: stairs1.text,
                unit2: unit2.text,
                stairs2status: useStairs2Status,
                stairs2: stairs2.text,
                purchasedBy: purchasedBy,
                elevators: useElevators1Status,
                elevators2: useElevators2Status,
                pickupLatitude: pickupLatitude!,
                pickupLongitude: pickupLongitude!,
                dropLatitude: dropLatitude!,
                dropLongitude: dropLongitude!,
              ),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        "Next",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

}
