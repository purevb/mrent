import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mrent/components/carousel_slider.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/utils/constants.dart';
import 'package:provider/provider.dart';

class FavoriteProperty extends StatefulWidget {
  const FavoriteProperty({
    required this.propertyData,
    super.key,
  });
  final PropertyModel propertyData;

  @override
  State<FavoriteProperty> createState() => _FavoritePropertyState();
}

class _FavoritePropertyState extends State<FavoriteProperty> {
  bool favorite = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final provider = Provider.of<PropertyProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: height * 0.4,
      width: width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 1,
            spreadRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: CarouselSlider(
              height: height,
              width: width,
              images: widget.propertyData.images,
              provider: provider,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 5, right: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.propertyData.placeName ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            favorite = !favorite;
                          });
                          provider.toggleFavorite(widget.propertyData);
                        },
                        child: SizedBox(
                          height: 20,
                          width: 25,
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
                  Text(
                    widget.propertyData.description ?? "",
                    maxLines: 3,
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      const Icon(
                        CupertinoIcons.bed_double,
                        size: 15,
                      ),
                      Text(
                        "${widget.propertyData.numBeds.toString()}.0",
                      ),
                      const Icon(
                        CupertinoIcons.person_2,
                        size: 15,
                      ),
                      Text(
                        "${widget.propertyData.numGuests.toString()}.0",
                      ),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: RichText(
                      text: TextSpan(
                        style:
                            const TextStyle(fontSize: 10, color: Colors.black),
                        children: [
                          const TextSpan(
                            text: '\$',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          TextSpan(
                            text: widget.propertyData.nightlyPrice.toString(),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          const TextSpan(
                            text: '/',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          const TextSpan(
                            text: 'month',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
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
}
