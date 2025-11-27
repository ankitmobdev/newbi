import 'package:flutter/material.dart';
import 'package:go_eat_e_commerce_app/constant.dart';
import 'package:google_fonts/google_fonts.dart';
import 'drawerScreenDriver.dart';

class FinancialReportScreen extends StatefulWidget {
  const FinancialReportScreen({super.key});

  @override
  State<FinancialReportScreen> createState() => _FinancialReportScreenState();
}

class _FinancialReportScreenState extends State<FinancialReportScreen> {
  int selectedTab = 0; // 0 = Incoming Profit, 1 = Payment Received

  List<Map<String, dynamic>> listData = [
    {"amount": 710.20, "date": "20 January, 2024 | 12:45 PM"},
    {"amount": 710.20, "date": "20 January, 2024 | 12:45 PM"},
    {"amount": 710.20, "date": "20 January, 2024 | 12:45 PM"},
    {"amount": 710.20, "date": "20 January, 2024 | 12:45 PM"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DriverCustomSideBar(),
      backgroundColor: Colors.white,

      // ---------------- APP BAR ----------------
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
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // ---------------- BALANCE CARD ----------------
            Container(
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
                    "\$1510000.00",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColor.secondprimaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Divider(),
                  const SizedBox(height: 6),
                  Text(
                    "All Amount Earned Will Be Transferred To\nYour Bank Account Within 1 Day",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColor.textclr,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- TABS ----------------
            Row(
              children: [
                _tabButton("Incoming Profit", 0),
                const SizedBox(width: 10),
                _tabButton("Payment Received", 1),
              ],
            ),

            const SizedBox(height: 18),

            // ---------------- LISTVIEW ----------------
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listData.length,
              itemBuilder: (context, index) {
                final item = listData[index];
                return _transactionTile(item["amount"], item["date"]);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- TAB BUTTON ----------------
  Widget _tabButton(String title, int index) {
    bool isActive = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedTab = index);
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? AppColor.primaryColor :AppColor.secondaryColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColor.primaryColor),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isActive ? AppColor.secondaryColor : AppColor.primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- TRANSACTION TILE ----------------
  Widget _transactionTile(double amount, String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: AppColor.secondaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColor.borderColor),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LEFT SIDE (Amount + Date)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "\$$amount",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color:AppColor.secondprimaryColor,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                date,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColor.primaryColor,
                ),
              ),
            ],
          ),

          // RIGHT SIDE (View Detail)
          GestureDetector(
            onTap: () {},
            child: Text(
              "View Detail",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color:AppColor.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
