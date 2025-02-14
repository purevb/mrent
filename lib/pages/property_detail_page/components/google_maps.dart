import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _addMarkers();
  }

  void _addMarkers() {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('Charleston'),
          position: LatLng(
              37.42796133580664, -122.085749655962), // Example coordinates
          infoWindow: InfoWindow(title: 'Charleston'),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('Shoreline Parks'),
          position: LatLng(37.43296265331129, -122.08832357078792),
          infoWindow: InfoWindow(title: 'Shoreline Parks'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.hybrid,
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {},
      markers: _markers,
    );
  }
}
