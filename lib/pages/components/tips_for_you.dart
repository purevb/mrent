import 'package:flutter/material.dart';
import 'package:mrent/pages/components/touchable_scale.dart';

class TipsForYou extends StatefulWidget {
  final String? rating;
  final String? ratingCount;
  final String? text;
  final String? location;
  final String? roomCount;
  final String? square;
  final String? rent;
  final String? path;
  const TipsForYou(
      {this.text,
      this.location,
      this.roomCount,
      this.square,
      this.rent,
      this.ratingCount,
      this.rating,
      this.path,
      super.key});

  @override
  State<TipsForYou> createState() => _TipsForYouState();
}

class _TipsForYouState extends State<TipsForYou> {
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      width: screen.width * 0.85,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 1,
                spreadRadius: 1)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: SizedBox(
              width: screen.width,
              height: screen.height * 0.12,
              child: Image.network(
                fit: BoxFit.fitWidth,
                widget.path ??
                    "https://scontent.xx.fbcdn.net/v/t1.15752-9/462565873_886592826916950_4518783065590103332_n.png?_nc_cat=110&ccb=1-7&_nc_sid=0024fc&_nc_ohc=dvKk4Z2C0fsQ7kNvgHO5NQ8&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.xx&oh=03_Q7cD1QGlXlS2YoiHDJQT7mN_zF200iJPUv3Le3C-CYVevSKrXw&oe=675FBF41",
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Бямба  гараг ,11 сарын 10, 2021",
                        style: TextStyle(
                          color: Color(0xff868686),
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        widget.text ??
                            "2022 онд Сурабаяагийн экосистемийн талаар илүү ихийг мэдэж аваарай",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff1A1E25),
                        ),
                      ),
                      Text(
                        widget.location ??
                            "Сурабая нь Индонезийн хоёр дахь том ",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xff7D7F88),
                        ),
                      ),
                      TouchableScale(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                              color: const Color(0xff917AFD).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(35)),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 24),
                            child: Text(
                              "Илүү",
                              style: TextStyle(color: Color(0xff917AFD)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: TouchableScale(
                    onPressed: () {},
                    child: Image.asset(
                        fit: BoxFit.fill,
                        width: 20,
                        height: 18,
                        "assets/images/Vector.png"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
