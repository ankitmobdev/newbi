import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant.dart';
import '../courierScreens/movingHelpCourier.dart';
import '../furnitureFlow/addItemFurniture.dart';
import '../mapScreens/mapScreen.dart';
import '../movingHelp/movingHelp.dart';
import 'addItemScreen.dart';

class DetailsScreen extends StatefulWidget {
  final String fromScreen; // retail, online, furniture, moving, courier
  const DetailsScreen({super.key, required this.fromScreen});

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

  bool byMe = false;
  bool bySomeoneElse = false;
  bool useStairs1 = false;
  bool useElevators1 = false;
  bool useStairs2 = false;
  bool useElevators2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.8,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgPicture.asset("assets/images/back.svg"),
        ),
        title: Text(
          "Details",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
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
            InkWell(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SelectLocationScreen(),
                  ),
                );

                if (result != null) {
                  setState(() {
                    pickupLocation.text = result["address"];
                  });
                }
              },
              child: boxField("Location", pickupLocation),
            ),

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
            InkWell(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SelectLocationScreen(),
                  ),
                );

                if (result != null) {
                  setState(() {
                    dropLocation.text = result["address"];
                  });
                }
              },
              child: boxField("Location", dropLocation),
            ),

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
          boxField("Purchaser Number", purchaserNumber),
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
          boxField("Seller Number", sellerNumber),
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
          boxField("Purchaser Number", purchaserNumber),
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
          boxField("Sender Number", senderNumber),
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
              setState(() => useStairs1 = v!);
            }),
            labelSmall("Have to Use Staircase"),
          ],
        ),
        const SizedBox(height: 12),

        label("Number of Stairs"),
        SizedBox(height: 5),
        boxField("Number of Stairs", stairs1),
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
              setState(() => useStairs2 = v!);
            }),
            labelSmall("Have to Use Staircase"),
          ],
        ),
        SizedBox(height: 12),

        label("Number of Stairs"),
        SizedBox(height: 5),
        boxField("Number of Stairs", stairs2),
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
        boxField("Number of Stairs", stairs2),
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
        boxField("Receiver Number", receiverNumber),
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
        boxField("Number of Stairs", stairs1),
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
            byMe = v!;
            if (v) bySomeoneElse = false;
          });
        }),
        labelSmall("By Me"),
        const SizedBox(width: 20),
        checkBox(bySomeoneElse, (v) {
          setState(() {
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
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(1, 3),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.poppins(
          color: AppColor.primaryColor,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
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

  // ---------------- NEXT BUTTON ----------------
  Widget nextButton() {
    return GestureDetector(
      onTap: () {
        widget.fromScreen=="furniture"?
        Helper.moveToScreenwithPush(context, AddItemsFurnitureScreen()):widget.fromScreen=="moving"?
        Helper.moveToScreenwithPush(context, MovingHelpScreen()): widget.fromScreen=="courier"?
        Helper.moveToScreenwithPush(context, MovingHelpItemsCourierScreen()):
        Helper.moveToScreenwithPush(context, AddItemsScreen());
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            "Next",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
