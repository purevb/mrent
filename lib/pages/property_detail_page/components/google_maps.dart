import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mrent/components/main_appbar.dart';

class MapSample extends StatefulWidget {
  const MapSample({required this.hasAppBar, super.key});
  final bool hasAppBar;
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
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
        const Marker(
          markerId: MarkerId('Charleston'),
          position: LatLng(
              37.42796133580664, -122.085749655962), // Example coordinates
          infoWindow: InfoWindow(title: 'Charleston'),
        ),
      );
      _markers.add(
        const Marker(
          markerId: MarkerId('Shoreline Parks'),
          position: LatLng(37.43296265331129, -122.08832357078792),
          infoWindow: InfoWindow(title: 'Shoreline Parks'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.hasAppBar == true
          ? const MainAppBar(
              hasLocationBar: false,
            )
          : null,
      extendBodyBehindAppBar: true,
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {},
        markers: _markers,
      ),
    );
  }
}
