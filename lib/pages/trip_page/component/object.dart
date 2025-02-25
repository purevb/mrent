import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/utils/constants.dart';
import 'package:provider/provider.dart';

class TheObject extends StatefulWidget {
  const TheObject({
    required this.propertyData,
    super.key,
  });
  final PropertyModel propertyData;

  @override
  State<TheObject> createState() => _TheObjectState();
}

class _TheObjectState extends State<TheObject> {
  bool favorite = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final provider = Provider.of<PropertyProvider>(context);
    // double height = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
      ),
      padding: const EdgeInsets.only(
        bottom: 15,
      ),
      width: width,
      // height: 440,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: textDefaultColor.withOpacity(0.2),
            blurRadius: 3,
            offset: const Offset(
              0,
              0.5,
            ),
          ),
        ],
      ),
      child: Column(
        spacing: 5,
        children: [
          carouselImages(width, widget.propertyData.images, 360, provider),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  spacing: 4,
                  children: [
                    title(widget.propertyData.placeName ?? ""),
                    const Spacer(),
                    const Icon(
                      CupertinoIcons.star_fill,
                      size: 15,
                    ),
                    rating(widget.propertyData.rating.toString())
                  ],
                ),
                description(widget.propertyData.description ?? ""),
                datet("24–29 Jul"),
                nightlyPrice("\$${widget.propertyData.nightlyPrice} night "),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox carouselImages(double width, List<String>? images, double height,
      PropertyProvider provider) {
    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
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
                  );
                },
              ),
              Positioned(
                top: 15,
                left: 15,
                child: SizedBox(
                  width: width - 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 1),
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.7),
                        ),
                        child: const Center(
                          child: Text("Олонд таалагдсан"),
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
                                  : "assets/object/Vector.svg"),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Text nightlyPrice(String price) {
    return Text(
      price,
      style: GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.bold),
    );
  }

  Text datet(String rentDate) {
    return Text(
      rentDate,
      style: GoogleFonts.roboto(
        fontSize: 15,
        color: const Color(0XFF717171),
      ),
    );
  }

  Text description(String descriptionText) {
    return Text(
      maxLines: 2,
      descriptionText,
      style: GoogleFonts.roboto(
        color: const Color(0XFF717171),
        fontSize: 15,
      ),
    );
  }

  Text rating(String rate) {
    return Text(
      rate,
      style: GoogleFonts.roboto(
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    );
  }

  Text title(String title) {
    return Text(
      title,
      style: GoogleFonts.roboto(
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    );
  }
}
