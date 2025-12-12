import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;
import '../../constant.dart';   // <-- AppColor (secondaryColor, textColor)

typedef CallBackFunction = void Function(
    String location, double latitude, double longitude);

class LocationWidget extends StatefulWidget {
  final CallBackFunction callback;

  LocationWidget({required this.callback});

  @override
  State<LocationWidget> createState() => LocationWidgetUI();
}

class LocationService {
  Future<bool> _requestLocationPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
      return false;
    }
    PermissionStatus permissionStatus = await Permission.location.request();

    if (permissionStatus == PermissionStatus.granted) return true;

    if (permissionStatus == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
    }
    return false;
  }

  Future<Position?> getCurrentLocations(BuildContext context) async {
    if (Platform.isAndroid) {
      bool permissionGranted = await _requestLocationPermission();
      if (!permissionGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Location permission required")),
        );
        return null;
      }
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }
}

class LocationWidgetUI extends State<LocationWidget> {
  final String googleApikey = "AIzaSyCRMjSEuYwTni9VcanTdHCptPfmly0htCc";

  GoogleMapController? mapController;
  LatLng startLocation = const LatLng(22.717807, 75.8780294);

  String location = "Search Location";
  double? latitude;
  double? longitude;

  bool isLoading = true; // ✅ LOADER FLAG

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      getCurrentLocation();
    } else {
      getAndroidLocation(context);
    }
  }

  void getAndroidLocation(BuildContext context) async {
    try {
      final position = await LocationService().getCurrentLocations(context);
      if (position == null) return;

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        startLocation = LatLng(position.latitude, position.longitude);
        latitude = position.latitude;
        longitude = position.longitude;

        location =
        "${placemarks.first.street}, ${placemarks.first.subLocality}, ${placemarks.first.locality}, ${placemarks.first.administrativeArea}";

        isLoading = false; // ✅ STOP LOADER
      });
    } catch (e) {
      debugPrint("Location error: $e");
      setState(() => isLoading = false);
    }
  }

  void getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        startLocation = LatLng(position.latitude, position.longitude);
        latitude = position.latitude;
        longitude = position.longitude;

        location =
        "${placemarks.first.street}, ${placemarks.first.subLocality}, ${placemarks.first.locality}, ${placemarks.first.administrativeArea}";
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Location error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,

      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Select Location",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),

      body: Stack(
        children: [
          // ================= MAP =================
          if (!isLoading)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: startLocation,
                zoom: 14,
              ),
              mapType: MapType.normal,
              onMapCreated: (controller) => mapController = controller,
              onCameraMove: (position) async {
                final t = position.target;
                final placemarks =
                await placemarkFromCoordinates(t.latitude, t.longitude);

                setState(() {
                  latitude = t.latitude;
                  longitude = t.longitude;
                  location =
                  "${placemarks.first.street}, ${placemarks.first.locality}";
                });
              },
            ),

          // ================= MAP PIN =================
          if (!isLoading)
            Center(
              child: Image.asset("assets/images/mapIcon.png"),
            ),

          // ================= SEARCH BAR =================
          if (!isLoading)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: _searchBar(context),
            ),

          // ================= SELECT BUTTON =================
          if (!isLoading)
            Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  if (latitude != null && longitude != null) {
                    widget.callback(location, latitude!, longitude!);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Select Address",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          // ================= LOADER =================
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.35),
              child: Center(
                child: Lottie.asset(
                  'assets/animation/dots_loader.json',
                  width: 120,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final place = await PlacesAutocomplete.show(
          context: context,
          apiKey: googleApikey,
          mode: Mode.overlay,
        );

        if (place == null) return;

        setState(() => location = place.description!);

        final places = GoogleMapsPlaces(
          apiKey: googleApikey,
          apiHeaders: await GoogleApiHeaders().getHeaders(),
        );

        final detail = await places.getDetailsByPlaceId(place.placeId!);
        final lat = detail.result.geometry!.location.lat;
        final lng = detail.result.geometry!.location.lng;

        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(lat, lng), 17),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.black54),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

