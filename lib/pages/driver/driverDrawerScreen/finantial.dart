import 'package:flutter/material.dart';
import 'package:go_eat_e_commerce_app/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../SharedPreference/AppSession.dart';
import '../../../models/incomingprofitModel.dart';
import '../../../models/paymentReceivedModel.dart';
import '../../../services/auth_service.dart';
import 'drawerScreenDriver.dart';

class FinancialReportScreen extends StatefulWidget {
  const FinancialReportScreen({super.key});

  @override
  State<FinancialReportScreen> createState() => _FinancialReportScreenState();
}

class _FinancialReportScreenState extends State<FinancialReportScreen> {
  int selectedTab = 0;

  IncomingProfitModel? incomingProfitModel;
  PaymentreceivedModel? paymentReceivedModel;

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
          fit: BoxFit.contain,
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
      fetchFinancialData();
    });
  }

  // ================= FETCH APIs =================
  Future<void> fetchFinancialData() async {
    showLoader();

    try {
      final driverId = AppSession().userId;

      final incomingRes =
      await AuthService.incoming_profit(driver_id: driverId);
      incomingProfitModel = IncomingProfitModel.fromJson(incomingRes);

      final paymentRes =
      await AuthService.payment_received(driver_id: driverId);
      paymentReceivedModel = PaymentreceivedModel.fromJson(paymentRes);
    } catch (e) {
      debugPrint("❌ Financial API Error: $e");
    }

    hideLoader();
    setState(() {});
  }

  // ================= UI =================
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
          "Financial Report",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _balanceCard(),
            const SizedBox(height: 20),
            _tabs(),
            const SizedBox(height: 18),
            _transactionList(),
          ],
        ),
      ),
    );
  }

  // ================= FINANCIAL BALANCE =================
  Widget _balanceCard() {
    final balanceAmount = selectedTab == 0
        ? (incomingProfitModel?.driverProfit ?? "0.00")
        : (paymentReceivedModel?.profit ?? "0.00");

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            "Financial Balance",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColor.primaryColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "${AppSession().currency == "NGN" ? "₦" : "£"}$balanceAmount",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColor.secondprimaryColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "All Amount Earned Will Be Transferred To\nYour Bank Account Within 1 Day",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ================= TABS =================
  Widget _tabs() {
    return Row(
      children: [
        _tabButton("Incoming Profit", 0),
        const SizedBox(width: 10),
        _tabButton("Payment Received", 1),
      ],
    );
  }

  Widget _tabButton(String title, int index) {
    final isActive = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:
            isActive ? AppColor.primaryColor : AppColor.secondaryColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor.primaryColor),
          ),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isActive
                  ? AppColor.secondaryColor
                  : AppColor.primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  // ================= TRANSACTION LIST =================
  Widget _transactionList() {
    if (selectedTab == 0) {
      final list = incomingProfitModel?.data ?? [];

      if (list.isEmpty) {
        return _emptyState();
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          return _transactionTile(
            double.tryParse(item.driverCost ?? '0') ?? 0,
            item.createdAt ?? '',
          );
        },
      );
    } else {
      final list = paymentReceivedModel?.data ?? [];

      if (list.isEmpty) {
        return _emptyState();
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          return _transactionTile(
            double.tryParse(item.amount ?? '0') ?? 0,
            item.date ?? '',
          );
        },
      );
    }
  }

  // ================= EMPTY STATE =================
  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Text(
        "No data found",
        style: GoogleFonts.poppins(),
      ),
    );
  }

  // ================= TILE =================
  Widget _transactionTile(double amount, String date) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppColor.secondaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "${AppSession().currency == "NGN" ? "₦" : "£"}$amount",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColor.secondprimaryColor,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              date,
              style: GoogleFonts.poppins(fontSize: 12),
            ),
          ]),
          Text(
            "View Detail",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: AppColor.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
