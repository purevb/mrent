import 'dart:developer';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mrent/components/carousel_slider.dart';
import 'package:mrent/components/main_appbar.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/property_detail_page/property_detail_page.dart';

class MapSample extends StatefulWidget {
  const MapSample({
    required this.hasAppBar,
    this.onLocationSelected,
    required this.hasFloatButton,
    this.propertyData,
    super.key,
  });
  final List<PropertyModel>? propertyData;
  final bool hasAppBar;
  final bool hasFloatButton;
  final Function(LatLng, String)? onLocationSelected;

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng _selectedLocation = const LatLng(47.921230, 106.918556);
  String _selectedAddress = "";
  bool _isLoading = false;
  PropertyModel? _selectedProperty;

  static const CameraPosition _kUlaanbaatar = CameraPosition(
    target: LatLng(47.921230, 106.918556),
    zoom: 12.0,
  );

  @override
  void initState() {
    super.initState();
    if (widget.propertyData != null && widget.propertyData!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _addPropertyMarkers();
      });
    }
  }

  void _updateSelectedLocation(LatLng location) async {
    setState(() => _isLoading = true);
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
        _isLoading = false;
      });

      widget.onLocationSelected?.call(_selectedLocation, _selectedAddress);
    } catch (e) {
      debugPrint("Error updating location: $e");
      setState(() => _isLoading = false);
    }
  }

  void _addPropertyMarkers() {
    if (!mounted) return;

    _markers = {};
    for (var property in widget.propertyData ?? []) {
      // debugPrint('Adding marker for property: ${property.propertyName}');
      // debugPrint('Coordinates: ${property.latitude}, ${property.longitude}');

      if (property.latitude != null && property.longitude != null) {
        if (property.latitude! >= -90 &&
            property.latitude! <= 90 &&
            property.longitude! >= -180 &&
            property.longitude! <= 180) {
          _markers.add(
            Marker(
              markerId: MarkerId(property.id ?? UniqueKey().toString()),
              position: LatLng(property.latitude!, property.longitude!),
              onTap: () => _handleMarkerTap(property),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              infoWindow: InfoWindow(
                title: property.propertyName,
                snippet: '${property.nightlyPrice} MNT/night',
              ),
            ),
          );
        } else {
          debugPrint('Invalid coordinates for property ${property.id}');
        }
      }
    }
    setState(() {});
  }

  void _handleMarkerTap(PropertyModel property) {
    if (!mounted) return;

    setState(() {
      _selectedProperty = property;
    });

    customInfoWindowController.addInfoWindow!(
      _buildInfoWindowContent(property),
      LatLng(property.latitude!, property.longitude!),
    );

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(property.latitude!, property.longitude!),
        14.0,
      ),
    );
  }

  Widget _buildInfoWindowContent(PropertyModel property) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PropertyDetailPage(propertyData: property),
        ),
      ),
      child: Container(
        width: 230,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (property.images != null && property.images!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CarouselSlider(
                  images: property.images!,
                  height: 120,
                  width: 200,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              property.propertyName ?? 'No Name',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              property.description ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                const Text('5'),
                const Spacer(),
                Text(
                  '${property.nightlyPrice} MNT / night',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
            mapType: MapType.normal,
            initialCameraPosition: _kUlaanbaatar,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              customInfoWindowController.googleMapController = controller;
              _addPropertyMarkers();
            },
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onTap: (position) {
              customInfoWindowController.hideInfoWindow!();
              _updateSelectedLocation(position);
            },
            onCameraMove: (position) {
              customInfoWindowController.onCameraMove!();
            },
            padding: EdgeInsets.only(
              top: widget.hasAppBar ? 100 : 0,
              bottom: widget.hasFloatButton ? 100 : 0,
            ),
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (widget.hasFloatButton == true) ...[
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton.extended(
                heroTag: "confirm_location",
                onPressed: () {
                  debugPrint("Selected Location: $_selectedLocation");
                  debugPrint(
                      "Selected Property: ${_selectedProperty?.propertyName}");
                },
                label: const Text('Confirm'),
                icon: const Icon(Icons.check),
              ),
            ),
          ],
          CustomInfoWindow(
            controller: customInfoWindowController,
            height: 220,
            width: 225,
            offset: 50,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    customInfoWindowController.dispose();
    _mapController?.dispose();
    super.dispose();
  }
}
