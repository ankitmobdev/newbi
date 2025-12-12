import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../SharedPreference/AppSession.dart';
import '../../constant.dart';
import '../driver/driverDrawerScreen/drawerScreenDriver.dart';
import 'drawerScreen.dart';

class CurrencyScreen extends StatefulWidget {
  //const CurrencyScreen({super.key});
  final fromScreen;
  const CurrencyScreen({super.key, this.fromScreen});
  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  late String selectedCurrency;

  @override
  void initState() {
    super.initState();
    selectedCurrency =
    AppSession().currency.isNotEmpty ? AppSession().currency : "GBP";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const CustomSideBar(),
      drawer: widget.fromScreen == "driver"
          ? DriverCustomSideBar()
          : CustomSideBar(),
      backgroundColor: Colors.white,

      // ---------------- APPBAR ----------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: AppColor.primaryColor),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          "Currency",
          style: GoogleFonts.poppins(
            color: AppColor.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Currency",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            _currencyTile(
              title: "British Pound (£)",
              subtitle: "GBP",
              value: "GBP",
              symbol: "£",
            ),

            const SizedBox(height: 12),

            _currencyTile(
              title: "Nigerian Naira (₦)",
              subtitle: "NGN",
              value: "NGN",
              symbol: "₦",
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  await AppSession().setCurrency(selectedCurrency);

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Currency updated successfully",
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  );

                  Navigator.pop(context);
                },
                child: Text(
                  "Save",
                  style: GoogleFonts.poppins(
                    color: AppColor.secondaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CURRENCY TILE =================
  Widget _currencyTile({
    required String title,
    required String subtitle,
    required String value,
    required String symbol,
  }) {
    final bool active = selectedCurrency == value;

    return InkWell(
      onTap: () {
        setState(() {
          selectedCurrency = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? AppColor.primaryColor : Colors.grey.shade300,
            width: 1.5,
          ),
          color: active
              ? AppColor.primaryColor.withOpacity(0.05)
              : Colors.white,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColor.primaryColor,
              child: Text(
                symbol,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ System font so ₦ renders correctly
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              active
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: AppColor.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
