import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_eat_e_commerce_app/pages/drawerScreen/profile.dart';
import 'package:go_eat_e_commerce_app/pages/drawerScreen/termsAndCondition.dart';
import 'package:go_eat_e_commerce_app/pages/drawerScreen/wallet.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constant.dart';
import '../../drawerScreen/currentServices.dart';
import '../../drawerScreen/helpScreen.dart';
import '../../homeScreen/homeScreen.dart';
import '../driverHomeScreen/driverHomeScreen.dart';
import 'availableDeliveries.dart';


class DriverCustomSideBar extends StatelessWidget {
  const DriverCustomSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(30),
      ),
      child: Drawer(
        backgroundColor: AppColor.secondaryColor,
        width: MediaQuery.of(context).size.width * 0.78,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---------------- HEADER ----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColor.primaryColor,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),bottomRight: Radius.circular(30)
                ),
              ),
              child: Row(
                children: [
                  // profile image
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      image: DecorationImage(
                        image: AssetImage("assets/images/profile.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // name & phone
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Adam Justin",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "+91 88855 - 64565",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ---------------- MENU ITEMS ----------------
            InkWell(
                onTap: () {
                  Helper.moveToScreenwithPush(context, DriverHomeScreen());
                },
                child: _menuTile("Home", "assets/images/home.svg")),
            InkWell(
                onTap: () {
                  Helper.moveToScreenwithPush(context, AvailableDeliveriesScreen());
                },
                child: _menuTile("Your Trips", "assets/images/truck.svg")),
            _menuTile("History Service", "assets/images/historyService.svg"),
            InkWell(
                onTap: () {
                  Helper.moveToScreenwithPush(context, ProfileScreen());
                },
                child: _menuTile("Profile", "assets/images/profile.svg")),
            InkWell(
                onTap: () {
                  Helper.moveToScreenwithPush(context, WalletScreen());
                },
                child: _menuTile("Wallet", "assets/images/wallet.svg")),
            InkWell(
                onTap: () {
                  Helper.moveToScreenwithPush(context, TermOfServiceScreen());
                },

                child: _menuTile("Faq", "assets/images/faq.svg")),
            _menuTile("About", "assets/images/about.svg"),

            InkWell(
                onTap: () {
                  Helper.moveToScreenwithPush(context, HelpScreen());
                },
                child: _menuTile("Help", "assets/images/help.svg")),

            const Spacer(),

            // ---------------- LOGOUT ----------------
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 30),
              child: GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/logout.svg",
                      height: 22,
                      width: 22,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Logout",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- REUSABLE MENU TILE ----------------
  Widget _menuTile(String title, String iconPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            height: 22,
            width: 22,
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: AppColor.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
