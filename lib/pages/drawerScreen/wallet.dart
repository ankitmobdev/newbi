import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constant.dart';
import 'drawerScreen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final TextEditingController amountController = TextEditingController();

  // Sample Transaction List — will be replaced with API later
  List<Map<String, dynamic>> transactions = [
    {
      "amount": 710.20,
      "date": "20 January, 2024 | 12:45 PM",
      "type": "credit"
    },
    {"amount": 710.20, "date": "20 January, 2024 | 12:45 PM", "type": "debit"},
    {"amount": 710.20, "date": "20 January, 2024 | 12:45 PM", "type": "credit"},
    {"amount": 710.20, "date": "20 January, 2024 | 12:45 PM", "type": "credit"},
    {"amount": 710.20, "date": "20 January, 2024 | 12:45 PM", "type": "debit"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomSideBar(),
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
          "Wallet",
          style: GoogleFonts.poppins(
            color: AppColor.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),

            // -------- USER + BALANCE --------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Adam Justin",
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "\$450",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColor.secondprimaryColor,
                  ),
                ),
              ],
            ),

            Text(
              "Your Available Balance",
              style: GoogleFonts.poppins(
                color: Colors.black54,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 25),

            // --------------- ENTER AMOUNT ---------------
            Text(
              "Amount",
              style: GoogleFonts.poppins(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

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
                style: GoogleFonts.poppins(fontSize: 15),
                decoration: InputDecoration(
                  hintText: "Enter Amount",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.black45,
                    fontSize: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:  BorderSide(color: AppColor.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColor.borderColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ---------------- ADD MONEY BUTTON ----------------
            GestureDetector(
              onTap: () {
                print("Add Money: ${amountController.text}");
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Add Money",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ---------------- TITLE ----------------
            Center(
              child: Text(
                "Transaction History",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ============= LISTVIEW.BUILDER =============
            ListView.builder(
              itemCount: transactions.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final tx = transactions[index];
                bool isCredit = tx["type"] == "credit";

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
                      // AMOUNT + DATE
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "\$${tx["amount"]}",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color:
                                   AppColor.secondprimaryColor

                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tx["date"],
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),

                      // ARROW ICON (UP/DOWN)

                      SvgPicture.asset(
                        isCredit ?"assets/images/arrow_right_up_line (1).svg":"assets/images/arrow_right_up_line.svg",
                        height: 26,
                        width: 26,
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
