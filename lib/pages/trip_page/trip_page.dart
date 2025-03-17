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
      placeName: "Any ",
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
    ),
    PropertyModel(
      id: "prop_002",
      locationId: "loc_102",
      placeTypeId: "place_house",
      placeType: "Yurts",
      propertyTypeId: "prop_type_villa",
      hostId: "host_xyz789",
      nightlyPrice: 250,
      propertyName: "Luxury Beachfront Villa",
      numGuests: 6,
      numBeds: 3,
      numBedrooms: 2,
      numBathrooms: 2,
      isGuestFavourite: 1,
      description:
          "A stunning villa with a private beach and breathtaking ocean views.",
      addressLine1: 789,
      addressLine2: 101,
      images: [
        "https://images.pexels.com/photos/210603/pexels-photo-210603.jpeg",
        "https://images.pexels.com/photos/1643383/pexels-photo-1643383.jpeg",
        "https://images.pexels.com/photos/34950/pexels-photo.jpg"
      ],
      rating: 4.8,
      placeName: "Maldive Shores",
    ),
    PropertyModel(
      id: "prop_003",
      locationId: "loc_103",
      placeTypeId: "place_cabin",
      placeType: "House",
      propertyTypeId: "prop_type_rustic",
      hostId: "host_pqr456",
      nightlyPrice: 90,
      propertyName: "Cozy Mountain Cabin",
      numGuests: 3,
      numBeds: 2,
      numBedrooms: 1,
      numBathrooms: 1,
      isGuestFavourite: 0,
      description:
          "A peaceful retreat in the mountains, perfect for nature lovers.",
      addressLine1: 567,
      addressLine2: 890,
      images: [
        "https://images.pexels.com/photos/259588/pexels-photo-259588.jpeg",
        "https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg",
        "https://images.pexels.com/photos/356809/pexels-photo-356809.jpeg"
      ],
      rating: 4.6,
      placeName: "Aspen Retreat",
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
      placeName: "Skyview Tower",
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
      placeName: "Lake Serenity",
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
      placeName: "Eco Tiny Haven",
    ),
  ];
  List<PropertyModel> filteredPropertyData = [];
  String selectedCategory = "All";
  void filterTypes(String categoryType) {
    setState(() {
      selectedCategory = categoryType;
      if (categoryType == "All") {
        filteredPropertyData = List.from(propertyData);
      } else {
        filteredPropertyData = propertyData
            .where((property) => property.placeType == categoryType)
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    filteredPropertyData = List.from(propertyData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: MainAppBar(
        properties: propertyData,
        hasLocationBar: true,
        chooseType: filterTypes,
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
                      propertyData: filteredPropertyData[index],
                    ),
                  ),
                );
              },
              child: TheObject(
                propertyData: filteredPropertyData[index],
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 20);
          },
          itemCount: filteredPropertyData.length,
        ),
      ),
    );
  }
}
