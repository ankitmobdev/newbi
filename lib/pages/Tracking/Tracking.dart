import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../constant.dart';
import '../../services/api_constants.dart';


class Tracking extends StatefulWidget {

  String pickup_address = "";
  dynamic pick_lat;
  dynamic pick_long;
  dynamic drop_lat;
  dynamic drop_long;
  String drop_address = "";
  String driver_id = "";

  Tracking({required this.pickup_address,this.pick_lat,this.drop_long,this.drop_lat,this.pick_long,
    required this.drop_address, required this.driver_id});

  @override
  State<Tracking> createState() => TrackingScreen();
}

class TrackingScreen extends State<Tracking> {

  List<LatLng> _routeCoordinates = [];
  GoogleMapController? _mapController;
  BitmapDescriptor? customIcon;
  BitmapDescriptor? customIcon2;
  BitmapDescriptor? customIcon3;
  BitmapDescriptor? customIconx;
  LatLng? previousLatLng;

  late DatabaseReference _databaseRef;
  late LatLng driverLatLng;

  final Set<Marker> _markers = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /*driverMarker = Marker(
      markerId: MarkerId('driver_marker'),
      position: LatLng(22.7196, 75.8577), // Default position (can be updated later)
      icon: BitmapDescriptor.defaultMarker,
    );*/

    drawRoute(double.parse(widget.pick_lat),
        double.parse(widget.pick_long),
        double.parse(widget.drop_lat),
        double.parse(widget.drop_long));

    _databaseRef = FirebaseDatabase.instance.reference();
    _loadCustomMarker();
    loadCustomIcon();
    listenToDriverLocation(widget.driver_id!);

  }
// Android :- 120*120 
// IOS :- 60*60
  Future<BitmapDescriptor> getCustomIcon() async {
  final ImageConfiguration imageConfiguration = ImageConfiguration(size: Size(120, 120)); // Adjust size here
  BitmapDescriptor customIconx = await BitmapDescriptor.fromAssetImage(
    imageConfiguration,
    'assets/images/driver_pin.png', // Replace with your icon path
  );
  return customIconx;
}

void loadCustomIcon() async {
  customIconx = await getCustomIcon();
  setState(() {}); // Rebuild to apply the new icon
}

  // Function to load the custom PNG marker icon from assets
  Future<void> _loadCustomMarker() async {
    customIcon = await BitmapDescriptor.fromAssetImage(
     ImageConfiguration(size: Size(90, 90)), // Adjust size as needed
      'assets/images/pick_pin.png',
    );
    customIcon2 = await BitmapDescriptor.fromAssetImage(
       ImageConfiguration(size: Size(90, 90)), // Adjust size as needed
      'assets/images/drop_pin.png',
    );
    customIcon3 = await BitmapDescriptor.fromAssetImage(
       ImageConfiguration(size: Size(120, 120)), // Adjust size as needed
      'assets/images/driver_pin.png',
    );

    _markers.add(
      Marker(
        onTap: () {
        },
        markerId: MarkerId('pickup'),
        position: LatLng(double.parse(widget.pick_lat), double.parse(widget.pick_long)),
        icon: customIcon ?? BitmapDescriptor.defaultMarker, // Use default if icon is not loaded yet
        infoWindow: InfoWindow(title: widget.pickup_address),
      ),
    );

    _markers.add(
      Marker(
        onTap: () {
        },
        markerId: MarkerId('dropoff'),
        position: LatLng(double.parse(widget.drop_lat), double.parse(widget.drop_long)),
        icon: customIcon2 ?? BitmapDescriptor.defaultMarker, // Use default if icon is not loaded yet
        infoWindow: InfoWindow(title: widget.drop_address),
      ),
    );

    setState((){});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.secondaryColor,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child:  Icon(Icons.arrow_back_ios,
              size: 20, color: AppColor.primaryColor),
        ),
        title: Text(
          "Tracking",
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: AppColor.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
      child:  GoogleMap(
          onMapCreated: (controller) {
            _mapController = controller;
            zoomOutPolyline();
          },
        markers: _markers,
        polylines: {
          Polyline(
            polylineId: PolylineId('route'),
            color: AppColor.primaryColor,
            points: _routeCoordinates,
            width: 4,
          ),
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(double.parse(widget.pick_lat), double.parse(widget.pick_long)),
          zoom: 10,
        ),
        ),
      ),
    );
  }

  void drawRoute(double pickupLatitude, double pickupLongitude, double dropoffLatitude, double dropoffLongitude) async {
    _routeCoordinates.clear(); // Clear previous route

    final origin = '$pickupLatitude,$pickupLongitude';
    final destination = '$dropoffLatitude,$dropoffLongitude';

    final apiKey = ApiAction.googleMapKey; // Replace with your actual Google Maps API key
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&mode=driving&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final routes = json['routes'];

        if (routes != null && routes.isNotEmpty) {
          final route = routes[0];
          final overviewPolyline = route['overview_polyline'];
          final points = overviewPolyline['points'];

          if (points != null) {
            List<LatLng> decodedRoute = decodePolyline(points);

            setState(() {
              _routeCoordinates = decodedRoute;
            });

            // Fit map bounds to show the entire route
            LatLngBounds bounds = boundsFromLatLngList(decodedRoute);
            _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
          } else {
            // Handle no points in the polyline
            print("No points in the polyline");
          }
        } else {
          // Handle no route found
          print("No route found");
        }
      } else {
        // Handle error response
        print("Error fetching route: ${response.statusCode}");
      }
    } catch (e) {
      // Handle network or other exceptions
      print("Exception during route fetching: $e");
    }
  }

  void zoomOutPolyline() {
    if (_routeCoordinates.isEmpty || _mapController == null) return;

    double minLat = _routeCoordinates.first.latitude;
    double maxLat = _routeCoordinates.first.latitude;
    double minLng = _routeCoordinates.first.longitude;
    double maxLng = _routeCoordinates.first.longitude;

    // Finding the bounds of the polyline coordinates
    for (LatLng point in _routeCoordinates) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    // Creating LatLngBounds
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    // Zooming the camera to fit the bounds
    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        bounds,
        50, // padding
      ),
    );
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    double minLat = list.first.latitude;
    double maxLat = list.first.latitude;
    double minLng = list.first.longitude;
    double maxLng = list.first.longitude;
    for (LatLng latLng in list) {
      if (latLng.latitude > maxLat) maxLat = latLng.latitude;
      if (latLng.latitude < minLat) minLat = latLng.latitude;
      if (latLng.longitude > maxLng) maxLng = latLng.longitude;
      if (latLng.longitude < minLng) minLng = latLng.longitude;
    }
    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  void listenToDriverLocation(String driverId) {
    print("lat_3===${driverId}");
    _databaseRef.child('driver_list').child(driverId).onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        double latitude = data['latitude'];
        double longitude = data['longitude'];
         print("lat_1===${driverId}");
      
      LatLng newLatLng = LatLng(latitude, longitude);
      
      if (previousLatLng != null) {
        animateMarker(previousLatLng!, newLatLng);
      } else {
        // Set the initial position if it's the first update
        previousLatLng = newLatLng;
        driverLatLng = newLatLng;
        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId('driver_marker'),
              position: driverLatLng,
              icon: customIconx ?? BitmapDescriptor.defaultMarker,
            ),
          );
        });
      }
      previousLatLng = newLatLng;
   // }

        // Handle driver marker updates (use setState if inside a stateful widget)
        // _markers['driver_marker'] = driverMarker;
      }
    });
  }

  void animateMarker(LatLng start, LatLng end) {
  const int animationDuration = 1000; // duration in milliseconds
  const int frameRate = 30; // frames per second
  int frameCount = animationDuration ~/ frameRate;

  Timer.periodic(Duration(milliseconds: frameRate), (timer) {
    final double progress = timer.tick / frameCount;

    double latitude = start.latitude + (end.latitude - start.latitude) * progress;
    double longitude = start.longitude + (end.longitude - start.longitude) * progress;

    driverLatLng = LatLng(latitude, longitude);

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('driver_marker'),
          position: driverLatLng,
          icon: customIconx ?? BitmapDescriptor.defaultMarker,
        ),
      );
    });
    if (progress >= 1.0) {
      timer.cancel();
    }
  });
}

}
