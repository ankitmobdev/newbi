import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../SharedPreference/AppSession.dart';
import '../../../constant.dart';
import '../../../services/auth_service.dart';

class ReportProblemScreen extends StatefulWidget {
  final String orderId;

  const ReportProblemScreen({super.key, required this.orderId});

  @override
  _ReportProblemScreenState createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  String? selectedProblem;
  final TextEditingController commentController = TextEditingController();

  final List<String> problems = [
    "Due to vehicle damage",
    "Due to heavy rain",
    "Due to sick",
    "Custom"
  ];

  bool isLoading = false;

  // ---------------- SUBMIT ----------------
  Future<void> submitReport() async {
    if (selectedProblem == null) {
      showSnack("Please select a problem", true);
      return;
    }

    if (selectedProblem == "Custom" && commentController.text.isEmpty) {
      showSnack("Please enter your comment", true);
      return;
    }

    _showLoader(); // ✅ SHOW LOADER

    try {
      debugPrint("📤 REPORT PROBLEM REQUEST");
      debugPrint("➡ driver_id: ${AppSession().userId}");
      debugPrint("➡ order_id: ${widget.orderId}");
      debugPrint("➡ message: $selectedProblem");
      debugPrint("➡ comment: ${commentController.text.trim()}");

      final res = await AuthService.reportProblem(
        driver_id: AppSession().userId,
        message: selectedProblem!,
        comment: commentController.text.trim(),
        order_id: widget.orderId,
      );

      debugPrint("📥 REPORT PROBLEM RESPONSE: $res");

      if (res["result"] == "Success") {
        showSnack("Problem reported successfully!", false);

        _hideLoader(); // ✅ HIDE LOADER BEFORE NAVIGATION
        Navigator.pop(context);
      } else {
        showSnack(res["message"] ?? "Something went wrong", true);
      }
    } catch (e) {
      debugPrint("❌ REPORT PROBLEM ERROR: $e");
      showSnack("Error: $e", true);
    } finally {
      // ✅ Ensure loader always closes
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        _hideLoader();
      }
    }
  }
  // ================= LOADER =================
  void _showLoader() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => Center(
        child: Lottie.asset('assets/animation/dots_loader.json'),
      ),
    );
  }

  void _hideLoader() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  void showSnack(String msg, bool error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
        ),
        title: Text(
          "Report a Problem",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColor.primaryColor,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---------- Select Problem ----------
            Text(
              "Select Problem",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedProblem,
                  hint: Text(
                    "Select Problem",
                    style: GoogleFonts.poppins(color: Colors.black54),
                  ),
                  isExpanded: true,
                  items: problems.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 15,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProblem = value;
                      if (value != "Custom") commentController.clear();
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ---------- Comment ----------
            Text(
              "Comment",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              height: 130,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: commentController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: selectedProblem == "Custom"
                      ? "Enter your comment"
                      : "Comment (optional)",
                  hintStyle: GoogleFonts.poppins(color: Colors.black38),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ---------- Submit Button ----------
            GestureDetector(
              onTap: isLoading ? null : submitReport,
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                    "SUBMIT",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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
