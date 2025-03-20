import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mrent/components/main_appbar.dart';
import 'package:geocoding/geocoding.dart';

class MapSample extends StatefulWidget {
  const MapSample({
    required this.hasAppBar,
    this.onLocationSelected,
    super.key,
  });
  final bool hasAppBar;
  final Function(LatLng, String)? onLocationSelected;

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng _selectedLocation = const LatLng(47.921230, 106.918556);
  String _selectedAddress = "";
  bool _isLoading = false;

  static const CameraPosition _kUlaanbaatar = CameraPosition(
    target: LatLng(47.921230, 106.918556),
    zoom: 12.0,
  );

  @override
  void dispose() {
    _mapController?.dispose(); // Dispose of the controller
    super.dispose();
  }

  void _updateSelectedLocation(LatLng location) async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(location.latitude, location.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _selectedAddress =
            "${place.street}, ${place.locality}, ${place.country}";
      }

      setState(() {
        _selectedLocation = location;
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('selected_location'),
            position: location,
            infoWindow: InfoWindow(
              title: 'Selected Location',
              snippet: _selectedAddress,
            ),
          ),
        );
        _isLoading = false;
      });

      // Pass the selected location and address back to the parent widget
      if (widget.onLocationSelected != null) {
        widget.onLocationSelected!(_selectedLocation, _selectedAddress);
      }
    } catch (e) {
      print("Error updating location: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.hasAppBar == true
          ? MainAppBar(
              hasLeading: false,
              hasLocationBar: false,
              chooseType: (String) {},
            )
          : null,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          GoogleMap(
            key: const ValueKey(
                'google_map'), // Unique key for the GoogleMap widget
            mapType: MapType.normal,
            initialCameraPosition: _kUlaanbaatar,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onTap: _updateSelectedLocation,
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              children: [
                const SizedBox(height: 16),
                FloatingActionButton.extended(
                  heroTag: "btn2",
                  onPressed: () {
                    log("Selected Location: $_selectedLocation");
                    log("Selected Address: $_selectedAddress");
                  },
                  label: const Text('Confirm Location'),
                  icon: const Icon(Icons.check),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
