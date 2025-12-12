import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../SharedPreference/AppSession.dart';
import '../../../constant.dart';
import '../../../services/auth_service.dart';
import 'drawerScreenDriver.dart';

class PayoutScreen extends StatefulWidget {
  const PayoutScreen({super.key});

  @override
  State<PayoutScreen> createState() => _PayoutScreenState();
}

class _PayoutScreenState extends State<PayoutScreen> {
  final TextEditingController withdrawController = TextEditingController();

  String earning = "0.0"; // fetched from API
  bool loadingEarning = true;

  @override
  void initState() {
    super.initState();
    fetchTotalEarning();
  }

  // ---------------------- FETCH TOTAL EARNING API ----------------------
  Future<void> fetchTotalEarning() async {
    print("AppSession().userId");
    print(AppSession().userId);
    try {
      final response = await AuthService.payout_total_earning(
        driver_id: AppSession().userId,
      );

      if (response["result"] == "success") {
        earning = response["earning"] ?? "0.0";
      } else {
        earning = "0.0";
      }
    } catch (e) {
      earning = "0.0";
      print("❌ Error fetching earning: $e");
    }

    setState(() => loadingEarning = false);
  }

  // ---------------------- HANDLE PAYOUT (VALIDATION + API) ----------------------
  Future<void> handlePayout() async {
    final amount = withdrawController.text.trim();

    if (amount.isEmpty) {
      return showSnack("Please enter an amount", true);
    }

    if (double.tryParse(amount) == null) {
      return showSnack("Please enter a valid number", true);
    }

    double withdrawAmount = double.parse(amount);
    double availableBalance = double.tryParse(earning) ?? 0.0;

    if (withdrawAmount <= 0) {
      return showSnack("Amount must be greater than 0", true);
    }

    if (withdrawAmount > availableBalance) {
      return showSnack("Amount exceeds available earnings", true);
    }

    showLoader();

    try {
      final res = await AuthService.payout(
        driver_id: AppSession().userId,
        amount: amount,
        message: "Driver Payout Request",
        order_id: "0",
      );

      Navigator.pop(context);

      if (res["result"] == "success") {
        showSnack("Payout request submitted successfully!", false);
        withdrawController.clear();
        fetchTotalEarning(); // refresh earning after payout
      } else {
        showSnack(res["message"] ?? "Payout failed", true);
      }
    } catch (e) {
      Navigator.pop(context);
      showSnack("Error: $e", true);
    }
  }

  // ---------------------- UI HELPERS ----------------------
  void showSnack(String msg, bool error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: error ? Colors.red : Colors.green),
    );
  }
  void showLoader() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4), // <<< adds black dim background
      builder: (_) => Center(
        child: Lottie.asset(
          'assets/animation/dots_loader.json',
          repeat: true,
          fit: BoxFit.contain,
        ),
      ),
    );
  }


  // ---------------------- UI ----------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DriverCustomSideBar(),
      backgroundColor: Colors.white,
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
          "Payout",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),

      body:loadingEarning
          ? Container(
        color: Colors.black.withOpacity(0.2), // FULLY TRANSPARENT BG
        child: Center(
          child: Lottie.asset(
            'assets/animation/dots_loader.json',
            height: 140,
            fit: BoxFit.contain,
          ),
        ),
      )
          :
      SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------ TOP CARD ------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(
                color: AppColor.secondaryColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.primaryColor.withOpacity(0.10),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                children: [
                  Text(
                    "Hello, ${AppSession().firstname} ${AppSession().lastname}",
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Your Total Earning",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColor.textclr,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${AppSession().currency == "NGN" ? "₦" : "£"}$earning",
                    style:  TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColor.secondprimaryColor,
                    ),

                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            Text(
              "Withdraw Money",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColor.primaryColor,
              ),
            ),

            const SizedBox(height: 10),

            // ------------------ INPUT ------------------
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: AppColor.secondaryColor,
                border: Border.all(color: AppColor.borderColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: withdrawController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Amount to Withdraw",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.black45,
                    fontSize: 14,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),

            const SizedBox(height: 26),

            // ------------------ PAYOUT BUTTON ------------------
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: handlePayout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Payout",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: AppColor.secondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
