import 'package:flutter/material.dart';
import 'package:go_eat_e_commerce_app/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import '../drawerScreen/drawerScreen.dart';
import '../retailScreenFlow/fillDetailScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String bookingType = "";

  @override
  void initState() {
    super.initState();

    debugPrint("=====screen=${bookingType}");

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomSideBar(),
      backgroundColor: const Color(0xffF4F4F4),

      // -------------------- APPBAR --------------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          "Home",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // -------------------- BODY --------------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Helper.moveToScreenwithPush(
                  context,
                  DetailsScreen(fromScreen: "retail", bookingType: "RetailStore"),
                );
              },
              child: buildServiceTile(
                icon: "assets/images/retail.png",
                title: "Retail Store",
              ),
            ),
            const SizedBox(height: 14),

            InkWell(
              onTap: () {
                Helper.moveToScreenwithPush(
                  context,
                  DetailsScreen(fromScreen: "online", bookingType: "OnlineMarket"),
                );
              },
              child: buildServiceTile(
                icon: "assets/images/online.png",
                title: "Online Market",
              ),
            ),
            const SizedBox(height: 14),

            InkWell(
              onTap: () {
                Helper.moveToScreenwithPush(
                  context,
                  DetailsScreen(fromScreen: "furniture", bookingType: "FurnitureDelivery"),
                );
              },
              child: buildServiceTile(
                icon: "assets/images/furniture.png",
                title: "Furniture Delivery",
              ),
            ),
            const SizedBox(height: 14),

            InkWell(
              onTap: () {
                Helper.moveToScreenwithPush(
                  context,
                  DetailsScreen(fromScreen: "moving", bookingType: "MovingHelp"),
                );
              },
              child: buildServiceTile(
                icon: "assets/images/moving.png",
                title: "Moving Help",
              ),
            ),
            const SizedBox(height: 14),

            InkWell(
              onTap: () {
                Helper.moveToScreenwithPush(
                  context,
                  DetailsScreen(fromScreen: "courier", bookingType: "CourierService"),
                );
              },
              child: buildServiceTile(
                icon: "assets/images/courier.png",
                title: "Courier Service",
              ),
            ),
          ],
        ),
      ),
    );
  }



  // ---------------------------------------------------
  // SERVICE TILE WIDGET
  // ---------------------------------------------------
  Widget buildServiceTile({required String icon, required String title}) {
    return Container(
      padding: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Center(
            child: Image.asset(
              icon,
              width: 67,
              height: 90,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColor.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: AppColor.primaryColor,
          ),
        ],
      ),
    );
  }
}
