import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../SharedPreference/AppSession.dart';
import '../../Stripe/PaymentService.dart';
import '../../constant.dart';
import '../../services/auth_service.dart';
import 'drawerScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final TextEditingController amountController = TextEditingController();
  double walletBalance = 0.0;
  List transactions = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    PaymentService().initializeStripe();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getTransactionHistory();
    });
  }

  ///------------------- FETCH TRANSACTION HISTORY API -------------------///
  Future<void> getTransactionHistory() async {
    //setState(() => loading = true);
    try {
      _showLoader();
      final res = await AuthService.getTransactionHistory(
        user_id: AppSession().userId,
      );
      Navigator.of(context, rootNavigator: true).pop();
      if (res["result"] == "success") {
        setState(() {
          walletBalance = double.parse(res["wallet_amount"].toString());
          transactions = List<Map<String, dynamic>>.from(res["data"]);
        });
      } else {
        showSnack(res["message"] ?? "Failed to load");
      }
    } catch (e) {
      showSnack("Error loading transaction history: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  ///------------------- ADD MONEY API -------------------///
  /*Future<void> addMoneyToWallet() async {
    if (amountController.text.isEmpty) {
      return showSnack("Enter amount");
    }
    try {
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (_) => const Center(child: CircularProgressIndicator()),
      // );

      final res = await AuthService.addMoneyToWallet(
        user_id: AppSession().userId,
        amount: amountController.text.trim(),
      );

      //Navigator.pop(context); // Close loader

      if (res["result"] == "success") {
        showSnack("Money Added Successfully");
        amountController.clear();
        getTransactionHistory();
      } else {
        showSnack(res["message"] ?? "Failed to add money");
      }
    } catch (e) {
      //Navigator.pop(context);
      showSnack("Error: $e");
    }
  }*/

  void _showLoader() {
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

  ///------------ COMMON SNACKBAR -------------///
  void showSnack(message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  /// =====================================================================
  ///                              UI DESIGN SAME
  /// =====================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomSideBar(),
      backgroundColor: Colors.white,
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
          "Wallet",
          style: GoogleFonts.poppins(
            color: AppColor.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),

            ///---------------- USER NAME + BALANCE --------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppSession().firstname,
                    style: GoogleFonts.poppins(
                        fontSize: 17, fontWeight: FontWeight.w600)),
                Text(
                  (AppSession().currency == "NGN" ? "₦" : "£") +
                      walletBalance.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColor.secondprimaryColor,
                  ),
                ),
              ],
            ),
            Text("Your Available Balance",
                style:
                GoogleFonts.poppins(color: Colors.black54, fontSize: 13)),
            const SizedBox(height: 25),

            // ===== AMOUNT INPUT =====
            Text("Amount",
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),

            Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColor.secondaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter Amount",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.borderColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.borderColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ================= ADD MONEY BUTTON =================
            GestureDetector(
              onTap: () async {
                if (amountController.text.isEmpty) {
                  return showSnack("Enter amount");
                }
                await PaymentService().makePayment(
                  context,
                  amountController.text.trim(),
                  AppSession().currency == "NGN" ? "ngn" : "gbp",
                );
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text("Add Money",
                      style: GoogleFonts.poppins(
                          fontSize: 15, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 28),

            //----------------- TITLE ----------------
            Center(
              child: Text("Transaction History",
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 16),

            ///================ LIST VIEW ==================
            ListView.builder(
              itemCount: transactions.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                var tx = transactions[i];
                bool isCredit = tx["status"] == "credit"; // fixed

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColor.secondaryColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (AppSession().currency == "NGN" ? "₦" : "£") + (tx["amount"]?.toString() ?? "0"),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColor.secondprimaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(tx["created_at"] ?? "",
                              style: GoogleFonts.poppins(
                                  fontSize: 13, color: Colors.black54)),
                        ],
                      ),
                      SvgPicture.asset(
                        isCredit
                            ? "assets/images/arrow_right_up_line (1).svg"
                            : "assets/images/arrow_right_up_line.svg",
                        height: 26,
                        width: 26,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}
