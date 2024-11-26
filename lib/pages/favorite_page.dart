import 'package:flutter/material.dart';
import 'package:mrent/pages/components/tips_for_you.dart';
import 'package:mrent/pages/components/touchable_scale.dart';

import 'components/horizantal_card.dart';
import 'components/text_field.dart';
import 'components/vertical_card.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final List<Map<String, String>> properties = [
    {
      "text": "Завхан дахь байшин",
      "location": "Malang, Probolinggo",
      "rent": "527",
      "roomCount": "7",
      "square": "100",
      "rating": "4.8",
      "ratingCount": "100"
    },
    {
      "text": "Улаанбаатар төв байшин",
      "location": "Ulaanbaatar, Bayanzurkh",
      "rent": "750",
      "roomCount": "5",
      "square": "150",
      "rating": "4.9",
      "ratingCount": "150"
    },
    {
      "text": "Эрдэнэт орон сууц",
      "location": "Erdenet, Bulgan",
      "rent": "420",
      "roomCount": "3",
      "square": "90",
      "rating": "4.6",
      "ratingCount": "85"
    },
    {
      "text": "Дархан шинэ хороолол",
      "location": "Darkhan, Selenge",
      "rent": "600",
      "roomCount": "4",
      "square": "110",
      "rating": "4.7",
      "ratingCount": "120"
    },
    {
      "text": "Хөвсгөл нуурын байшин",
      "location": "Khuvsgul, Khatgal",
      "rent": "800",
      "roomCount": "6",
      "square": "200",
      "rating": "5.0",
      "ratingCount": "300"
    }
  ];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(bottom: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                searchBar(width),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 28,right: 28),
                  height: height,
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return TouchableScale(
                        child: SizedBox(
                          height: height * 0.22,
                          child: NearToYouComponenState(
                            path:
                                "https://scontent.xx.fbcdn.net/v/t1.15752-9/462565873_886592826916950_4518783065590103332_n.png?_nc_cat=110&ccb=1-7&_nc_sid=0024fc&_nc_ohc=dvKk4Z2C0fsQ7kNvgHO5NQ8&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.xx&oh=03_Q7cD1QGlXlS2YoiHDJQT7mN_zF200iJPUv3Le3C-CYVevSKrXw&oe=675FBF41",
                            text: properties[index]["text"]!,
                            location: properties[index]["location"]!,
                            rent: properties[index]["rent"]!,
                            roomCount: properties[index]["roomCount"]!,
                            square: properties[index]["square"]!,
                            rating: properties[index]["rating"]!,
                            ratingCount: properties[index]["ratingCount"]!,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 20,
                      );
                    },
                    itemCount: properties.length,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container searchBar(double width) {
    return Container(
      margin: const EdgeInsets.only(right: 25, left: 25, bottom: 10),
      width: width,
      child: CustomizedTextField(
        isDense: true,
        color: Colors.black.withOpacity(0.03),
        text: "Таалагдсан объектүүдаас хайх",
        prefixIcon: "assets/images/search-normal.png",
        suffixIcon: "assets/images/setting-5.png",
      ),
    );
  }
}
