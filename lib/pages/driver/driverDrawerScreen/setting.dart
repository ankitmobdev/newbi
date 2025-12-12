import 'package:flutter/material.dart';
import 'package:go_eat_e_commerce_app/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../SharedPreference/AppSession.dart';

import '../../../models/profilemodel.dart';
import '../../../services/auth_service.dart';
import 'changePassword.dart';
import 'drawerScreenDriver.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool emailToggle = false;
  bool notificationToggle = false;

  ProfileModel? profileModel;

  // ================= LOADER =================
  void showLoader() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => Center(
        child: Lottie.asset(
          'assets/animation/dots_loader.json',
          repeat: true,
        ),
      ),
    );
  }

  void hideLoader() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProfile();
    });
  }

  // ================= GET PROFILE =================
  Future<void> fetchProfile() async {
    showLoader();

    try {
      final userId = AppSession().userId;
      final profile = await AuthService.getProfile(userId);

      profileModel = profile;

      emailToggle = profile.data?.emailcheck == "1";
      notificationToggle = profile.data?.notification == "1";
    } catch (e) {
      debugPrint("❌ Profile API Error: $e");
    }

    hideLoader();
    setState(() {});
  }

  // ================= UPDATE PREFERENCE =================
  Future<void> updatePreference({
    required String type,
    required bool status,
  }) async {
    final userId = AppSession().userId;
    final value = status ? "1" : "0";

    debugPrint("📤 Preference REQUEST → type: $type, value: $value");

    showLoader();

    try {
      final res = await AuthService.preference(
        user_id: userId,
        type: type,
        value: value,
      );

      hideLoader();

      debugPrint("📥 Preference RESPONSE: $res");

      if (res["result"] != "success") {
        _revertToggle(type);
        _showMessage(res["message"] ?? "Failed to update setting");
      }
    } catch (e) {
      hideLoader();
      _revertToggle(type);
      debugPrint("❌ Preference ERROR: $e");
      _showMessage("Something went wrong");
    }
  }

  void _revertToggle(String type) {
    setState(() {
      if (type == "emailcheck") {
        emailToggle = !emailToggle;
      } else if (type == "notification") {
        notificationToggle = !notificationToggle;
      }
    });
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DriverCustomSideBar(),
      backgroundColor: AppColor.secondaryColor,

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        elevation: 1,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: AppColor.primaryColor),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          "Setting",
          style: GoogleFonts.poppins(
            color: AppColor.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ---------------- BODY ----------------
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/splashbackground.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              AppColor.primaryColor.withOpacity(0.30),
              BlendMode.darken,
            ),
          ),
        ),

        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColor.secondaryColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.primaryColor.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // ---------------- EMAIL ----------------
                    _settingsRow(
                      title: "Email",
                      trailing: customSwitch(
                        value: emailToggle,
                        onChanged: () {
                          final newValue = !emailToggle;
                          setState(() => emailToggle = newValue);
                          updatePreference(
                            type: "emailcheck",
                            status: newValue,
                          );
                        },
                      ),
                    ),

                    Divider(height: 1, color: Colors.grey.shade300),

                    // ---------------- NOTIFICATION ----------------
                    _settingsRow(
                      title: "Notification",
                      trailing: customSwitch(
                        value: notificationToggle,
                        onChanged: () {
                          final newValue = !notificationToggle;
                          setState(() => notificationToggle = newValue);
                          updatePreference(
                            type: "notification",
                            status: newValue,
                          );
                        },
                      ),
                    ),

                    Divider(height: 1, color: Colors.grey.shade300),

                    // ---------------- CHANGE PASSWORD ----------------
                    _settingsRow(
                      title: "Change Password",
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: AppColor.textclr,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChangePassword(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- SETTINGS ROW ----------------
  Widget _settingsRow({
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColor.primaryColor,
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  // ---------------- CUSTOM SWITCH ----------------
  Widget customSwitch({
    required bool value,
    required VoidCallback onChanged,
  }) {
    return GestureDetector(
      onTap: onChanged,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 22,
        width: 42,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: value ? Colors.green : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            height: 17,
            width: 17,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.secondaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
