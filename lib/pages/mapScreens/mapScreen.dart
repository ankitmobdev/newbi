// map_screens.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng _initialLatLng = LatLng(37.7749, -122.4194); // default (San Francisco)
  LatLng? _pickedLocation;

  // sample pickup/drop data (you'll replace with real)
  final String pickupAddress = "Moscow-City, Empire - K2 484P4";
  final String dropAddress = "105 William St, Chicago, US";

  @override
  void initState() {
    super.initState();
    _pickedLocation = _initialLatLng;
  }

  Future<void> _moveCamera(LatLng target, {double zoom = 15}) async {
    final controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: target, zoom: zoom),
    ));
  }

  void _onMapTap(LatLng latLng) {
    setState(() {
      _pickedLocation = latLng;
    });
  }

  void _onNextPressed() {
    // Example: Navigate to LocationPickerScreen and pass current picked location
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LocationPickerScreen(
          initialPosition: _pickedLocation ?? _initialLatLng,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final markers = <Marker>{
      if (_pickedLocation != null)
        Marker(
          markerId: const MarkerId('selected'),
          position: _pickedLocation!,
        ),
    };

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _initialLatLng, zoom: 13),
            myLocationEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: markers,
            onTap: _onMapTap,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // top-left white card with pickup + drop
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
                  ),
                  width: MediaQuery.of(context).size.width * 0.92,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pickup
                      Row(
                        children: [
                          Container(
                            height: 10, width: 10,
                            decoration: BoxDecoration(color: const Color(0xff00C27A), shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Pickup",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(pickupAddress, style: TextStyle(color: Colors.black87)),
                      ),

                      const SizedBox(height: 8),

                      // Drop off
                      Row(
                        children: [
                          Container(
                            height: 10, width: 10,
                            decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Drop-Off",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(dropAddress, style: TextStyle(color: Colors.black87)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // bottom Next button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
              child: SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onNextPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Next"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Screen 2: centered pin + single pickup card + "Select Location" button
class LocationPickerScreen extends StatefulWidget {
  final LatLng initialPosition;
  const LocationPickerScreen({super.key, required this.initialPosition});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late LatLng _cameraPosition;
  Marker? _centerMarker;

  @override
  void initState() {
    super.initState();
    _cameraPosition = widget.initialPosition;
    _centerMarker = Marker(markerId: const MarkerId('center'), position: _cameraPosition);
  }

  void _onCameraMove(CameraPosition pos) {
    // track camera center
    _cameraPosition = pos.target;
  }

  void _onCameraIdle() {
    setState(() {
      _centerMarker = Marker(markerId: const MarkerId('center'), position: _cameraPosition);
    });
  }

  void _onSelect() {
    // Return selected LatLng to previous screen or handle accordingly
    Navigator.pop(context, _cameraPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: widget.initialPosition, zoom: 15),
            onMapCreated: (controller) => _controller.complete(controller),
            onCameraMove: _onCameraMove,
            onCameraIdle: _onCameraIdle,
            markers: _centerMarker != null ? {_centerMarker!} : {},
            zoomControlsEnabled: false,
          ),

          // Top centered pickup card
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
                  ),
                  width: MediaQuery.of(context).size.width * 0.86,
                  child: Column(
                    children: [
                      Text("Pickup", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(
                        "${_cameraPosition.latitude.toStringAsFixed(5)}, ${_cameraPosition.longitude.toStringAsFixed(5)}",
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Center pin overlay (optional visual)
          Align(
            alignment: Alignment.center,
            child: IgnorePointer(
              child: Image.asset(
                "assets/images/map_pin.png", // make sure this asset exists
                height: 48,
                width: 48,
              ),
            ),
          ),

          // Bottom Select Location button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _onSelect,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Select Location"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
