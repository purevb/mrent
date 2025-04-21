import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/login_dropback/login.dart';
import 'package:mrent/pages/property_detail_page/components/bottom_booking_bar.dart';
import 'package:mrent/pages/map_pages/google_maps.dart';
import 'package:mrent/pages/property_detail_page/components/image_swiper.dart';
import 'package:mrent/pages/property_detail_page/components/listing_agent.dart';
import 'package:mrent/pages/property_detail_page/components/tabbar_description.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/utils/constants.dart';
import 'package:provider/provider.dart';

class PropertyDetailPage extends StatefulWidget {
  const PropertyDetailPage({
    required this.propertyData,
    super.key,
  });
  final PropertyModel propertyData;
  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Api api = Api();
  bool? favorite;

  final Map<int, Map<String, dynamic>> advantages = {
    0: {
      "label": "Хүн",
      "icon": Icons.people,
    },
    1: {
      "label": "Ор",
      "icon": Icons.bed,
    },
    2: {
      "label": "Угаалгын өрөө",
      "icon": Icons.bathtub,
    },
    3: {
      "label": "Унтлагын өрөө",
      "icon": Icons.meeting_room,
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
    final provider = Provider.of<PropertyProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 0.1,
                  )
                ],
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 0.1,
                  )
                ],
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 0.1,
                )
              ],
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
                          Text(
                            "4.9(6.8K review)",
                            style: GoogleFonts.inter(
                              color: const Color(0xff8997A9),
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
                            child: Text(widget
                                .propertyData.propertyTypeId!.typeName
                                .toString()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Text(
                              "${widget.propertyData.propertyName}",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (provider.getUser != null) {
                                provider.toggleFavorite(
                                  provider.getUser!.id!,
                                  widget.propertyData,
                                );
                              } else {
                                showModalBottomSheet(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const Login();
                                  },
                                );
                              }
                            },
                            child: SizedBox(
                              height: 20,
                              width: 25,
                              child: SvgPicture.asset(
                                  fit: BoxFit.fitHeight,
                                  provider.isPropertyIdFavorite(
                                          widget.propertyData.id!)
                                      ? "assets/object/pressedlike.svg"
                                      : "assets/object/Vector.svg"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.propertyData.placeTypeId?.provinceName
                                .toString() ??
                            "",
                        style: GoogleFonts.inter(
                          color: const Color(0xff8C8C8C),
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
            Tab(text: 'Тайлбар'),
            Tab(text: 'Сэтгэгдэл'),
          ],
        ),
        SizedBox(
          height: height,
          child: TabBarView(
            controller: _tabController,
            children: [
              DescriptionTab(
                propertyData: widget.propertyData,
                advantages: advantages,
              ),
              const ReviewTab(),
            ],
          ),
        ),
      ],
    );
  }
}

class ReviewTab extends StatefulWidget {
  const ReviewTab({
    super.key,
  });

  @override
  State<ReviewTab> createState() => _ReviewTabState();
}

class _ReviewTabState extends State<ReviewTab> {
  List<File> _selectedImages = [];
  final TextEditingController _reviewController = TextEditingController();
  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> pickedFiles = await picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _selectedImages
              .addAll(pickedFiles.map((file) => File(file.path)).toList());
        });
      }
    } catch (e) {
      print("Error picking images from gallery: $e");
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _submitReview() {
    if (_reviewController.text.trim().isNotEmpty) {
      log('Review submitted: ${_reviewController.text}');
      log('Images: ${_selectedImages.length}');
      _selectedImages.clear();
      setState(() {
        _reviewController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a review'),
        backgroundColor: Colors.orange,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reviews',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          AnimatedContainer(
            height: _selectedImages.isEmpty ? height * 0.2 : height * 0.28,
            duration: const Duration(
              milliseconds: 200,
            ),
            curve: Curves.linear,
            child: Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: 40,
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
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextField(
                          controller: _reviewController,
                          decoration: const InputDecoration(
                            hintText: "Санал бодлоо хүваалцаарай :)",
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          maxLines: 2,
                        ),
                        Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        _selectedImages[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: () => _removeImage(index),
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color:
                                                // ignore: deprecated_member_use
                                                Colors.black.withOpacity(0.5),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return const SizedBox(
                                width: 10,
                              );
                            },
                            itemCount: _selectedImages.length,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: _pickImageFromGallery,
                              icon: const Icon(
                                CupertinoIcons.camera,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _submitReview();
                              },
                              icon: Icon(
                                Icons.send,
                                color: mRed,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
              Text(
                "Sandeep S.",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Text(
                "2 months ago",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  // ignore: deprecated_member_use
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
              style: GoogleFonts.inter(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 15),
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
    required this.propertyData,
  });

  final PropertyModel propertyData;
  final Map<int, Map<String, dynamic>> advantages;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final Map<int, Map<String, dynamic>> filledAdvantages = {
      0: {
        "label": advantages[0]!["label"],
        "value": "${propertyData.numGuests}",
        "icon": advantages[0]!["icon"],
      },
      1: {
        "label": advantages[1]!["label"],
        "value": "${propertyData.numBeds}",
        "icon": advantages[1]!["icon"],
      },
      2: {
        "label": advantages[2]!["label"],
        "value": "${propertyData.numBathrooms}",
        "icon": advantages[2]!["icon"],
      },
      3: {
        "label": advantages[3]!["label"],
        "value": "${propertyData.numBedrooms}",
        "icon": advantages[3]!["icon"],
      },
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        SizedBox(
          height: height * 0.128,
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 20, left: 5),
            scrollDirection: Axis.horizontal,
            itemCount: filledAdvantages.length,
            itemBuilder: (BuildContext context, int index) {
              var advantage = filledAdvantages[index];
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
            Text(
              "Байршил",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                "Газрын зураг дээр үзэх",
                style: GoogleFonts.inter(
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
            Text("Газарзүйн байршил")
          ],
        ),
        SizedBox(
          height: height * 0.3,
          width: width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: const MapSample(
              hasFloatButton: true,
              hasAppBar: false,
            ),
          ),
        ),
        Text(
          "Нэмэлт мэдээлэл",
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const Text(
            "Additional thingsAdditional thingsAdditional thingsAdditional thingsAdditional thingsAdditional thingsAdditional thingsAdditional thingsAdditional thingsAdditional things"),
      ],
    );
  }
}
