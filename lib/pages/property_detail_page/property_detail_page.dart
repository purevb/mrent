import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mrent/pages/property_detail_page/components/image_swiper.dart';
import 'package:mrent/utils/constants.dart';

class PropertyDetailPage extends StatefulWidget {
  const PropertyDetailPage({super.key});

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> images = [
    "https://images.pexels.com/photos/34950/pexels-photo.jpg",
    "https://images.unsplash.com/photo-1441974231531-c6227db76b6e",
    "https://images.pexels.com/photos/355465/pexels-photo-355465.jpeg",
    "https://images.unsplash.com/photo-1505144808419-1957a94ca61e",
    "https://images.unsplash.com/photo-1484589065579-248aad0d8b13",
    "https://images.pexels.com/photos/325185/pexels-photo-325185.jpeg",
    "https://images.unsplash.com/photo-1518689000812-44e345196396",
  ];

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageSwiper(height: height, images: images),
            Padding(
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
                  tabBar(height),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tabBar(double height) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: mRed,
          unselectedLabelColor: Colors.grey,
          indicatorColor: mRed,
          indicatorWeight: 2,
          tabs: const [
            Tab(text: 'Description'),
            Tab(text: 'Review'),
          ],
        ),
        Container(
          height: height,
          child: TabBarView(
            controller: _tabController,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: advantages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final advantage = advantages[index];
                    if (advantage == null) return const SizedBox.shrink();

                    return _buildInfoCard(
                      value: advantage["value"] ?? "",
                      label: advantage["label"] ?? "",
                      icon: advantage["icon"] as IconData? ?? Icons.error,
                    );
                  },
                ),
              ),
              const Center(child: Text('Review Content')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: mRed, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: mRed,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
