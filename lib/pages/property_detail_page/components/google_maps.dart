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
    super.key,
  });
  final bool hasAppBar;
  final bool hasFloatButton;
  final Function(LatLng, String)? onLocationSelected;

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();
  List<PropertyModel> propertyData = [
    PropertyModel(
      id: "prop_001",
      locationId: "loc_101",
      placeTypeId: "place_apt",
      placeType: "Tent",
      propertyTypeId: "prop_type_modern",
      hostId: "host_abc123",
      nightlyPrice: 120,
      propertyName: "Modern City Apartment",
      numGuests: 4,
      numBeds: 2,
      numBedrooms: 1,
      numBathrooms: 1,
      isGuestFavourite: 1,
      description:
          "A stylish and modern apartment in the heart of the city with stunning skyline views.",
      addressLine1: 123,
      addressLine2: 456,
      images: [
        "https://images.pexels.com/photos/34950/pexels-photo.jpg",
        "https://images.pexels.com/photos/1643383/pexels-photo-1643383.jpeg",
        "https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg"
      ],
      rating: 5,
      placeName: "Zavhan",
      latitude: 48.0282,
      longitude: 96.2461,
    ),
    PropertyModel(
      id: "prop_002",
      locationId: "loc_102",
      placeTypeId: "place_villa",
      propertyTypeId: "prop_type_luxury",
      placeType: "Nature",
      hostId: "host_xyz789",
      nightlyPrice: 250,
      propertyName: "Luxury Beachfront Villa",
      numGuests: 6,
      numBeds: 3,
      numBedrooms: 2,
      numBathrooms: 2,
      isGuestFavourite: 1,
      description:
          "A stunning beachfront villa with private pool and breathtaking ocean views.",
      addressLine1: 789,
      addressLine2: 101,
      images: [
        "https://images.pexels.com/photos/2581922/pexels-photo-2581922.jpeg",
        "https://images.pexels.com/photos/206172/pexels-photo-206172.jpeg",
        "https://images.pexels.com/photos/259588/pexels-photo-259588.jpeg"
      ],
      rating: 5,
      placeName: "Darkhan",
      latitude: 49.4833,
      longitude: 105.9167,
    ),
    PropertyModel(
      id: "prop_003",
      locationId: "loc_103",
      placeTypeId: "place_cabin",
      propertyTypeId: "prop_type_rustic",
      placeType: "River",
      hostId: "host_lmn456",
      nightlyPrice: 90,
      propertyName: "Cozy Mountain Cabin",
      numGuests: 2,
      numBeds: 1,
      numBedrooms: 1,
      numBathrooms: 1,
      isGuestFavourite: 0,
      description:
          "A peaceful cabin surrounded by nature, perfect for a relaxing getaway.",
      addressLine1: 234,
      addressLine2: 567,
      images: [
        "https://images.pexels.com/photos/1090638/pexels-photo-1090638.jpeg",
        "https://images.pexels.com/photos/206673/pexels-photo-206673.jpeg",
        "https://images.pexels.com/photos/276671/pexels-photo-276671.jpeg"
      ],
      rating: 5,
      placeName: "Erdenet",
      latitude: 49.0333,
      longitude: 104.0500,
    ),
    PropertyModel(
      id: "prop_004",
      locationId: "loc_104",
      placeTypeId: "place_apt",
      placeType: "Tent",
      propertyTypeId: "prop_type_luxury",
      hostId: "host_lmn222",
      nightlyPrice: 180,
      propertyName: "Skyline Penthouse",
      numGuests: 5,
      numBeds: 3,
      numBedrooms: 2,
      numBathrooms: 2,
      isGuestFavourite: 1,
      description: "A high-end penthouse with a panoramic city skyline view.",
      addressLine1: 222,
      addressLine2: 333,
      images: [
        "https://images.pexels.com/photos/276724/pexels-photo-276724.jpeg",
        "https://images.pexels.com/photos/1402407/pexels-photo-1402407.jpeg",
        "https://images.pexels.com/photos/259962/pexels-photo-259962.jpeg"
      ],
      rating: 5,
      placeName: "Orkhon",
      latitude: 47.8864,
      longitude: 106.7794,
    ),
    PropertyModel(
      id: "prop_005",
      locationId: "loc_105",
      placeTypeId: "place_cottage",
      placeType: "River",
      propertyTypeId: "prop_type_vintage",
      hostId: "host_def567",
      nightlyPrice: 110,
      propertyName: "Charming Lakeside Cottage",
      numGuests: 4,
      numBeds: 2,
      numBedrooms: 1,
      numBathrooms: 1,
      isGuestFavourite: 1,
      description:
          "A quaint and cozy lakeside cottage, ideal for a romantic getaway.",
      addressLine1: 777,
      addressLine2: 888,
      images: [
        "https://images.pexels.com/photos/1643383/pexels-photo-1643383.jpeg",
        "https://images.pexels.com/photos/1457842/pexels-photo-1457842.jpeg",
        "https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg"
      ],
      rating: 4,
      placeName: "Khövsgöl",
      latitude: 50.4333,
      longitude: 100.1500,
    ),
    PropertyModel(
      id: "prop_006",
      locationId: "loc_106",
      placeTypeId: "place_tiny_home",
      placeType: "Nature",
      propertyTypeId: "prop_type_modern",
      hostId: "host_ghi345",
      nightlyPrice: 75,
      propertyName: "Minimalist Tiny Home",
      numGuests: 2,
      numBeds: 1,
      numBedrooms: 1,
      numBathrooms: 1,
      isGuestFavourite: 0,
      description:
          "A modern and compact tiny home, perfect for solo travelers or couples.",
      addressLine1: 444,
      addressLine2: 555,
      images: [
        "https://images.pexels.com/photos/2102587/pexels-photo-2102587.jpeg",
        "https://images.pexels.com/photos/1123996/pexels-photo-1123996.jpeg",
        "https://images.pexels.com/photos/2409030/pexels-photo-2409030.jpeg"
      ],
      rating: 4,
      placeName: "Selenge",
      latitude: 50.2500,
      longitude: 106.2167,
    ),
  ];

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng _selectedLocation = const LatLng(47.921230, 106.918556);
  String _selectedAddress = "";
  bool _isLoading = false;
  PropertyModel? _selectedProperty;

  static const CameraPosition _kUlaanbaatar = CameraPosition(
    target: LatLng(47.921230, 106.918556),
    zoom: 6.0,
  );

  @override
  void initState() {
    super.initState();
    _addPropertyMarkers();
  }

  void _addPropertyMarkers() {
    _markers = {};
    for (var property in propertyData) {
      if (property.latitude != null && property.longitude != null) {
        _markers.add(
          Marker(
            markerId: MarkerId(property.id.toString()),
            position: LatLng(property.latitude!, property.longitude!),
            onTap: () {
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
                  10.0,
                ),
              );
            },
            consumeTapEvents: true,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          ),
        );
      }
    }
    setState(() {});
  }

  Widget _buildInfoWindowContent(PropertyModel property) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailPage(
              propertyData: property,
            ),
          ),
        );
      },
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
                  height: 500,
                  width: 270,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              property.propertyName.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              property.placeName.toString(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text('${property.rating}'),
                const Spacer(),
                Text(
                  '\$${property.nightlyPrice} / night',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (widget.hasFloatButton == true) ...[
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton.extended(
                heroTag: "confirm_location",
                onPressed: () {
                  log("Selected Location: $_selectedLocation");
                  log("Selected Property: ${_selectedProperty?.propertyName}");
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
