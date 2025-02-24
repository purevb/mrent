// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/model/user_model.dart';
import 'package:mrent/pages/property_detail_page/components/google_maps.dart';
import 'package:mrent/pages/property_detail_page/property_detail_page.dart';
import 'package:mrent/pages/trip_page/component/object.dart';
import 'package:mrent/utils/constants.dart';

class TripPage extends StatefulWidget {
  const TripPage({this.user, super.key});
  final User? user;

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  int currentIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToIndex(int index) {
    const itemWidth = 85.0;
    final screenWidth = MediaQuery.of(context).size.width;
    const padding = 10.0;
    double targetOffset =
        (itemWidth * index) - (screenWidth / 2) + (itemWidth / 2) + padding;
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

  List<PropertyModel> propertyData = [
    PropertyModel(
      id: "prop_001",
      locationId: "loc_101",
      placeTypeId: "place_apt",
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
      placeName: "Any where",
    ),
    PropertyModel(
      id: "prop_002",
      locationId: "loc_102",
      placeTypeId: "place_villa",
      propertyTypeId: "prop_type_luxury",
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
      placeName: "Any where",
    ),
    PropertyModel(
      id: "prop_003",
      locationId: "loc_103",
      placeTypeId: "place_cabin",
      propertyTypeId: "prop_type_rustic",
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
      placeName: "Any where",
    ),
  ];

  Map<int, Map<String, dynamic>> appbarCategoryIcons = {
    0: {
      "icon": "assets/search/amazing_views.png",
      "iconName": "Amazing views",
    },
    1: {
      "icon": "assets/search/house.png",
      "iconName": "House",
    },
    2: {
      "icon": "assets/search/near_river.png",
      "iconName": "Near the river",
    },
    3: {
      "icon": "assets/search/tent.png",
      "iconName": "Tent",
    },
    4: {
      "icon": "assets/search/yurt.png",
      "iconName": "Yurts",
    },
  };

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        toolbarHeight: height * (0.11),
        shadowColor: Colors.black,
        backgroundColor: backgroundColor,
        elevation: 0.8,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 30, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1000),
                        color: backgroundColor,
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: textDefaultColor.withOpacity(0.4),
                            blurRadius: 2,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      height: height * 0.07,
                      child: Row(
                        spacing: 5,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: SvgPicture.asset(
                              fit: BoxFit.fitHeight,
                              "assets/search/searchbutton.svg",
                            ),
                          ),
                          Text(
                            "Search",
                            style: TextStyle(
                              fontSize: 18,
                              color: textDefaultColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const MapSample();
                      }));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      height: height * 0.05,
                      width: height * 0.05,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: textDefaultColor.withOpacity(0.4),
                            blurRadius: 2,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        shape: BoxShape.circle,
                        color: backgroundColor,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        CupertinoIcons.location,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                height: 85,
                child: ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          currentIndex = index;
                        });
                        _scrollToIndex(index);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 55,
                              alignment: Alignment.bottomCenter,
                              child: Image.asset(
                                height: 25,
                                fit: BoxFit.contain,
                                color: textDefaultColor,
                                appbarCategoryIcons[index]!['icon'],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                              child: Text(
                                appbarCategoryIcons[index]!['iconName'],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
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
                  itemCount: appbarCategoryIcons.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 5,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: backgroundColor,
        // padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PropertyDetailPage(
                      propertyData: propertyData[index],
                    ),
                  ),
                );
              },
              child: TheObject(
                propertyData: propertyData[index],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 20);
          },
          itemCount: propertyData.length,
        ),
      ),
    );
  }
}
