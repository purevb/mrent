import 'dart:math';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mrent/components/carousel_slider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/property_detail_page/property_detail_page.dart';
import 'package:mrent/utils/constants.dart';
import 'package:shimmer/shimmer.dart';

class CustomizeMap extends StatefulWidget {
  const CustomizeMap({
    required this.hasAppBar,
    this.onLocationSelected,
    required this.hasFloatButton,
    this.propertyData,
    this.refresh,
    super.key,
  });
  final List<PropertyModel>? propertyData;
  final bool hasAppBar;
  final bool hasFloatButton;
  final Function(LatLng, String)? onLocationSelected;
  final RefreshCallback? refresh;

  @override
  State<CustomizeMap> createState() => MapSampleState();
}

class MapSampleState extends State<CustomizeMap>
    with AutomaticKeepAliveClientMixin {
  late final CustomInfoWindowController customInfoWindowController;
  late final TextEditingController searchController;
  late final ScrollController _scrollController;

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng _selectedLocation = const LatLng(47.921230, 106.918556);
  String _selectedAddress = "";
  bool _isLoading = false;
  PropertyModel? _selectedProperty;
  int currentIndex = 0;
  String searchText = "";
  bool _mapCreated = false;

  DataController dataController = DataController();
  static const CameraPosition _kUlaanbaatar = CameraPosition(
    target: LatLng(47.921230, 106.918556),
    zoom: 12.0,
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    customInfoWindowController = CustomInfoWindowController();
    searchController = TextEditingController();
    _scrollController = ScrollController();
    dataController.getProvinceData();
    searchController.addListener(_onSearchChanged);

    if (widget.propertyData != null && widget.propertyData!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _mapController != null) {
          _addPropertyMarkers();
        }
      });
    }
  }

  @override
  void dispose() {
    if (_mapController != null) {
      _mapController!.dispose();
      _mapController = null;
    }
    customInfoWindowController.dispose();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomizeMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.propertyData != oldWidget.propertyData &&
        _mapController != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _addPropertyMarkers();
          if (widget.propertyData != null && widget.propertyData!.isNotEmpty) {
            _fitMarkersInView(widget.propertyData!);
          }
        }
      });
    }
  }

  void _onSearchChanged() {
    if (mounted) {
      setState(() {
        searchText = searchController.text;
      });
    }
    _filterPropertiesBySearch();
  }

  void _filterPropertiesBySearch() {
    if (!mounted || _mapController == null) return;

    if (searchText.isEmpty || widget.propertyData == null) {
      _addPropertyMarkers();
      return;
    }

    final filteredMarkers = <Marker>{};
    final String searchLower = searchText.toLowerCase();

    final filteredProperties = widget.propertyData!.where((property) {
      final propertyName = property.propertyName?.toLowerCase() ?? '';
      final description = property.description?.toLowerCase() ?? '';
      final location = property.placeTypeId?.provinceName?.toLowerCase() ?? '';

      return propertyName.contains(searchLower) ||
          description.contains(searchLower) ||
          location.contains(searchLower);
    }).toList();

    for (var property in filteredProperties) {
      if (property.latitude != null && property.longitude != null) {
        final marker = _createMarkerForProperty(property);
        if (marker != null) {
          filteredMarkers.add(marker);
        }
      }
    }

    if (mounted) {
      setState(() {
        _markers = filteredMarkers;
      });
    }

    if (filteredProperties.isNotEmpty) {
      _fitMarkersInView(filteredProperties);
    }
  }

  Marker? _createMarkerForProperty(PropertyModel property) {
    if (property.latitude == null ||
        property.longitude == null ||
        property.latitude! < -90 ||
        property.latitude! > 90 ||
        property.longitude! < -180 ||
        property.longitude! > 180) {
      return null;
    }

    return Marker(
      markerId: MarkerId(property.id ?? UniqueKey().toString()),
      position: LatLng(property.latitude!, property.longitude!),
      onTap: () => _handleMarkerTap(property),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
  }

  void _addPropertyMarkers() {
    if (!mounted || _mapController == null || widget.propertyData == null) {
      return;
    }

    final newMarkers = <Marker>{};

    for (var property in widget.propertyData!) {
      final marker = _createMarkerForProperty(property);
      if (marker != null) {
        newMarkers.add(marker);
      }
    }

    if (mounted) {
      setState(() {
        _markers = newMarkers;
      });
    }
  }

  void _fitMarkersInView(List<PropertyModel> properties) {
    if (properties.isEmpty || _mapController == null || !mounted) return;

    final validProperties = properties
        .where((prop) =>
            prop.latitude != null &&
            prop.longitude != null &&
            prop.latitude! >= -90 &&
            prop.latitude! <= 90 &&
            prop.longitude! >= -180 &&
            prop.longitude! <= 180)
        .toList();

    if (validProperties.isEmpty) return;

    double minLat = 90.0;
    double maxLat = -90.0;
    double minLng = 180.0;
    double maxLng = -180.0;

    for (var prop in validProperties) {
      minLat = min(minLat, prop.latitude!);
      maxLat = max(maxLat, prop.latitude!);
      minLng = min(minLng, prop.longitude!);
      maxLng = max(maxLng, prop.longitude!);
    }

    const padding = 0.01;
    minLat -= padding;
    maxLat += padding;
    minLng -= padding;
    maxLng += padding;

    if (minLat != maxLat && minLng != maxLng) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          50,
        ),
      );
    } else {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(minLat, minLng),
          14.0,
        ),
      );
    }
  }

  void _scrollToIndex(int index) {
    const itemWidth = 105.0;
    final screenWidth = MediaQuery.of(context).size.width;
    const padding = 10.0;
    double targetOffset =
        (itemWidth * index) - (screenWidth / 2) + (itemWidth / 2) + padding;

    if (_scrollController.hasClients) {
      targetOffset = targetOffset.clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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

  void _handleMarkerTap(PropertyModel property) {
    if (!mounted || _mapController == null) return;

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

  void _filterMarkersByProvince(String provinceName) {
    if (!mounted || widget.propertyData == null || _mapController == null) {
      return;
    }

    final newMarkers = <Marker>{};
    final filteredProperties = provinceName == "Бүгд"
        ? widget.propertyData
        : widget.propertyData!
            .where((property) =>
                property.placeTypeId?.provinceName == provinceName)
            .toList();

    for (var property in filteredProperties!) {
      final marker = _createMarkerForProperty(property);
      if (marker != null) {
        newMarkers.add(marker);
      }
    }

    if (mounted) {
      setState(() {
        _markers = newMarkers;
      });
    }
  }

  Widget _buildInfoWindowContent(PropertyModel property) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PropertyDetailPage(
            propertyData: property,
          ),
        ),
      ),
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
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
            const Spacer(),
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
    super.build(context);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return FocusDetector(
      onFocusGained: () async {
        if (widget.refresh != null) {
          widget.refresh!();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted &&
                _mapController != null &&
                widget.propertyData != null) {
              _addPropertyMarkers();
              _fitMarkersInView(widget.propertyData!);
            }
          });
        }
      },
      child: Scaffold(
        appBar: widget.hasAppBar == true
            ? AppBar(
                shadowColor: Colors.black,
                toolbarHeight: height * (0.1),
                elevation: 1,
                backgroundColor: backgroundColor,
                automaticallyImplyLeading: false,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(55),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 30, right: 30),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: backgroundColor,
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: textDefaultColor.withOpacity(0.15),
                              blurRadius: 2,
                              spreadRadius: 0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        height: height * 0.07,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: width * 0.8 - 60,
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: SvgPicture.asset(
                                      fit: BoxFit.fitHeight,
                                      "assets/search/searchbutton.svg",
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: searchController,
                                      decoration: InputDecoration(
                                        hintText: "Хайлт",
                                        labelStyle: GoogleFonts.inter(
                                          fontSize: 18,
                                          // ignore: deprecated_member_use
                                          color: Colors.black.withOpacity(0.7),
                                        ),
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      onSubmitted: (value) {
                                        _filterPropertiesBySearch();
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: dataController.proviceNotifier,
                        builder: (context, provinceData, child) {
                          if (provinceData == null) {
                            return SizedBox(
                              height: 70.0,
                              child: Shimmer.fromColors(
                                // ignore: deprecated_member_use
                                baseColor: Colors.grey.withOpacity(0.2),
                                highlightColor: Colors.white,
                                child: ListView.separated(
                                  padding: const EdgeInsets.only(
                                    left: 30,
                                  ),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 5,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      height: 30,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(
                                      width: 10,
                                    );
                                  },
                                ),
                              ),
                            );
                          }

                          if (provinceData.isEmpty) {
                            return const SizedBox(height: 70);
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            height: 70,
                            alignment: const Alignment(0, 0),
                            child: ListView.separated(
                              controller: _scrollController,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                final typeName = index == 0
                                    ? "Бүгд"
                                    : provinceData[index - 1].provinceName ??
                                        "";
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      currentIndex = index;
                                    });

                                    _scrollToIndex(index);

                                    if (index == 0) {
                                      _filterMarkersByProvince("Бүгд");
                                    } else if (index > 0 &&
                                        index <= provinceData.length) {
                                      final provinceName =
                                          provinceData[index - 1].provinceName;
                                      if (provinceName != null) {
                                        _filterMarkersByProvince(provinceName);
                                      }
                                    }
                                  },
                                  child: Container(
                                    // ignore: deprecated_member_use
                                    color: backgroundColor.withOpacity(0),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            FractionalTranslation(
                                              translation: index == 0
                                                  ? const Offset(0, -0.028)
                                                  : const Offset(0, 0),
                                            ),
                                            const SizedBox(width: 5),
                                            Container(
                                              alignment: Alignment.bottomCenter,
                                              height: 55,
                                              child: Text(
                                                typeName,
                                                style: GoogleFonts.inter(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          switchInCurve: Easing.legacy,
                                          child: currentIndex == index
                                              ? Container(
                                                  width: 40,
                                                  key: ValueKey<int>(index),
                                                  height: 2,
                                                  decoration: BoxDecoration(
                                                    color: mRed,
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: provinceData.length + 1,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(
                                  width: 5,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            : null,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kUlaanbaatar,
              onMapCreated: (GoogleMapController controller) {
                if (!mounted || _mapCreated) return;
                _mapCreated = true;

                _mapController = controller;
                customInfoWindowController.googleMapController = controller;
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (mounted && _mapController != null) {
                    _addPropertyMarkers();
                  }
                });
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
            CustomInfoWindow(
              controller: customInfoWindowController,
              height: 220,
              width: 225,
              offset: 50,
            ),
          ],
        ),
      ),
    );
  }
}
