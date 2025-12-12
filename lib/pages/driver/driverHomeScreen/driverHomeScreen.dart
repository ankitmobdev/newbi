import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_eat_e_commerce_app/models/nearbyModel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:lottie/lottie.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as local_notifications;
import '../../../SharedPreference/AppSession.dart';
import '../../../constant.dart';
import '../../../main.dart';
import '../../../models/profilemodel.dart';
import '../../../services/auth_service.dart';

import '../driverDrawerScreen/availableDeliveries.dart';
import '../driverDrawerScreen/detailScreenDriver.dart';
import '../driverDrawerScreen/drawerScreenDriver.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  gmap.GoogleMapController? mapController;
  StreamSubscription<Position>? _positionStream;
  ProfileModel? profileModel;
  bool isOnline = true;

  gmap.LatLng? driverLocation;
  final Set<gmap.Marker> _markers = {};
  List<NearByData> deliveryList = [];

  gmap.BitmapDescriptor? deliveryMarkerIcon;

  // ================= INIT =================
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadMarkerIcon();
      fetchProfile();
      await _loadCurrentLocation();
      await fetchNearByDeliveries();
    });
    _listenFCMNotifications();   //

    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 60, // Minimum distance in meters before update
    );
    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      trackDriverLocation(AppSession().userId, "Car", position);
    });
  }
  void _listenFCMNotifications() {
    FirebaseMessaging.onMessage.listen((message) {
      print("📩 Foreground Notification Received");
      _showLocalNotification(message);

      // Auto refresh data
      fetchNearByDeliveries();
      fetchProfile();
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("📲 Notification opened from background");

      fetchNearByDeliveries();
      fetchProfile();
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("🚀 Opened from terminated state");

        fetchNearByDeliveries();
        fetchProfile();
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


  void trackDriverLocation(String driverId, String vehicleType, Position position) async {
    DatabaseReference databaseRef = FirebaseDatabase.instance.reference();
    Map<String, dynamic> locationData = {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'driver_id': AppSession().userId,
      'vehicle_type': vehicleType.toLowerCase(),
    };
    databaseRef.child('driver_list').child(driverId).set(locationData).then((_) {
      print("Location updated: $locationData");
/*Fluttertoast.showToast(
msg: 'Location updated successfully',
toastLength: Toast.LENGTH_SHORT, // This makes the toast short
gravity: ToastGravity.BOTTOM,
);*/
    }).catchError((error) {
      print("Failed to update location: $error");
    });
  }


  // ================= LOAD CUSTOM MARKER =================
  Future<void> _loadMarkerIcon() async {
    deliveryMarkerIcon = await gmap.BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/mapIcon.png',
    );
  }

  // ================= CURRENT LOCATION =================
  Future<void> _loadCurrentLocation() async {
    final loc = await _getCurrentLocation();

    driverLocation = gmap.LatLng(loc["lat"]!, loc["lng"]!);

    _markers.add(
      gmap.Marker(
        markerId: const gmap.MarkerId("driver"),
        position: driverLocation!,
        icon: gmap.BitmapDescriptor.defaultMarkerWithHue(
          gmap.BitmapDescriptor.hueBlue,
        ),
        infoWindow: const gmap.InfoWindow(title: "You"),
      ),
    );

    setState(() {});
  }

  // ================= PROFILE =================
  Future<void> fetchProfile() async {
    showLoader();
    try {
      final profile = await AuthService.getProfile(AppSession().userId);
      profileModel = profile;
      isOnline = profile.data?.online_status == "1";
    } catch (e) {
      debugPrint("❌ Profile error: $e");
    }
    hideLoader();
    setState(() {});
  }

  // ================= NEARBY DELIVERIES =================
  Future<void> fetchNearByDeliveries() async {
    showLoader();
    try {
      final loc = await _getCurrentLocation();

      final res = await AuthService.nearbyDelivery(
        user_id: AppSession().userId,
        latitude: loc["lat"].toString(),
        longitude: loc["lng"].toString(),
      );

      final model = NearByDeliveryModel.fromJson(res);

      if (model.result == "true" || model.result == "success") {
        deliveryList = model.data ?? [];
        _addDeliveryMarkers();
      }
    } catch (e) {
      debugPrint("❌ Nearby error: $e");
    }
    hideLoader();
    setState(() {});
  }

  // ================= ADD DELIVERY MARKERS =================
  void _addDeliveryMarkers() {
    if (driverLocation == null) return;

    for (int i = 0; i < deliveryList.length; i++) {
      final d = deliveryList[i];

      final double offset = 0.001 * (i + 1); // API has no lat/lng

      final position = gmap.LatLng(
        driverLocation!.latitude + offset,
        driverLocation!.longitude + offset,
      );

      _markers.add(
        gmap.Marker(
          markerId: gmap.MarkerId("order_${d.orderId}"),
          position: position,
          icon: deliveryMarkerIcon ?? gmap.BitmapDescriptor.defaultMarker,
          infoWindow: gmap.InfoWindow(
            title: "Order #${d.orderId}",
            snippet: d.pickupaddress,
          ),
          onTap: () {
            Helper.moveToScreenwithPush(
              context,
              DetailsFormDriverScreen(orderId: d.orderId),
            );
          },
        ),
      );
    }
  }

  // ================= ONLINE STATUS =================
  Future<void> updateOnlineStatus(bool status) async {
    setState(() => isOnline = status);
    showLoader();

    try {
      final res = await AuthService.preference(
        user_id: AppSession().userId,
        type: "online",
        value: status ? "1" : "0",
      );

      if (res["result"] != "success") {
        setState(() => isOnline = !status);
      }
    } catch (_) {
      setState(() => isOnline = !status);
    }

    hideLoader();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DriverCustomSideBar(),
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 1,
      //   centerTitle: true,
      //   leading: Builder(
      //     builder: (context) => IconButton(
      //       icon: const Icon(Icons.menu, color: Colors.black),
      //       onPressed: () => Scaffold.of(context).openDrawer(),
      //     ),
      //   ),
      //   title: Text(
      //     "Home",
      //     style: GoogleFonts.poppins(
      //       fontSize: 18,
      //       fontWeight: FontWeight.w600,
      //       color: Colors.black,
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        elevation: 1,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          "Home",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: _onlineSwitch()),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          final exitApp = await showDialog<bool>(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Exit App?"),
              content: const Text("Do you really want to close the app?"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("No")),
                TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Yes")),
              ],
            ),
          );

          if (exitApp == true) exit(0);
          return false;
        },
        child: Stack(
          children: [
            gmap.GoogleMap(
              initialCameraPosition: gmap.CameraPosition(
                target: driverLocation ??
                    const gmap.LatLng(22.717807, 75.8780294),
                zoom: 14,
              ),
              markers: _markers,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              onMapCreated: (controller) => mapController = controller,
            ),

            Positioned(
              bottom: 20,
              left: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  Helper.moveToScreenwithPush(
                    context,
                    AvailableDeliveriesScreen(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Nearby Deliveries",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
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

  Widget _onlineSwitch() {
    return GestureDetector(
      onTap: () => updateOnlineStatus(!isOnline),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 22,
        width: 42,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: isOnline ? Colors.green : Colors.grey.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Align(
          alignment: isOnline ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            height: 17,
            width: 17,
            decoration:
            const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // ================= LOADER =================
  void showLoader() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => Center(
        child: Lottie.asset('assets/animation/dots_loader.json'),
      ),
    );
  }

  void hideLoader() {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  // ================= LOCATION =================
  Future<Map<String, double>> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return {"lat": pos.latitude, "lng": pos.longitude};
  }
}
