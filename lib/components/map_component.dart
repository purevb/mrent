import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapComponent extends StatefulWidget {
  final double longitude;
  final double latitude;
  const MapComponent({
    required this.latitude,
    required this.longitude,
    super.key,
  });

  @override
  State<MapComponent> createState() => MapSampleState();
}

class MapSampleState extends State<MapComponent> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late Set<Marker> _markers;

  @override
  void initState() {
    super.initState();

    _markers = {
      Marker(
        markerId: const MarkerId('custom_location'),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: const InfoWindow(title: 'My Location'),
      ),
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _goToLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final CameraPosition initialPosition = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 14.4746,
    );

    return Scaffold(
      body: GoogleMap(
        mapType: MapType.terrain,
        initialCameraPosition: initialPosition,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  Future<void> _goToLocation() async {
    final GoogleMapController controller = await _controller.future;
    final CameraPosition myLocation = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 16.0,
    );
    await controller.animateCamera(CameraUpdate.newCameraPosition(myLocation));
  }
}
