import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mrent/components/button.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/property_detail_page/components/tabbar_description.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/utils/constants.dart';
import 'package:provider/provider.dart';

class BookingPropertyComponent extends StatefulWidget {
  const BookingPropertyComponent({
    required this.propertyData,
    super.key,
  });
  final PropertyModel propertyData;

  @override
  State<BookingPropertyComponent> createState() =>
      _BookingPropertyComponentState();
}

class _BookingPropertyComponentState extends State<BookingPropertyComponent> {
  bool favorite = false;

  @override
  Widget build(BuildContext context) {
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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final provider = Provider.of<PropertyProvider>(context);

    return Container(
      padding: const EdgeInsets.all(9),
      height: height * 0.4,
      decoration: BoxDecoration(
        color: bookingColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          SizedBox(
            height: height * 0.2,
            width: width,
            child: carouselImages(
              width,
              widget.propertyData.images,
              provider,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                top: 5,
                bottom: 5,
                right: 5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.propertyData.placeName ?? "",
                    style: TextStyle(
                      color: textDefaultColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    maxLines: 3,
                    widget.propertyData.description ?? "",
                    style: TextStyle(
                      // ignore: deprecated_member_use
                      color: textDefaultColor.withOpacity(0.6),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: height * 0.1,
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 0, left: 5),
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
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  SizedBox carouselImages(
      double width, List<String>? images, PropertyProvider provider) {
    return SizedBox(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Swiper(
                pagination: SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                    activeSize: 5,
                    size: 5,
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.5),
                    activeColor: Colors.white,
                  ),
                ),
                itemCount: images?.length ?? 0,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: images?[index] ?? "",
                    errorWidget: (context, url, err) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: mRed,
                        ),
                      );
                    },
                  );
                },
              ),
              Positioned(
                top: 16,
                left: 16,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      favorite = !favorite;
                    });
                    provider.toggleFavorite(widget.propertyData);
                  },
                  child: SvgPicture.asset(
                    fit: BoxFit.fitHeight,
                    provider.isExist(widget.propertyData) == true
                        ? "assets/object/pressedlike.svg"
                        : "assets/object/Vector.svg",
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
