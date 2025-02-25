// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mrent/components/main_appbar.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/model/user_model.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const MainAppBar(
        hasLocationBar: true,
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
