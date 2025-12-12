import 'dart:convert';
import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import '../../SharedPreference/AppSession.dart';
import '../../constant.dart';
import '../../models/profilemodel.dart';
import '../../models/usermodel.dart';
import '../../services/auth_service.dart';
import '../mapScreens/mapScreen.dart';
import 'drawerScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Controllers
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _vehicleNo = TextEditingController();
  final TextEditingController _aideName = TextEditingController();
  final TextEditingController _aideEmail = TextEditingController();
  final TextEditingController _aidePhone = TextEditingController();
  final TextEditingController selectLocation = TextEditingController();

  // Flags to know whether an image came from API or local file
  bool isProfileFromApi = false;
  bool isFrontFromApi = false;
  bool isBackFromApi = false;
  bool isAideFromApi = false;

  // Location / misc
  String latitude = "";
  String longitude = "";
  String selectedCountryCode = "IN";
  String selectedDialCode = "+91";
  String selectedFlag = "🇮🇳";
  String? errorMessage;

  // Images
  XFile? profileImage;
  XFile? frontImage;
  XFile? backImage;
  XFile? aideProfileImage;

  // Dropdown data
  String? selectedVehicle;
  List<String> vehicleTypes = ["Bike", "Scooter", "Car", "Van", "Truck"];

  bool helpAide = false;

  // Placeholder used for FadeInImage (must be raster - png/jpg)
  static const String placeholderRaster = "assets/images/unnamed 1copy 1.png";

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _phone.dispose();
    _vehicleNo.dispose();
    _aideName.dispose();
    _aideEmail.dispose();
    _aidePhone.dispose();
    selectLocation.dispose();
    super.dispose();
  }

  /*void _showLoader() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }*/

  Future<void> updateDriverProfile() async {
    try {
      _showLoader();

      final fullNameSplit = _fullName.text.trim().split(" ");
      final firstname = fullNameSplit.isNotEmpty ? fullNameSplit.first : "";
      final lastname = fullNameSplit.length > 1 ? fullNameSplit.sublist(1).join(" ") : "";

      // Use stored session userId if available
      final userId = AppSession().userId;

      print("📸 CHECK → Selected profileImage: $profileImage");
      print("📸 CHECK → isProfileFromApi: $isProfileFromApi");
      print("📸 CHECK → Final image sent to API: "
          "${(profileImage != null && !isProfileFromApi) ? profileImage!.path : 'NULL'}");

      final response = await AuthService.updateProfileuser(
        userId: userId,
        firstname: firstname,
        lastname: lastname,
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        address: selectLocation.text.trim(),
        countryCode: selectedDialCode,
        latitude: latitude,
        longitude: longitude,

      profileImage: (profileImage != null && !isProfileFromApi)
            ? File(profileImage!.path)
            : null,
      );

      Navigator.pop(context); // hide loader

      if (response["result"] == "success" || response["result"] == "true") {

        final jsonMap = response is String ? jsonDecode(response.toString()) : response;
        final model = ProfileModel.fromJson(jsonMap);
        await AppSession().updateUserFromProfile(model);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Updated Successfully!")),
        );
        // Refresh profile to reflect any server changes (images/paths etc.)
        await fetchProfileData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["message"] ?? "Failed!")),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      print("❌ UPDATE ERROR: $e");
    }
  }

  Future<void> fetchProfileData() async {
    print("🔄 Fetching Profile…");
    print("🔄 userId…${AppSession().userId}");

    try {
      final userId = AppSession().userId;
      ProfileModel model = await AuthService.getProfile(userId);

      if (model.result != "success" || model.data == null) {
        print("❌ Profile API failed");
        return;
      }

      final data = model.data!;
      //final jsonMap = res is String ? jsonDecode(res.toString()) : res;
      //final model = LoginModel.fromJson(jsonMap);

      setState(() {
        _fullName.text = "${data.firstname ?? ""} ${data.lastname ?? ""}".trim();
        _email.text = data.email ?? "";
        _phone.text = data.phone ?? "";
        selectLocation.text = data.address ?? "";
        selectedVehicle = data.vehicleType ?? "";
        _vehicleNo.text = data.vehicleRegNo ?? "";

        latitude = data.countryCode ?? "";
        longitude = data.phoneCode ?? "";

        print("profile_img_0___${data.profileImage}");

        // IMAGES: if API returned full URLs, treat them as network images
        if (data.profileImage != null && data.profileImage!.isNotEmpty) {
          profileImage = XFile(data.profileImage!);
          isProfileFromApi = true;
        } else {
          profileImage = null;
          isProfileFromApi = false;
        }

      });

      print("✅ Profile Loaded Successfully");
    } catch (e) {
      print("❌ PROFILE ERROR: $e");
    }
  }

  // Image pickers - when user picks an image, mark source as local (not API)
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
                  XFile? img = await pickFromCamera();
                  if (img != null) {
                    setState(() {
                      aideProfileImage = img;
                      isAideFromApi = false;
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
                      aideProfileImage = img;
                      isAideFromApi = false;
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
                    setState(() {
                      profileImage = img;
                      isProfileFromApi = false;
                    });
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
                    setState(() {
                      profileImage = img;
                      isProfileFromApi = false;
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
                        isFrontFromApi = false;
                      } else {
                        backImage = img;
                        isBackFromApi = false;
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
                        isFrontFromApi = false;
                      } else {
                        backImage = img;
                        isBackFromApi = false;
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

  // Common phone field
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

  Widget phoneField() => phoneFieldBase(_phone);
  Widget phoneFieldForAide() => phoneFieldBase(_aidePhone);

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

  Widget buildFieldEmail({
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
              enabled: false,
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

  /*Widget vehicleDropdown() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColor.secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          dropdownColor: AppColor.secondaryColor,
          value: selectedVehicle,
          hint: Text(
            "Select Vehicle",
            style: GoogleFonts.poppins(color: AppColor.textclr, fontSize: 15),
          ),
          icon: Icon(Icons.keyboard_arrow_down, color: AppColor.primaryColor),
          items: vehicleTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(type, style: GoogleFonts.poppins(color: AppColor.textclr, fontSize: 15)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => selectedVehicle = value);
          },
        ),
      ),
    );
  }*/

  Widget uploadBox(String label, bool isFront) {
    XFile? image = isFront ? frontImage : backImage;
    bool isApi = isFront ? isFrontFromApi : isBackFromApi;

    return GestureDetector(
      onTap: () => showUploadPicker(isFront),
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
            SvgPicture.asset("assets/images/uploadphoto.svg", height: 22),
            const SizedBox(height: 8),
            Text(label, style: GoogleFonts.poppins(color: AppColor.textclr, fontSize: 13)),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: isApi
              ? FadeInImage.assetNetwork(
            placeholder: placeholderRaster,
            image: image.path,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          )
              : Image.file(
            File(image.path),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: showImagePicker,
      child: Container(
        height: 58,
        width: 58,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: ClipOval(
          child: profileImage == null
              ? Image.asset(placeholderRaster, fit: BoxFit.cover)
              : (isProfileFromApi
              ? FadeInImage.assetNetwork(
            placeholder: placeholderRaster,
            image: profileImage!.path,
            fit: BoxFit.cover,
          )
              : Image.file(File(profileImage!.path), fit: BoxFit.cover)),
        ),
      ),
    );
  }

  Widget _buildAideImage() {
    return GestureDetector(
      onTap: showAideImagePicker,
      child: Container(
        height: 58,
        width: 58,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: ClipOval(
          child: aideProfileImage == null
              ? Image.asset(placeholderRaster, fit: BoxFit.cover)
              : (isAideFromApi
              ? FadeInImage.assetNetwork(
            placeholder: placeholderRaster,
            image: aideProfileImage!.path,
            fit: BoxFit.cover,
          )
              : Image.file(File(aideProfileImage!.path), fit: BoxFit.cover)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bgAsset = "assets/images/splashbackground.png";

    return Scaffold(
      drawer: const CustomSideBar(),
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
        title: Text("Profile",
            style: GoogleFonts.poppins(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset(bgAsset, fit: BoxFit.cover)),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [const Color(0xFF040719).withOpacity(0.50), AppColor.primaryColor.withOpacity(0.77)],
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
                  Center(
                    child: Column(
                      children: [
                        _buildProfileImage(),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: showImagePicker,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(color: AppColor.secondaryColor, borderRadius: BorderRadius.circular(12)),
                            child: Text("Upload Image", style: GoogleFonts.poppins(color: AppColor.primaryColor, fontSize: 14)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  buildField(hint: "Enter Your Full Name", icon: "assets/images/user_3_line.svg", controller: _fullName),
                  const SizedBox(height: 14),
                  buildFieldEmail(hint: "Enter Your Email I'd", icon: "assets/images/mail.svg", controller: _email),
                  const SizedBox(height: 14),
                  phoneField(),
                  // buildField(hint: "Enter Your Password", icon: "assets/images/lock.svg", controller: _password, obscure: true),
                  // const SizedBox(height: 14),
                  // buildField(
                  //     hint: "Enter Your Confirm Password", icon: "assets/images/lock.svg", controller: _confirmPassword, obscure: true),
                  // const SizedBox(height: 14),
                  // vehicleDropdown(),
                  // const SizedBox(height: 14),
                  // buildField(hint: "Enter Your Vehicle Number", icon: "assets/images/vehicleNumber.svg", controller: _vehicleNo),
                  //const SizedBox(height: 14),
                  //buildLocationSelector(),
                  const SizedBox(height: 34),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Text("Driver License Photo Back & Front", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                  // ),
                  // const SizedBox(height: 10),
                  // Row(
                  //   children: [
                  //     Expanded(child: uploadBox("Upload Front", true)),
                  //     const SizedBox(width: 12),
                  //     Expanded(child: uploadBox("Upload Back", false)),
                  //   ],
                  // ),
                  // const SizedBox(height: 18),
                  // Divider(color: AppColor.secondaryColor, thickness: 2),
                  // const SizedBox(height: 18),
                  // Text("Help Aide Profile", style: GoogleFonts.poppins(color: AppColor.secondaryColor, fontSize: 18, fontWeight: FontWeight.w600)),
                  // const SizedBox(height: 18),
                  // Center(
                  //   child: Column(
                  //     children: [
                  //       _buildAideImage(),
                  //       const SizedBox(height: 8),
                  //       GestureDetector(
                  //         onTap: showAideImagePicker,
                  //         child: Container(
                  //           padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  //           decoration: BoxDecoration(color: AppColor.secondaryColor, borderRadius: BorderRadius.circular(12)),
                  //           child: Text("Upload Aide Image", style: GoogleFonts.poppins(color: AppColor.primaryColor, fontSize: 14)),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 18),
                  // buildField(hint: "Enter Your Full Name", icon: "assets/images/user_3_line.svg", controller: _aideName),
                  // const SizedBox(height: 14),
                  // buildField(hint: "Enter Your Email I'd", icon: "assets/images/mail.svg", controller: _aideEmail),
                  // const SizedBox(height: 14),
                  // phoneFieldForAide(),
                  const SizedBox(height: 18),
                  const SizedBox(height: 22),
                  SizedBox(height: MediaQuery.of(context).size.height*0.25),
                  GestureDetector(
                    onTap: () {
                      updateDriverProfile();
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        border: Border(
                          bottom: BorderSide(color: AppColor.secondaryColor, width: 6),
                          top: BorderSide(color: AppColor.secondaryColor, width: 1),
                          left: BorderSide(color: AppColor.secondaryColor, width: 1),
                          right: BorderSide(color: AppColor.secondaryColor, width: 1),
                        ),
                      ),
                      child: Center(child: Text("Update", style: GoogleFonts.poppins(color: AppColor.secondaryColor, fontSize: 16, fontWeight: FontWeight.w500))),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.1),

                ],
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
        Helper.moveToScreenwithPush(
          context,
          LocationWidget(callback: (String location, double lat, double lng) {
            setState(() {
              selectLocation.text = location;
              latitude = lat.toString();
              longitude = lng.toString();
            });
          }),
        );
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(color: AppColor.secondaryColor, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            const SizedBox(width: 14),
            SvgPicture.asset("assets/images/location.svg", height: 22),
            const SizedBox(width: 14),
            Container(width: 1, height: 26, color: AppColor.textclr),
            const SizedBox(width: 14),
            Text("Select Location", style: GoogleFonts.poppins(color: AppColor.textclr, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  void _showLoader() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Lottie.asset(
          'assets/animation/dots_loader.json',
          repeat: true,         // important!
          fit: BoxFit.contain,
        ),
      ),
    );
  }

}
