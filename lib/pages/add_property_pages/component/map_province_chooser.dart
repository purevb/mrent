import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProvinceChooser extends StatefulWidget {
  final String? provinceName;
  final Function(LatLng, String)? onLocationSelected;

  const MapProvinceChooser({
    this.onLocationSelected,
    this.provinceName,
    super.key,
  });

  @override
  State<MapProvinceChooser> createState() => MapSampleState();
}

class MapSampleState extends State<MapProvinceChooser> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LatLng _selectedLocation = const LatLng(47.921230, 106.918556);
  String _selectedAddress = "";
  int currentIndex = 0;
  bool _isLoading = false;

  String searchText = "";

  late CameraPosition _initialCameraPosition;
  String? _currentProvinceName;

  @override
  void initState() {
    super.initState();
    _currentProvinceName = widget.provinceName;
    final defaultLatLng = getProvinceLatLng(widget.provinceName ?? '');
    _initialCameraPosition = CameraPosition(
      target: defaultLatLng,
      zoom: 12.4746,
    );
  }

  Future<void> _goToMyLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location permission permanently denied.')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newLatLngZoom(
      LatLng(position.latitude, position.longitude),
      14.0,
    ));
  }

  @override
  void didUpdateWidget(MapProvinceChooser oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.provinceName != _currentProvinceName) {
      _currentProvinceName = widget.provinceName;
      _goToProvince();
    }
  }

  LatLng getProvinceLatLng(String provinceName) {
    switch (provinceName) {
      case 'Архангай':
        return const LatLng(47.4769, 101.4540);
      case 'Баян-Өлгий':
        return const LatLng(48.9683, 89.9625);
      case 'Баянхонгор':
        return const LatLng(46.1956, 100.7189);
      case 'Булган':
        return const LatLng(48.8125, 103.5347);
      case 'Говь-Алтай':
        return const LatLng(46.3764, 96.2314);
      case 'Говьсүмбэр':
        return const LatLng(46.3611, 108.3611);
      case 'Дархан-Уул':
        return const LatLng(49.4867, 105.9228);
      case 'Дорноговь':
        return const LatLng(44.9031, 110.1167);
      case 'Дорнод':
        return const LatLng(48.0769, 114.5350);
      case 'Дундговь':
        return const LatLng(45.7625, 106.2708);
      case 'Завхан':
        return const LatLng(47.7486, 96.8442);
      case 'Орхон':
        return const LatLng(49.0275, 104.0444);
      case 'Өвөрхангай':
        return const LatLng(46.2729, 102.7790);
      case 'Өмнөговь':
        return const LatLng(43.5708, 104.4250);
      case 'Сүхбаатар':
        return const LatLng(46.6800, 113.2792);
      case 'Сэлэнгэ':
        return const LatLng(50.2314, 106.2075);
      case 'Төв':
        return const LatLng(47.7069, 106.9522);
      case 'Увс':
        return const LatLng(49.9933, 92.0667);
      case 'Ховд':
        return const LatLng(47.9806, 91.6347);
      case 'Хэнтий':
        return const LatLng(47.3167, 110.6500);
      case 'Хөвсгөл':
        return const LatLng(49.6347, 100.1575);
      default:
        return const LatLng(47.9184, 106.9177);
    }
  }

  void _updateSelectedLocation(LatLng location) async {
    if (!mounted) return;

    setState(() => _isLoading = true);
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(location.latitude, location.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _selectedAddress =
            "${place.street}, ${place.locality}, ${place.country}";
      }

      if (mounted) {
        setState(() {
          _selectedLocation = location;
          _isLoading = false;
        });
      }

      widget.onLocationSelected?.call(_selectedLocation, _selectedAddress);
    } catch (e) {
      debugPrint("Error updating location: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        onTap: (position) {
          _updateSelectedLocation(position);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToMyLocation,
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Future<void> _goToProvince() async {
    final GoogleMapController controller = await _controller.future;
    final targetLatLng = getProvinceLatLng(widget.provinceName ?? '');

    CameraPosition choosenProvince = CameraPosition(
      bearing: 192.8334901395799,
      target: targetLatLng,
      tilt: 59.440717697143555,
      zoom: 10.4746,
    );

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(choosenProvince),
    );
  }
}
