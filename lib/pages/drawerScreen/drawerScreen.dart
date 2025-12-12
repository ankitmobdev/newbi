import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_eat_e_commerce_app/pages/drawerScreen/profile.dart';
import 'package:go_eat_e_commerce_app/pages/drawerScreen/termsAndCondition.dart';
import 'package:go_eat_e_commerce_app/pages/drawerScreen/wallet.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../SharedPreference/AppSession.dart';
import '../../constant.dart';
import '../../services/auth_service.dart';
import '../homeScreen/homeScreen.dart';
import '../onboardingscreens.dart';
import 'currency.dart';
import 'currentServices.dart';
import 'faq.dart';
import 'helpScreen.dart';
import 'historyScreen.dart';

class CustomSideBar extends StatelessWidget {
  const CustomSideBar({super.key});

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
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: AppSession().profileImage.isNotEmpty
                        ? ClipOval(
                      child: Image.network(
                        AppSession().profileImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _fallbackProfileIcon();
                        },
                      ),
                    )
                        : _fallbackProfileIcon(),
                  ),

                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppSession().firstname+AppSession().lastname,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        AppSession().phone,
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
                  Helper.moveToScreenwithPush(context, HomeScreen());
                },
                child: _menuTile("Home", "assets/images/home.svg")),
            InkWell(
              onTap: () {
                Helper.moveToScreenwithPush(context, CurrentServiceScreen());
              },
                child: _menuTile("Current Service", "assets/images/currentService.svg")),
            InkWell(
                onTap: () {
                 Helper.moveToScreenwithPush(context, HistoryServiceScreen());
                  },
                child: _menuTile("History Service", "assets/images/historyService.svg")),
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
                  Helper.moveToScreenwithPush(context, CurrencyScreen(fromScreen: "user"));
                },
                child: _menuTile("Currency", "assets/images/wallet.svg")),
            InkWell(
                onTap: () {
                  Helper.moveToScreenwithPush(context, TermOfServiceScreen());
                },
                child: _menuTile("About", "assets/images/faq.svg")),
            InkWell(
                onTap: () {
                  Helper.moveToScreenwithPush(context, FaqScreen());
                },
                child: _menuTile("Faq", "assets/images/about.svg")),
            InkWell(
              onTap: () {
                Helper.moveToScreenwithPush(context, HelpScreen(fromScreen: "user"));
              },
                child: _menuTile("Help", "assets/images/help.svg")),

            const Spacer(),

            // ---------------- LOGOUT ----------------
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 30),
              child: GestureDetector(
                onTap: () {
                  showConfirmPopuplogout(context: context);
                },
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

  Widget _fallbackProfileIcon() {
    return Container(
      color: Colors.grey.shade300,
      child: Icon(
        Icons.person,
        color: Colors.grey.shade700,
        size: 32,
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

  // ---------------- SAFE LOADER ----------------
  void _showLoader(BuildContext context) {
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

  void _hideLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

// ---------------- LOGOUT POPUP ----------------
  void showConfirmPopuplogout({required BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Logout Confirmation",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Are you sure you want to logout?",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "No",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () async {
                        // Safe root context
                        final rootCtx = Navigator.of(context, rootNavigator: true).context;

                        // Close confirmation dialog
                        Navigator.pop(context);

                        // Critical 50ms delay to let dialog close safely
                        await Future.delayed(const Duration(milliseconds: 50));

                        // Show loader immediately
                        _showLoader(rootCtx);

                        try {
                          final resp = await AuthService.logout();
                          print("🔵 Logout API Response: $resp");

                          if (resp["result"] == "success") {
                            await AppSession().logout();

                            _hideLoader(rootCtx);

                            Navigator.of(rootCtx, rootNavigator: true).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                                  (route) => false,
                            );
                          } else {
                            _hideLoader(rootCtx);
                            ScaffoldMessenger.of(rootCtx).showSnackBar(
                              SnackBar(content: Text(resp["message"] ?? "Logout failed")),
                            );
                          }
                        } catch (e) {
                          _hideLoader(rootCtx);
                          ScaffoldMessenger.of(rootCtx).showSnackBar(
                            SnackBar(content: Text("Error: $e")),
                          );
                        }
                      },

                      child: Text(
                        "Yes",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: AppColor.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
