import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../constant.dart';
import '../../registrationScreen/loginUser.dart';
import '../driverHomeScreen/driverHomeScreen.dart';

class DriverSignupScreen extends StatefulWidget {
  const DriverSignupScreen({super.key});

  @override
  State<DriverSignupScreen> createState() => _DriverSignupScreenState();
}

class _DriverSignupScreenState extends State<DriverSignupScreen> {
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _vehicleNo = TextEditingController();
  final TextEditingController _aideName = TextEditingController();
  final TextEditingController _aideEmail = TextEditingController();
  final TextEditingController _aidePhone = TextEditingController();

  // Country variables
  String selectedCountryCode = "IN";
  String selectedDialCode = "+91";
  String selectedFlag = "🇮🇳";
  XFile? aideProfileImage;
  // Image picker variables
  XFile? frontImage;
  XFile? backImage;
  String? errorMessage;
  // Vehicle dropdown
  String? selectedVehicle;
  List<String> vehicleTypes = [
    "Bike",
    "Scooter",
    "Car",
    "Van",
    "Truck",
  ];

  bool helpAide = false;

  XFile? profileImage;


  // Simple image picker
  Future<XFile?> pickImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    const bgAsset = "assets/images/splashbackground.png";

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SvgPicture.asset("assets/images/back.svg", height: 42),
          ),
        ),
        title: Text(
          "Help Aide Profile",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(bgAsset, fit: BoxFit.cover),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF040719).withOpacity(0.50),
                    AppColor.primaryColor.withOpacity(0.77),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // PROFILE IMAGE + Upload Image
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: showImagePicker,
                          child: Container(
                            height: 58,
                            width: 58,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: profileImage != null
                                    ? FileImage(File(profileImage!.path))
                                    : const AssetImage("assets/images/unnamed 1copy 1.png")
                                as ImageProvider,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        GestureDetector(
                          onTap: showImagePicker,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColor.secondaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Upload Image",
                              style: GoogleFonts.poppins(
                                color: AppColor.primaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),



                  const SizedBox(height: 24),

                  // FULL NAME
                  buildField(
                    hint: "Enter Your Full Name",
                    icon: "assets/images/user_3_line.svg",
                    controller: _fullName,
                  ),
                  const SizedBox(height: 14),

                  // EMAIL
                  buildField(
                    hint: "Enter Your Email I'd",
                    icon: "assets/images/mail.svg",
                    controller: _email,
                  ),
                  const SizedBox(height: 14),

                  // PHONE
                  phoneField(),
                  const SizedBox(height: 14),

                  // PASSWORD
                  buildField(
                    hint: "Enter Your Password",
                    icon: "assets/images/lock.svg",
                    controller: _password,
                    obscure: true,
                  ),
                  const SizedBox(height: 14),

                  // CONFIRM PASSWORD
                  buildField(
                    hint: "Enter Your Confirm Password",
                    icon: "assets/images/lock.svg",
                    controller: _confirmPassword,
                    obscure: true,
                  ),
                  const SizedBox(height: 14),

                  // VEHICLE DROPDOWN
                  vehicleDropdown(),
                  const SizedBox(height: 14),

                  // VEHICLE NUMBER
                  buildField(
                    hint: "Enter Your Vehicle Number",
                    icon: "assets/images/vehicleNumber.svg",
                    controller: _vehicleNo,
                  ),
                  const SizedBox(height: 14),

                  // SELECT LOCATION
                  buildLocationSelector(),
                  const SizedBox(height: 20),

                  // UPLOAD FRONT / BACK
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Driver License Photo Back & Front",
                      style: GoogleFonts.poppins(
                          color: Colors.white70, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(child: uploadBox("Upload Front", true)),
                      const SizedBox(width: 12),
                      Expanded(child: uploadBox("Upload Back", false)),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // DO YOU HELP AIDE
                  Row(
                    children: [
                      Checkbox(
                        value: helpAide,
                        onChanged: (v) => setState(() => helpAide = v!),
                        activeColor: Colors.white,
                        checkColor: Colors.black,
                      ),
                      Text(
                        "Do You Help Aide",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),

                  // EXPAND ADDITIONAL FIELDS
                  if (helpAide) ...[

                    // AIDE PROFILE IMAGE
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: showAideImagePicker,
                            child: Container(
                              height: 58,
                              width: 58,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: aideProfileImage != null
                                      ? FileImage(File(aideProfileImage!.path))
                                      : const AssetImage("assets/images/unnamed 1copy 1.png")
                                  as ImageProvider,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: showAideImagePicker,
                            child: Container(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColor.secondaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "Upload Aide Image",
                                style: GoogleFonts.poppins(
                                  color: AppColor.primaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    buildField(
                      hint: "Enter Your Full Name",
                      icon: "assets/images/user_3_line.svg",
                      controller: _aideName,
                    ),
                    const SizedBox(height: 14),

                    buildField(
                      hint: "Enter Your Email I'd",
                      icon: "assets/images/mail.svg",
                      controller: _aideEmail,
                    ),
                    const SizedBox(height: 14),

                    phoneFieldForAide(),
                    const SizedBox(height: 18),
                  ],


                  const SizedBox(height: 22),

                  // SIGN UP BUTTON
                  GestureDetector(
                    onTap: () {
                      // validateAndSubmit();
                      Helper.moveToScreenwithPush(context, DriverHomeScreen());
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        border: Border(
                          bottom:
                          BorderSide(color: AppColor.secondaryColor, width: 6),
                          top:
                          BorderSide(color: AppColor.secondaryColor, width: 1),
                          left:
                          BorderSide(color: AppColor.secondaryColor, width: 1),
                          right:
                          BorderSide(color: AppColor.secondaryColor, width: 1),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.poppins(
                            color: AppColor.secondaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // LOGIN TEXT
                  InkWell(
                    onTap: () {
                      Helper.moveToScreenwithPush(
                        context,
                        LoginUser(loginas: 'driver'),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "I have already an account? ",
                        style: GoogleFonts.poppins(
                            color: Colors.white70, fontSize: 14),
                        children: [
                          TextSpan(
                            text: "Login",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void validateAndSubmit() {
    // Reset
    errorMessage = null;

    // --- MAIN DETAILS VALIDATION ---

    if (profileImage == null) {
      errorMessage = "Please upload your profile image";
    } else if (_fullName.text.isEmpty) {
      errorMessage = "Full name is required";
    } else if (_email.text.isEmpty || !_email.text.contains("@")) {
      errorMessage = "Enter a valid email";
    } else if (_phone.text.isEmpty || _phone.text.length < 8) {
      errorMessage = "Enter a valid phone number";
    } else if (_password.text.length < 6) {
      errorMessage = "Password must be at least 6 characters";
    } else if (_confirmPassword.text != _password.text) {
      errorMessage = "Passwords do not match";
    } else if (selectedVehicle == null) {
      errorMessage = "Please select a vehicle type";
    } else if (_vehicleNo.text.isEmpty) {
      errorMessage = "Enter your vehicle number";
    } else if (frontImage == null || backImage == null) {
      errorMessage = "Please upload front & back license images";
    }

    // --- HELP AIDE VALIDATION ---
    if (helpAide) {
      if (aideProfileImage == null) {
        errorMessage = "Please upload aide profile image";
      } else if (_aideName.text.isEmpty) {
        errorMessage = "Aide full name is required";
      } else if (_aideEmail.text.isEmpty || !_aideEmail.text.contains("@")) {
        errorMessage = "Enter valid aide email";
      } else if (_aidePhone.text.length < 8) {
        errorMessage = "Enter valid aide phone number";
      }
    }

    // If any error show snackbar
    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(errorMessage!,
              style: GoogleFonts.poppins(color: Colors.white)),
        ),
      );
      return;
    }

    // SUCCESS
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Form submitted successfully!",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
    );

    Helper.moveToScreenwithPush(context, DriverHomeScreen());
    print("🎉 SUBMITTED SUCCESSFULLY!");
  }


  // TEXT FIELD BUILDER
  Widget buildField({
    required String hint,
    required String icon,
    required TextEditingController controller,
    bool obscure = false,
  }) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColor.secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          SvgPicture.asset(icon, height: 22, width: 22),
          const SizedBox(width: 14),
          Container(width: 1, height: 26, color: AppColor.textclr),
          const SizedBox(width: 14),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscure,
              style: GoogleFonts.poppins(color: AppColor.textclr, fontSize: 15),
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle:
                GoogleFonts.poppins(color: AppColor.textclr.withOpacity(0.7)),
              ),
            ),
          )
        ],
      ),
    );
  }

  // VEHICLE DROPDOWN
  Widget vehicleDropdown() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColor.secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          // LEFT ICON






          // FULL WIDTH DROPDOWN
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,   // 🔥 makes dropdown full width
                dropdownColor: AppColor.secondaryColor,
                value: selectedVehicle,

                hint: Text(
                  "Select Vehicle",
                  style: GoogleFonts.poppins(
                      color: AppColor.textclr, fontSize: 15),
                ),

                // RIGHT ARROW ICON (suffix)
                icon:  Icon(Icons.keyboard_arrow_down,
                    color: AppColor.primaryColor),

                items: vehicleTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(
                      type,
                      style: GoogleFonts.poppins(
                          color: AppColor.textclr, fontSize: 15),
                    ),
                  );
                }).toList(),

                onChanged: (value) {
                  setState(() => selectedVehicle = value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<XFile?> pickFromCamera() async {
    return await ImagePicker().pickImage(source: ImageSource.camera);
  }

  Future<XFile?> pickFromGallery() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }
  void showAideImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () async {
                  Navigator.pop(context);
                  XFile? img = await ImagePicker()
                      .pickImage(source: ImageSource.camera);
                  if (img != null) {
                    setState(() => aideProfileImage = img);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  XFile? img = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (img != null) {
                    setState(() => aideProfileImage = img);
                  }
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text("Cancel"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () async {
                  Navigator.pop(context);
                  final img = await pickFromCamera();
                  if (img != null) {
                    setState(() => profileImage = img);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  final img = await pickFromGallery();
                  if (img != null) {
                    setState(() => profileImage = img);
                  }
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text("Cancel"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }


  // PHONE FIELD
  Widget phoneField() {
    return phoneFieldBase(_phone);
  }

  // PHONE FIELD FOR AIDE
  Widget phoneFieldForAide() {
    return phoneFieldBase(_aidePhone);
  }

  // COMMON PHONE FIELD COMPONENT
  Widget phoneFieldBase(TextEditingController controller) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColor.secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),

          GestureDetector(
            onTap: () {
              showCountryPicker(
                context: context,
                showPhoneCode: true,
                onSelect: (Country country) {
                  setState(() {
                    selectedCountryCode = country.countryCode;
                    selectedDialCode = "+${country.phoneCode}";
                    selectedFlag = country.flagEmoji;
                  });
                },
              );
            },
            child: Row(
              children: [
                Text(selectedFlag, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 6),
                Text(
                  selectedDialCode,
                  style: GoogleFonts.poppins(color: AppColor.textclr, fontSize: 15),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Container(width: 1, height: 26, color: AppColor.textclr),
          const SizedBox(width: 14),

          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: GoogleFonts.poppins(color: AppColor.textclr, fontSize: 15),
              decoration: InputDecoration(
                hintText: "Enter Your Number",
                border: InputBorder.none,
                hintStyle:
                GoogleFonts.poppins(color: AppColor.textclr.withOpacity(0.7)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // LOCATION SELECTOR
  Widget buildLocationSelector() {
    return GestureDetector(
      onTap: () {
        print("Select Location tapped");
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColor.secondaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            SvgPicture.asset("assets/images/location.svg", height: 22),
            const SizedBox(width: 14),
            Container(width: 1, height: 26, color: AppColor.textclr),
            const SizedBox(width: 14),
            Text(
              "Select Location",
              style: GoogleFonts.poppins(color: AppColor.textclr, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }



  void showUploadPicker(bool isFront) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () async {
                  Navigator.pop(context);
                  XFile? img = await pickFromCamera();
                  if (img != null) {
                    setState(() {
                      if (isFront) {
                        frontImage = img;
                      } else {
                        backImage = img;
                      }
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  XFile? img = await pickFromGallery();
                  if (img != null) {
                    setState(() {
                      if (isFront) {
                        frontImage = img;
                      } else {
                        backImage = img;
                      }
                    });
                  }
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text("Cancel"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

// UPLOAD BOX (FRONT & BACK)
  Widget uploadBox(String label, bool isFront) {
    XFile? image = isFront ? frontImage : backImage;

    return GestureDetector(
      onTap: () {
        showUploadPicker(isFront);
      },
      child: Container(
        height: 92,
        decoration: BoxDecoration(
          color: AppColor.secondaryColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.textclr),
        ),
        child: image == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/images/uploadphoto.svg",
              height: 22,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: AppColor.textclr,
                fontSize: 13,
              ),
            ),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            File(image.path),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }

}
