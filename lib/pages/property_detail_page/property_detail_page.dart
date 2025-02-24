import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/property_detail_page/components/bottom_booking_bar.dart';
import 'package:mrent/pages/property_detail_page/components/google_maps.dart';
import 'package:mrent/pages/property_detail_page/components/image_swiper.dart';
import 'package:mrent/pages/property_detail_page/components/listing_agent.dart';
import 'package:mrent/pages/property_detail_page/components/tabbar_description.dart';
import 'package:mrent/utils/constants.dart';

class PropertyDetailPage extends StatefulWidget {
  const PropertyDetailPage({required this.propertyData, super.key});
  final PropertyModel propertyData;

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final Map<int, Map<String, dynamic>> advantages = {
    0: {
      "value": "1,225",
      "label": "sqft",
      "icon": Icons.square_foot,
    },
    1: {
      "value": "3",
      "label": "Bedrooms",
      "icon": Icons.bed,
    },
    2: {
      "value": "2",
      "label": "Bathrooms",
      "icon": Icons.bathtub,
    },
    3: {
      "value": "1",
      "label": "Parking",
      "icon": Icons.local_parking,
    }
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                CupertinoIcons.back,
                color: Colors.black,
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 40,
              width: 40,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: SvgPicture.asset("assets/property_detail/Vector.svg"),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.ellipsis_vertical,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                ImageSwiper(
                    height: height, images: widget.propertyData.images!),
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.star_fill,
                            color: Color(0xffEEA651),
                            size: 22,
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            "4.9(6.8K review)",
                            style: TextStyle(
                              color: Color(0xff8997A9),
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xffF4F6F9),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: const Text("Apartment"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Woodland Apartment",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "1012 Ocean Avenue, New York, USA",
                        style: TextStyle(
                          color: Color(0xff8C8C8C),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      tabBar(height, width),
                    ],
                  ),
                ),
              ],
            ),
          ),
          BottomBookingBar(width: width, propertyData: widget.propertyData),
        ],
      ),
    );
  }

  Widget tabBar(double height, double width) {
    return Column(
      children: [
        TabBar(
          dividerColor: Colors.transparent,
          controller: _tabController,
          labelColor: textDefaultColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: textDefaultColor,
          indicatorWeight: 2,
          tabs: const [
            Tab(text: 'Description'),
            Tab(text: 'Review'),
          ],
        ),
        SizedBox(
          height: height,
          child: TabBarView(
            controller: _tabController,
            children: [
              DescriptionTab(advantages: advantages),
              ReviewTab(),
            ],
          ),
        ),
      ],
    );
  }
}

class ReviewTab extends StatelessWidget {
  const ReviewTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reviews',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          ListView.builder(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) {
              return const ReviewComponent();
            },
          ),
        ],
      ),
    );
  }
}

class ReviewComponent extends StatelessWidget {
  const ReviewComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          Row(
            spacing: 10,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                // child: CachedNetworkImage(
                //   imageUrl: "imageUrl",
                //   errorWidget: (context, url, error) {
                //     return const SizedBox();
                //   },
                // ),
              ),
              const Text(
                "Sandeep S.",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Text(
                "2 months ago",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black.withOpacity(
                    0.6,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0, top: 10),
            child: Text(
              "Lorem Ipsum is simply dummy text of the printing.Lorem Ipsum is simply dummy text of the printing.",
              style:
                  TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}

class DescriptionTab extends StatelessWidget {
  const DescriptionTab({
    super.key,
    required this.advantages,
  });

  final Map<int, Map<String, dynamic>> advantages;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        SizedBox(
          height: width * 0.28,
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 20, left: 0),
            scrollDirection: Axis.horizontal,
            itemCount: advantages.length,
            itemBuilder: (BuildContext context, int index) {
              var advantage = advantages[index];
              return TabbarDescription(
                label: advantage!["label"] ?? "",
                value: advantage["value"] ?? "",
                icon: advantage["icon"] as IconData? ?? Icons.error,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                width: 12,
              );
            },
          ),
        ),
        const ListingAgent(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Address",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Text(
                "View on Map",
                style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
        const Divider(),
        const Row(
          spacing: 5,
          children: [
            Icon(
              CupertinoIcons.placemark,
              size: 25,
            ),
            Text("Gazarzuin bairshil")
          ],
        ),
        SizedBox(
          height: height * 0.3,
          width: width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: const MapSample(),
          ),
        ),
        const Text(
          "Additional things",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const Text(
            "Additional thingsAdditional thingsAdditional thingsAdditional thingsAdditional thingsAdditional thingsAdditional thingsAdditional thingsAdditional thingsAdditional things"),
      ],
    );
  }
}
