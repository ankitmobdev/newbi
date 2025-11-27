import 'package:flutter/material.dart';
import 'package:go_eat_e_commerce_app/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'changePassword.dart';
import 'drawerScreenDriver.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool emailToggle = true;
  bool notificationToggle = true;

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

      // ---------------- BODY WITH FULL SCREEN BG ----------------
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
              // ---------------- SETTINGS CARD ----------------
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
                    // ---------------- EMAIL TOGGLE ----------------
                    _settingsRow(
                      title: "Email",
                      trailing: customSwitch(
                        value: emailToggle,
                        onChanged: () =>
                            setState(() => emailToggle = !emailToggle),
                      ),
                    ),

                    Divider(height: 1, color: Colors.grey.shade300),

                    // ---------------- NOTIFICATION TOGGLE ----------------
                    _settingsRow(
                      title: "Notification",
                      trailing: customSwitch(
                        value: notificationToggle,
                        onChanged: () =>
                            setState(() => notificationToggle = !notificationToggle),
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
                        Helper.moveToScreenwithPush(context, ChangePassword());
                        // Navigate to change password
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        duration:  Duration(milliseconds: 200),
        height: 22,
        width: 42,
        padding:  EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: value ? Colors.green : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            height: 17,
            width: 17,
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.secondaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
