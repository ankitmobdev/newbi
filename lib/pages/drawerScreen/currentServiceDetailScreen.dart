import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../SharedPreference/AppSession.dart';
import '../../../models/deliveryDetail.dart';
import '../../../services/auth_service.dart';
import '../../../constant.dart';
import '../../main.dart';
import '../homeScreen/homeScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as local_notifications;

class DetailsFormScreen extends StatefulWidget {
  final fromScreen;
  final orderId;
  const DetailsFormScreen({super.key, this.fromScreen, this.orderId});

  @override
  State<DetailsFormScreen> createState() =>
      _DetailsFormScreenState();
}

class _DetailsFormScreenState extends State<DetailsFormScreen> {

  // ================= CONTROLLERS =================
  final pickupController = TextEditingController();
  final dropController = TextEditingController();
  final storeNameController = TextEditingController();
  final sellerNameController = TextEditingController();
  final sellerNumberController = TextEditingController();
  final purchaserNameController = TextEditingController();
  final purchaserNumberController = TextEditingController();
  final unit1Controller = TextEditingController();
  final stairs1Controller = TextEditingController();
  final unit2Controller = TextEditingController();
  final stairs2Controller = TextEditingController();
  List<dynamic> packageList = [];
  bool byMe = true;
  bool bySomeoneElse = false;

  bool useStairs1 = false;
  bool useElevators1 = false;
  bool useStairs2 = false;
  bool useElevators2 = false;

  String purchasedBy = "";
  String useStairs1Status = "0";
  String useStairs2Status = "0";

  String useElevators1Status = "0";
  String useElevators2Status = "0";
  bool stair1 = false;
  bool elevator1 = true;
  bool stair2 = false;
  bool elevator2 = true;

  Deliverydata? deliveryData;

  String driverPrice = "";
  String adminPrice = "";
  String totalPrice = "";
  String bookingTypeForUI = "";
  String deliverystatus = "";

  int packageCount = 0;

  Color border = Colors.grey.shade300;

  // ================= INIT =================
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDeliveryDetail();
    });
    _listenFCMNotifications();   //
  }
  void _listenFCMNotifications() {
    FirebaseMessaging.onMessage.listen((message) {
      print("📩 Foreground Notification Received");
      _showLocalNotification(message);

      // Auto refresh data
      _fetchDeliveryDetail();
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("📲 Notification opened from background");

      _fetchDeliveryDetail();
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("🚀 Opened from terminated state");

        _fetchDeliveryDetail();
      }
    });
  }

  void _showLocalNotification(RemoteMessage message) async {
    const androidDetails = local_notifications.AndroidNotificationDetails(
      'driver_channel',
      'Driver Notifications',
      importance: local_notifications.Importance.max,
      priority: local_notifications.Priority.high,
    );

    final platformDetails =
    local_notifications.NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification?.title ?? "New Notification",
      message.notification?.body ?? "",
      platformDetails,
    );
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

  // ================= FETCH API =================
  Future<void> _fetchDeliveryDetail() async {
    _showLoader();
    try {
      final resp = await AuthService.deliveryDetail(
        delivery_id: widget.orderId.toString(),
      );

      final model = DeliverydetailModel.fromJson(resp);

      if (model.result == "success" && model.deliverydata != null) {
        final d = model.deliverydata!;
        deliveryData = d;

        pickupController.text = d.pickupaddress ?? "";
        dropController.text = d.dropoffaddress ?? "";
        deliverystatus = d.deliveryStatus ?? "";

        bookingTypeForUI = (d.bookingType ?? "").toLowerCase();
        if (bookingTypeForUI == "onlinemarket") bookingTypeForUI = "online";
        if (bookingTypeForUI == "retailstore") bookingTypeForUI = "retail";
        if (bookingTypeForUI == "furnituredelivery") bookingTypeForUI = "furniture";
        if (bookingTypeForUI == "movinghelp") bookingTypeForUI = "moving";
        if (bookingTypeForUI == "courierservice") bookingTypeForUI = "courier";

        storeNameController.text = d.storeName ?? "";
        sellerNameController.text = d.sellerName ?? "";
        sellerNumberController.text = d.sellerNumber ?? "";
        purchaserNameController.text = d.purchaserName ?? "";
        purchaserNumberController.text = d.purchaserNumber ?? "";

        unit1Controller.text = d.unitOrApartment ?? "";
        unit2Controller.text = d.unitOrApartment2 ?? "";
        stairs1Controller.text = d.numberOfStairs ?? "";
        stairs2Controller.text = d.numberOfStairs2 ?? "";

        stair1 = d.staircase == "1";
        elevator1 = d.elevators == "1";
        stair2 = d.staircase2 == "1";
        elevator2 = d.elevator2 == "1";


        byMe = d.itemPurchaseBy == "1";
        bySomeoneElse = !byMe;

        driverPrice = d.driverCost ?? "";
        adminPrice = d.adminCost ?? "";
        totalPrice = d.deliveryCost ?? "";

        packageList = d.package ?? [];
        packageCount = packageList.length;

      }
    } finally {
      _hideLoader();
      setState(() {});
    }
  }

  // ================= HELPERS =================
  bool _isRetail() => bookingTypeForUI == "retail";
  bool _shouldShowStairsElevator() => true;

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
        ),
        title: Text(
          "Details",
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColor.primaryColor,
          ),
        ),
        actions: [
          SvgPicture.asset("assets/images/track.svg", height: 40, width: 90),
        ],
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // PICKUP / DROP
            _pickupDropCard(),
            const SizedBox(height: 20),

            // TOP FIELDS
            _buildTopFieldsForBookingType(),
            const SizedBox(height: 18),

            // ================= ADDRESS BLOCK(S) =================





            if (_isRetail()) ...[

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  inputLabel("Store Name"),

                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        storeNameController.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Item Purchased By"),
                  const SizedBox(height: 6),
                  buildByMeRow(),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Purchaser Name"),

                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        purchaserNameController.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Purchaser Number"),
                  const SizedBox(height: 6),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        purchaserNumberController.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Unit or Appartment"),
                  const SizedBox(height: 6),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        unit2Controller.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      checkBoxstair(stair2, (v) {
                        setState(() {
                          stair2 = v!;
                          useStairs2Status = stair2 ? "1" : "0";
                          debugPrint("✅ useStairs1Status: $useStairs2Status");
                        });
                      }),
                      labelSmall("Have to Use Staircase"),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Number of Stairs"),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        stairs1Controller.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      checkBoxstair(elevator2, (v) {
                        setState(() {
                          elevator2 = v!;
                          useElevators2Status = elevator2 ? "1" : "0";
                          debugPrint("✅ useStairs1Status: $useElevators2Status");
                        });
                      }),
                      labelSmall("Can Use Elevators"),
                    ],
                  ),
                  inputLabel("Total Items"),

                  const SizedBox(height: 6),

                  // SUMMARY
                  readOnlyBox(
                    packageCount > 0
                        ? "$packageCount Package${packageCount > 1 ? 's' : ''}"
                        : "No packages",
                  ),

                  const SizedBox(height: 12),

                  // ================= PACKAGE LIST =================
                  if (packageCount > 0)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: packageList.length,
                      itemBuilder: (context, index) {
                        final Package pkg = packageList[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // TITLE
                              Text(
                                "Package ${index + 1}",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // CATEGORY
                              Text(
                                pkg.categoryName?.isNotEmpty == true
                                    ? pkg.categoryName!
                                    : "Category: -",
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),

                              // SUBCATEGORY
                              if (pkg.subcategory?.isNotEmpty == true) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Subcategory: ${pkg.subcategory}",
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ],

                              // QUANTITY
                              if (pkg.quantity?.isNotEmpty == true) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Quantity: ${pkg.quantity}",
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ],

                              // INSTRUCTION
                              if (pkg.instruction?.isNotEmpty == true) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Instruction: ${pkg.instruction}",
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),

                ],

              )

            ],

            if ((bookingTypeForUI=="online"||bookingTypeForUI=="onlinemarket")) ...[

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  inputLabel("Seller Name"),

                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        sellerNameController.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Seller Number"),

                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        sellerNumberController.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Item Purchased By"),
                  const SizedBox(height: 6),
                  buildByMeRow(),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Purchaser Name"),

                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        purchaserNameController.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Purchaser Number"),
                  const SizedBox(height: 6),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        purchaserNumberController.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Unit or Appartment"),
                  const SizedBox(height: 6),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        unit2Controller.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      checkBoxstair(stair2, (v) {
                        setState(() {
                          stair2 = v!;
                          useStairs2Status = stair2 ? "1" : "0";
                          debugPrint("✅ useStairs1Status: $useStairs2Status");
                        });
                      }),
                      labelSmall("Have to Use Staircase"),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Number of Stairs"),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        stairs1Controller.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      checkBoxstair(elevator2, (v) {
                        setState(() {
                          elevator2 = v!;
                          useElevators2Status = elevator2 ? "1" : "0";
                          debugPrint("✅ useStairs1Status: $useElevators2Status");
                        });
                      }),
                      labelSmall("Can Use Elevators"),
                    ],
                  ),
                  inputLabel("Total Items"),

                  const SizedBox(height: 6),

                  // SUMMARY
                  readOnlyBox(
                    packageCount > 0
                        ? "$packageCount Package${packageCount > 1 ? 's' : ''}"
                        : "No packages",
                  ),

                  const SizedBox(height: 12),

                  // ================= PACKAGE LIST =================
                  if (packageCount > 0)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: packageList.length,
                      itemBuilder: (context, index) {
                        final Package pkg = packageList[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // TITLE
                              Text(
                                "Package ${index + 1}",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // CATEGORY
                              Text(
                                pkg.categoryName?.isNotEmpty == true
                                    ? pkg.categoryName!
                                    : "Category: -",
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),

                              // SUBCATEGORY
                              if (pkg.subcategory?.isNotEmpty == true) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Subcategory: ${pkg.subcategory}",
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ],

                              // QUANTITY
                              if (pkg.quantity?.isNotEmpty == true) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Quantity: ${pkg.quantity}",
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ],

                              // INSTRUCTION
                              if (pkg.instruction?.isNotEmpty == true) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Instruction: ${pkg.instruction}",
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),

                ],

              )

            ],

            if ((bookingTypeForUI=="furnituredelivery"||bookingTypeForUI=="furniture")) ...[

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  inputLabel("Unit or Appartment"),
                  const SizedBox(height: 6),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        unit1Controller.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      checkBoxstair(stair1, (v) {
                        setState(() {
                          stair1 = v!;
                          useStairs1Status = stair1 ? "1" : "0";
                          debugPrint("✅ useStairs1Status: $useStairs1Status");
                        });
                      }),
                      labelSmall("Have to Use Staircase"),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Number of Stairs"),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        stairs1Controller.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      checkBoxstair(elevator1, (v) {
                        setState(() {
                          elevator1 = v!;
                          useElevators1Status = elevator1 ? "1" : "0";
                          debugPrint("✅ useStairs1Status: $useElevators1Status");
                        });
                      }),
                      labelSmall("Can Use Elevators"),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Unit or Appartment"),
                  const SizedBox(height: 6),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        unit2Controller.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      checkBoxstair(stair2, (v) {
                        setState(() {
                          stair2 = v!;
                          useStairs2Status = stair2 ? "1" : "0";
                          debugPrint("✅ useStairs2Status: $useStairs2Status");
                        });
                      }),
                      labelSmall("Have to Use Staircase"),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Number of Stairs"),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        stairs2Controller.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      checkBoxstair(elevator2, (v) {
                        setState(() {
                          elevator2 = v!;
                          useElevators2Status = elevator2 ? "1" : "0";
                          debugPrint("✅ useStairs1Status: $useElevators2Status");
                        });
                      }),
                      labelSmall("Can Use Elevators"),
                    ],
                  ),
                  inputLabel("Total Items"),

                  const SizedBox(height: 6),

                  // SUMMARY
                  readOnlyBox(
                    packageCount > 0
                        ? "$packageCount Package${packageCount > 1 ? 's' : ''}"
                        : "No packages",
                  ),

                  const SizedBox(height: 12),

                  // ================= PACKAGE LIST =================
                  if (packageCount > 0)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: packageList.length,
                      itemBuilder: (context, index) {
                        final Package pkg = packageList[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // TITLE
                              Text(
                                "Package ${index + 1}",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // CATEGORY
                              Text(
                                pkg.categoryName?.isNotEmpty == true
                                    ? pkg.categoryName!
                                    : "Category: -",
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),

                              // SUBCATEGORY
                              if (pkg.subcategory?.isNotEmpty == true) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Subcategory: ${pkg.subcategory}",
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ],

                              // QUANTITY
                              if (pkg.quantity?.isNotEmpty == true) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Quantity: ${pkg.quantity}",
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ],

                              // INSTRUCTION
                              if (pkg.instruction?.isNotEmpty == true) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Instruction: ${pkg.instruction}",
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),

                ],

              )

            ],

            if ((bookingTypeForUI=="movinghelp"||bookingTypeForUI=="moving")) ...[

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  inputLabel("Unit or Appartment"),
                  const SizedBox(height: 6),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        unit1Controller.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      checkBoxstair(stair1, (v) {
                        setState(() {
                          stair1 = v!;
                          useStairs1Status = stair1 ? "1" : "0";
                          debugPrint("✅ useStairs1Status: $useStairs1Status");
                        });
                      }),
                      labelSmall("Have to Use Staircase"),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Number of Stairs"),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        stairs1Controller.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      checkBoxstair(elevator1, (v) {
                        setState(() {
                          elevator1 = v!;
                          useElevators1Status = elevator1 ? "1" : "0";
                          debugPrint("✅ useStairs1Status: $useElevators1Status");
                        });
                      }),
                      labelSmall("Can Use Elevators"),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Unit or Appartment"),
                  const SizedBox(height: 6),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        unit2Controller.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      checkBoxstair(stair2, (v) {
                        setState(() {
                          stair2 = v!;
                          useStairs2Status = stair2 ? "1" : "0";
                          debugPrint("✅ useStairs2Status: $useStairs2Status");
                        });
                      }),
                      labelSmall("Have to Use Staircase"),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Number of Stairs"),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        stairs2Controller.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      checkBoxstair(elevator2, (v) {
                        setState(() {
                          elevator2 = v!;
                          useElevators2Status = elevator2 ? "1" : "0";
                          debugPrint("✅ useStairs1Status: $useElevators2Status");
                        });
                      }),
                      labelSmall("Can Use Elevators"),
                    ],
                  ),
                  inputLabel("Total Items"),

                  const SizedBox(height: 6),

                  // SUMMARY
                  readOnlyBox(
                    packageCount > 0
                        ? "$packageCount Package${packageCount > 1 ? 's' : ''}"
                        : "No packages",
                  ),

                  const SizedBox(height: 12),

                  // ================= PACKAGE LIST =================
                  if (packageCount > 0)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: packageList.length,
                      itemBuilder: (context, index) {
                        final Package pkg = packageList[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // TITLE
                              Text(
                                "Package ${index + 1}",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // CATEGORY
                              Text(
                                pkg.categoryName?.isNotEmpty == true
                                    ? pkg.categoryName!
                                    : "Category: -",
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),

                              // SUBCATEGORY
                              if (pkg.subcategory?.isNotEmpty == true) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Subcategory: ${pkg.subcategory}",
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ],

                              // QUANTITY
                              if (pkg.quantity?.isNotEmpty == true) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Quantity: ${pkg.quantity}",
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ],

                              // INSTRUCTION
                              if (pkg.instruction?.isNotEmpty == true) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Instruction: ${pkg.instruction}",
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),

                ],

              )

            ],

            if ((bookingTypeForUI=="courierservice"||bookingTypeForUI=="courier")) ...[

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  inputLabel("Send By"),
                  const SizedBox(height: 6),
                  buildByMeRow(),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Name"),
                  const SizedBox(height: 6),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        sellerNameController.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Phone Number"),
                  const SizedBox(height: 6),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        sellerNumberController.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  inputLabel("Unit or Appartment"),
                  const SizedBox(height: 6),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        unit1Controller.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      checkBoxstair(stair1, (v) {
                        setState(() {
                          stair1 = v!;
                          useStairs1Status = stair1 ? "1" : "0";
                          debugPrint("✅ useStairs1Status: $useStairs1Status");
                        });
                      }),
                      labelSmall("Have to Use Staircase"),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Number of Stairs"),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        stairs1Controller.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      checkBoxstair(elevator1, (v) {
                        setState(() {
                          elevator1 = v!;
                          useElevators1Status = elevator1 ? "1" : "0";
                          debugPrint("✅ useStairs1Status: $useElevators1Status");
                        });
                      }),
                      labelSmall("Can Use Elevators"),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Name"),

                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        purchaserNameController.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Phone Number"),
                  const SizedBox(height: 6),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        purchaserNumberController.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Unit or Appartment"),
                  const SizedBox(height: 6),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        unit2Controller.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      checkBoxstair(stair2, (v) {
                        setState(() {
                          stair2 = v!;
                          useStairs2Status = stair2 ? "1" : "0";
                          debugPrint("✅ useStairs2Status: $useStairs2Status");
                        });
                      }),
                      labelSmall("Have to Use Staircase"),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  inputLabel("Number of Stairs"),
                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.secondaryColor,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Text(
                        stairs2Controller.text,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      checkBoxstair(elevator2, (v) {
                        setState(() {
                          elevator2 = v!;
                          useElevators2Status = elevator2 ? "1" : "0";
                          debugPrint("✅ useStairs1Status: $useElevators2Status");
                        });
                      }),
                      labelSmall("Can Use Elevators"),
                    ],
                  ),
                  inputLabel("Total Items"),

                  const SizedBox(height: 6),

                  // SUMMARY
                  readOnlyBox(
                    packageCount > 0
                        ? "$packageCount Package${packageCount > 1 ? 's' : ''}"
                        : "No packages",
                  ),

                  const SizedBox(height: 12),

                  // ================= PACKAGE LIST =================
                  if (packageCount > 0)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: packageList.length,
                      itemBuilder: (context, index) {
                        final Package pkg = packageList[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // TITLE
                              Text(
                                "Package ${index + 1}",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // CATEGORY
                              Text(
                                pkg.categoryName?.isNotEmpty == true
                                    ? pkg.categoryName!
                                    : "Category: -",
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),

                              // SUBCATEGORY
                              if (pkg.subcategory?.isNotEmpty == true) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Subcategory: ${pkg.subcategory}",
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ],

                              // QUANTITY
                              if (pkg.quantity?.isNotEmpty == true) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Quantity: ${pkg.quantity}",
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ],

                              // INSTRUCTION
                              if (pkg.instruction?.isNotEmpty == true) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Instruction: ${pkg.instruction}",
                                  style: GoogleFonts.poppins(fontSize: 12),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),

                ],

              )

            ],


          ],
        ),
      ),

      // ================= BOTTOM =================
      bottomNavigationBar: _bottomBar(),
    );
  }

  // ================= SMALL WIDGETS =================

  // ----------------------- BY ME ROW -----------------------
  Widget buildByMeRow() {
    return Row(
      children: [
        checkBox(byMe),
        readOnlyBox("By Me"),
        const SizedBox(width: 20),
        checkBox(bySomeoneElse),
        readOnlyBox("Someone Else"),
      ],
    );
  }


  // ---------------- CHECKBOX ----------------
  Widget checkBox(bool value) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4),
        color: value ? Colors.black : Colors.white,
      ),
      child: value
          ? const Icon(Icons.check, size: 16, color: Colors.white)
          : null,
    );
  }

  // ---------------- CHECKBOX ----------------
  Widget checkBoxstair(bool value, Function(bool?) onChanged) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      activeColor: Colors.black,
      side: const BorderSide(color: Colors.black, width: 1.2),
    );
  }

  Widget _pickupDropCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFD),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          Image.asset("assets/images/pickupDropup.png", height: 120),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                locationTile("Pickup", pickupController.text),
                const Divider(),
                locationTile("Drop-Off", dropController.text),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          priceText("Status: ${deliverystatus}"),
          const Divider(),

          Text(
            "Total Price: ${AppSession().currency == "NGN" ? "₦" : "£"}$totalPrice",
            style:  TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColor.secondprimaryColor,
            ),
            // style: GoogleFonts.poppins(
            //   fontSize: 20,
            //   fontWeight: FontWeight.w700,
            //   color: AppColor.secondprimaryColor,
            // ),
          ),

          const SizedBox(height: 14),
        if (deliverystatus == "Accepted" || deliverystatus == "Inprogress")
    InkWell(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title:  Text("Cancel Delivery",     style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),),
            content:  Text("Do you want to cancel this delivery?",  style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
            ),),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // CANCEL
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "No",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
// OKAY
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context); // close dialog

                      _showLoader();

                      try {
                        await cancelDelivery(); // API only
                      } catch (e) {
                        debugPrint("❌ Cancel delivery error: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Failed to cancel delivery"),
                          ),
                        );
                      } finally {
                        _hideLoader();

                        // ✅ NAVIGATE AFTER LOADER
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                              (route) => false,
                        );
                      }
                    },
                    child: Text(
                      "Yes",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: AppColor.secondaryColor, // white
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );


      },
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColor.primaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "Cancel",
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColor.secondaryColor,
          ),
        ),
      ),
    )


    ],
      ),
    );
  }




  Future<void> cancelDelivery() async {
    await AuthService.cancelDelivery(
      user_id: AppSession().userId,
      order_id: widget.orderId.toString(),
    );
  }





  // ================= COMMON UI =================
  Widget readOnlyBox(String text) => Container(
    height: 50,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 5,
          offset: const Offset(1, 3),
        ),
      ],
    ),
    padding: const EdgeInsets.symmetric(horizontal: 15),
    alignment: Alignment.centerLeft,
    child: Text(text.isNotEmpty ? text : "-"),
  );

  Widget locationTile(String title, String address) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
      Text(address, style: GoogleFonts.poppins(fontSize: 12.5)),
    ],
  );

  Widget toggleTile(String title, bool value) => Row(
    children: [
      Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(6),
          color: value ? AppColor.secondprimaryColor : Colors.white,
        ),
        child: value
            ? Icon(Icons.check, size: 16, color: AppColor.secondaryColor)
            : null,
      ),
      const SizedBox(width: 10),
      Text(title, style: GoogleFonts.poppins(fontSize: 14)),
    ],
  );

  Widget priceText(String text) => Text(
    text,
    style: GoogleFonts.poppins(
        fontSize: 16, fontWeight: FontWeight.w600),
  );

  Widget sectionTitle(String text) => Text(
    text,
    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
  );

  Widget inputLabel(String text) => Text(
    text,
    style: GoogleFonts.poppins(
        fontSize: 14, fontWeight: FontWeight.w500),
  );

  Widget label(String text) => Text(
    text,
    style: GoogleFonts.poppins(
        fontSize: 15, fontWeight: FontWeight.w500),
  );

  // ================= ACTION APIs =================
  Future<void> _acceptDelivery() async {
    final String driverId = AppSession().userId;
    final String orderId = widget.orderId.toString();

    _showLoader(); // ✅ SHOW LOADER

    try {
      debugPrint("📤 ACCEPT DELIVERY REQUEST");
      debugPrint("➡ driver_id: $driverId");
      debugPrint("➡ order_id: $orderId");

      final res = await AuthService.acceptDeliveryRequest(
        driver_id: driverId,
        order_id: orderId,
      );

      debugPrint("📥 ACCEPT DELIVERY RESPONSE: $res");

      await _fetchDeliveryDetail(); // refresh UI
    } catch (e) {
      debugPrint("❌ ACCEPT DELIVERY ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to accept delivery")),
      );
    } finally {
      _hideLoader(); // ✅ ALWAYS HIDE LOADER
    }
  }







  // ---------------- SMALL LABEL ----------------
  Widget labelSmall(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: AppColor.primaryColor,
        fontSize: 15,
      ),
    );
  }


  Widget _buildTopFieldsForBookingType() {
    // UNCHANGED FROM YOUR CODE
    return const SizedBox();
  }
}
