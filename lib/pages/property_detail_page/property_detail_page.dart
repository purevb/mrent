import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/login_dropback/login.dart';
import 'package:mrent/pages/property_detail_page/components/bottom_booking_bar.dart';
import 'package:mrent/pages/property_detail_page/components/descripiont_tab_component.dart';
import 'package:mrent/pages/property_detail_page/components/image_swiper.dart';
import 'package:mrent/pages/property_detail_page/components/review_tab_component.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
  DataController dataController = DataController();
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
    dataController.getRatingData(widget.propertyData.id ?? "");
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
                  height: height,
                  images: widget.propertyData.images!,
                ),
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
                          ValueListenableBuilder(
                              valueListenable:
                                  dataController.propertyRatingNotifier,
                              builder: (context, ratingData, child) {
                                if (ratingData == null) {
                                  return Shimmer.fromColors(
                                    // ignore: deprecated_member_use
                                    baseColor: Colors.grey.withOpacity(0.2),
                                    highlightColor: Colors.white,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 2),
                                      height: 20,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: Colors.amber,
                                      ),
                                    ),
                                  );
                                }
                                return Text(
                                  ratingData.averageRating.toString(),
                                  style: GoogleFonts.inter(
                                    color: const Color(0xff8997A9),
                                    fontSize: 16,
                                  ),
                                );
                              }),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xffF4F6F9),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              widget.propertyData.propertyTypeId!.typeName
                                  .toString(),
                            ),
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
                                    : "assets/object/Vector.svg",
                              ),
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
                      Text(widget.propertyData.description ?? ""),
                      const SizedBox(height: 16),
                      tabBar(height),
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

  Widget tabBar(double height) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
          height: height * 1.1,
          child: TabBarView(
            controller: _tabController,
            children: [
              DescriptionTab(
                propertyData: widget.propertyData,
                advantages: advantages,
              ),
              ReviewTab(
                propertyId: widget.propertyData.id ?? "",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
