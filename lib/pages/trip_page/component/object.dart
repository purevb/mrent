import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TheObject extends StatefulWidget {
  const TheObject({super.key});

  @override
  State<TheObject> createState() => _TheObjectState();
}

class _TheObjectState extends State<TheObject> {
  bool favorite = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: width,
      height: 440,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        spacing: 5,
        children: [
          Expanded(
            flex: 4,
            child: carouselImages(width),
          ),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      spacing: 4,
                      children: [
                        title("Velhe, Torna-Rajgad, India"),
                        const Spacer(),
                        const Icon(
                          CupertinoIcons.star_fill,
                          size: 15,
                        ),
                        rating("4.82")
                      ],
                    ),
                    description("Mountain and pool views"),
                    datet("24–29 Jul"),
                    nightlyPrice("₹13,228  night "),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  ClipRRect carouselImages(double width) {
    return ClipRRect(
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
                  color: Colors.white.withOpacity(0.5),
                  activeColor: Colors.white,
                ),
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl:
                      "https://hips.hearstapps.com/hmg-prod/images/laguna-beach-1488819793.jpg?crop=1.00xw:0.752xh;0,0.0313xh&resize=1200:*",
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
                        color: Colors.white.withOpacity(0.7),
                      ),
                      child: const Center(
                        child: Text("Guest favorite"),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          favorite = !favorite;
                        });
                      },
                      child: SizedBox(
                        height: 20,
                        width: 25,
                        child: SvgPicture.asset(
                            fit: BoxFit.fitHeight,
                            favorite == true
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
