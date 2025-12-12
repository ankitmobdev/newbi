import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:signature/signature.dart';

import '../../../services/auth_service.dart';
import '../../../constant.dart';

class CompleteTripScreen extends StatefulWidget {
  final String orderId;
  const CompleteTripScreen({super.key, required this.orderId});

  @override
  State<CompleteTripScreen> createState() => _CompleteTripScreenState();
}

class _CompleteTripScreenState extends State<CompleteTripScreen> {
  // IMAGE FILES
  XFile? parcel1;
  XFile? parcel2;
  XFile? parcel3;
  XFile? clientImage;

  final ImagePicker picker = ImagePicker();

  // SIGNATURE
  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
  );

  // ------------------------- GENERIC IMAGE PICKER (CAMERA + GALLERY) -------------------------
  Future<void> showImagePicker(Function(XFile?) setImage) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () async {
                  Navigator.pop(context);
                  final img = await picker.pickImage(source: ImageSource.camera);
                  if (img != null) setState(() => setImage(img));
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  final img = await picker.pickImage(source: ImageSource.gallery);
                  if (img != null) setState(() => setImage(img));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ------------------------- VALIDATION -------------------------
  bool validate() {
    if (clientImage == null) {
      showMsg("Please upload client image");
      return false;
    }
    if (parcel1 == null || parcel2 == null || parcel3 == null) {
      showMsg("Upload all parcel images");
      return false;
    }
    if (signatureController.isEmpty) {
      showMsg("Add signature");
      return false;
    }
    return true;
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ------------------------- SUBMIT DELIVERY -------------------------
// ------------------------- SUBMIT DELIVERY -------------------------
  Future<void> submitDelivery() async {
    if (!validate()) return;

    _showLoader(); // ✅ SHOW LOADER

    try {
      // ✅ Convert Signature to file
      final signatureBytes =
      await signatureController.toPngBytes(height: 300, width: 300);

      final signatureFile = await File(
        '${Directory.systemTemp.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png',
      ).writeAsBytes(signatureBytes!);

      debugPrint("📤 SUBMIT DELIVERY REQUEST");
      debugPrint("➡ order_id: ${widget.orderId}");

      final res = await AuthService.deliverOrder(
        order_id: widget.orderId,
        signature_image: XFile(signatureFile.path),
        client_image: clientImage!,
        parcel_image1: parcel1!,
        parcel_image2: parcel2!,
        parcel_image3: parcel3!,
      );

      debugPrint("📥 SUBMIT DELIVERY RESPONSE: $res");

      if (res["result"]?.toString().toLowerCase() == "success") {
        showMsg("Delivery Completed");

        _hideLoader(); // ✅ HIDE LOADER BEFORE NAVIGATION

        // ✅ Return to previous screen with refresh flag
        Navigator.pop(context, {"delivered": true});
      } else {
        showMsg(res["message"] ?? "Failed to complete delivery");
      }
    } catch (e) {
      debugPrint("❌ SUBMIT DELIVERY ERROR: $e");
      showMsg("Error: $e");
    } finally {
      // ✅ Safety: ensure loader is closed
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

  // ------------------------- UI BUILD -------------------------
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
          "Complete Trip",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColor.primaryColor,
          ),
        ),
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/splashbackground.png",
                fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: AppColor.primaryColor.withOpacity(0.50)),
          ),

          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              children: [
                const SizedBox(height: 6),

                CircleAvatar(
                  radius: 38,
                  backgroundColor: Colors.white,
                  child: const CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage("assets/images/user.png"),
                  ),
                ),

                const SizedBox(height: 20),

                // CLIENT IMAGE
                uploadBox(
                  label: "Upload Client Image",
                  selected: clientImage,
                  onTap: () => showImagePicker((img) => clientImage = img),
                ),

                const SizedBox(height: 18),

                // PARCEL 1
                uploadBox(
                  label: "Upload Parcel Image 1",
                  selected: parcel1,
                  onTap: () => showImagePicker((img) => parcel1 = img),
                ),
                const SizedBox(height: 12),

                // PARCEL 2
                uploadBox(
                  label: "Upload Parcel Image 2",
                  selected: parcel2,
                  onTap: () => showImagePicker((img) => parcel2 = img),
                ),
                const SizedBox(height: 12),

                // PARCEL 3
                uploadBox(
                  label: "Upload Parcel Image 3",
                  selected: parcel3,
                  onTap: () => showImagePicker((img) => parcel3 = img),
                ),

                const SizedBox(height: 24),

                Divider(color: AppColor.secondaryColor, thickness: 2),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Digital Signature",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColor.secondaryColor)),
                    GestureDetector(
                      onTap: () => signatureController.clear(),
                      child: Text("Clear",
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColor.secondaryColor)),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColor.secondaryColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Signature(
                    controller: signatureController,
                    backgroundColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 30),

                deliverButton(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------- UPLOAD BOX -------------------------
  Widget uploadBox({
    required String label,
    required XFile? selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColor.borderColor),
          color: Colors.white,
        ),
        child: selected == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/images/photo_album_2_fill.svg",
                height: 40),
            const SizedBox(height: 10),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 14, color: AppColor.textclr)),
          ],
        )
            : Image.file(File(selected.path), fit: BoxFit.cover),
      ),
    );
  }

  // ------------------------- BUTTON -------------------------
  Widget deliverButton() {
    return GestureDetector(
      onTap: submitDelivery,
      child: Container(
        height: 48,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColor.primaryColor,
          borderRadius: BorderRadius.circular(12),
          border: const Border(
            top: BorderSide(color: Colors.white, width: 1),
            left: BorderSide(color: Colors.white, width: 1),
            right: BorderSide(color: Colors.white, width: 1),
            bottom: BorderSide(color: Colors.white, width: 6),
          ),
        ),
        child: Center(
          child: Text(
            "Submit",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColor.secondaryColor,
            ),
          ),
        ),
      ),
    );
  }

}
