import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mrent/components/horizontal_property.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/profile_page/pages/pages/order_page/order_detail_page.dart';
import 'package:mrent/utils/constants.dart';

@RoutePage()
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<PropertyModel> propertyData = [
    PropertyModel(
      id: "prop_001",
      // propertyTypeId: "prop_type_modern",
      nightlyPrice: 120,
      propertyName: "Modern City Apartment",
      numGuests: 4,
      numBeds: 2,
      numBedrooms: 1,
      numBathrooms: 1,
      isGuestFavourite: 1,
      description:
          "A stylish and modern apartment in the heart of the city with stunning skyline views.",
      longitude: 123,
      latitude: 456,
      images: [
        "https://images.pexels.com/photos/34950/pexels-photo.jpg",
        "https://images.pexels.com/photos/1643383/pexels-photo-1643383.jpeg",
        "https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg"
      ],
    ),
    PropertyModel(
      id: "prop_002",
      // propertyTypeId: "prop_type_luxury",
      nightlyPrice: 250,
      propertyName: "Luxury Beachfront Villa",
      numGuests: 6,
      numBeds: 3,
      numBedrooms: 2,
      numBathrooms: 2,
      isGuestFavourite: 1,
      description:
          "A stunning beachfront villa with private pool and breathtaking ocean views.",
      longitude: 789,
      latitude: 101,
      images: [
        "https://images.pexels.com/photos/2581922/pexels-photo-2581922.jpeg",
        "https://images.pexels.com/photos/206172/pexels-photo-206172.jpeg",
        "https://images.pexels.com/photos/259588/pexels-photo-259588.jpeg"
      ],
    ),
    PropertyModel(
      id: "prop_003",
      // propertyTypeId: "prop_type_rustic",
      nightlyPrice: 90,
      propertyName: "Cozy Mountain Cabin",
      numGuests: 2,
      numBeds: 1,
      numBedrooms: 1,
      numBathrooms: 1,
      isGuestFavourite: 0,
      description:
          "A peaceful cabin surrounded by nature, perfect for a relaxing getaway.",
      longitude: 234,
      latitude: 567,
      images: [
        "https://images.pexels.com/photos/1090638/pexels-photo-1090638.jpeg",
        "https://images.pexels.com/photos/206673/pexels-photo-206673.jpeg",
        "https://images.pexels.com/photos/276671/pexels-photo-276671.jpeg"
      ],
    ),
    PropertyModel(
      id: "prop_002",
      // propertyTypeId: "prop_type_villa",
      nightlyPrice: 250,
      propertyName: "Luxury Beachfront Villa",
      numGuests: 6,
      numBeds: 3,
      numBedrooms: 2,
      numBathrooms: 2,
      isGuestFavourite: 1,
      description:
          "A stunning villa with a private beach and breathtaking ocean views.",
      longitude: 789,
      latitude: 101,
      images: [
        "https://images.pexels.com/photos/210603/pexels-photo-210603.jpeg",
        "https://images.pexels.com/photos/1643383/pexels-photo-1643383.jpeg",
        "https://images.pexels.com/photos/34950/pexels-photo.jpg"
      ],
    ),
    PropertyModel(
      id: "prop_003",
      // propertyTypeId: "prop_type_rustic",
      nightlyPrice: 90,
      propertyName: "Cozy Mountain Cabin",
      numGuests: 3,
      numBeds: 2,
      numBedrooms: 1,
      numBathrooms: 1,
      isGuestFavourite: 0,
      description:
          "A peaceful retreat in the mountains, perfect for nature lovers.",
      longitude: 567,
      latitude: 890,
      images: [
        "https://images.pexels.com/photos/259588/pexels-photo-259588.jpeg",
        "https://images.pexels.com/photos/106399/pexels-photo-106399.jpeg",
        "https://images.pexels.com/photos/356809/pexels-photo-356809.jpeg"
      ],
    ),
    PropertyModel(
      id: "prop_004",
      // propertyTypeId: "prop_type_luxury",
      nightlyPrice: 180,
      propertyName: "Skyline Penthouse",
      numGuests: 5,
      numBeds: 3,
      numBedrooms: 2,
      numBathrooms: 2,
      isGuestFavourite: 1,
      description: "A high-end penthouse with a panoramic city skyline view.",
      longitude: 222,
      latitude: 333,
      images: [
        "https://images.pexels.com/photos/276724/pexels-photo-276724.jpeg",
        "https://images.pexels.com/photos/1402407/pexels-photo-1402407.jpeg",
        "https://images.pexels.com/photos/259962/pexels-photo-259962.jpeg"
      ],
    ),
    PropertyModel(
      id: "prop_005",
      // propertyTypeId: "prop_type_vintage",
      nightlyPrice: 110,
      propertyName: "Charming Lakeside Cottage",
      numGuests: 4,
      numBeds: 2,
      numBedrooms: 1,
      numBathrooms: 1,
      isGuestFavourite: 1,
      description:
          "A quaint and cozy lakeside cottage, ideal for a romantic getaway.",
      longitude: 777,
      latitude: 888,
      images: [
        "https://images.pexels.com/photos/1643383/pexels-photo-1643383.jpeg",
        "https://images.pexels.com/photos/1457842/pexels-photo-1457842.jpeg",
        "https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg"
      ],
    ),
    PropertyModel(
      id: "prop_006",
      // placeType: "loc_106",
      // propertyTypeId: "prop_type_modern",
      nightlyPrice: 75,
      propertyName: "Minimalist Tiny Home",
      numGuests: 2,
      numBeds: 1,
      numBedrooms: 1,
      numBathrooms: 1,
      isGuestFavourite: 0,
      description:
          "A modern and compact tiny home, perfect for solo travelers or couples.",
      longitude: 444,
      latitude: 555,
      images: [
        "https://images.pexels.com/photos/2102587/pexels-photo-2102587.jpeg",
        "https://images.pexels.com/photos/1123996/pexels-photo-1123996.jpeg",
        "https://images.pexels.com/photos/2409030/pexels-photo-2409030.jpeg"
      ],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text(
          "Захиалгууд",
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        width: width,
        height: height,
        child: ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: propertyData.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("2025.07.09"),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return OrderDetailPage(
                            propertyData: propertyData[index],
                          );
                        },
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      HorizontalProperty(
                        propertyData: propertyData[index],
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                              color: mRed,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Text("5"),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 20,
            );
          },
        ),
      ),
    );
  }
}
