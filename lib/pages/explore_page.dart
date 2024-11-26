import 'package:flutter/material.dart';

import 'components/text_field.dart';
import 'components/touchable_scale.dart';
import 'components/vertical_card.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
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
    var screen = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xffFCFCFC),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                searchBar(screen.width),
                Container(
                  margin: const EdgeInsets.only(right: 15, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Дараагийн аялалаа\nхайж байна уу?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 19),
                      ),
                      GestureDetector(
                        child: const Text(
                          "Бүгд",
                          style: TextStyle(color: Color(0xff6246EA)),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  padding: const EdgeInsets.only(right: 10),
                  height: screen.height * 0.3,
                  child: first(screen.width, screen.height),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 15, left: 15),
                  child: const Text(
                    "Амьдралынхаа хэв маягийг\nсудалж мэдмээр байна уу?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  padding: const EdgeInsets.only(right: 10),
                  height: screen.height * 0.3,
                  child: second(screen.width, screen.height),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 15, left: 15),
                  child: const Text(
                    "Бусад газрын соёлоос\nсуралцмаар байна уу?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  padding: const EdgeInsets.only(right: 10),
                  height: screen.height * 0.3,
                  child: third(screen.width, screen.height),
                ),
              ],
            ),
          ),
        ));
  }

  ListView first(double width, double height) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return TouchableScale(
          child: VerticalCardComponent(
            hasTitle: false,
            width: width * 0.44,
            height: height * 0.4,
            path:
                "https://scontent.xx.fbcdn.net/v/t1.15752-9/462565873_886592826916950_4518783065590103332_n.png?_nc_cat=110&ccb=1-7&_nc_sid=0024fc&_nc_ohc=dvKk4Z2C0fsQ7kNvgHO5NQ8&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.xx&oh=03_Q7cD1QGlXlS2YoiHDJQT7mN_zF200iJPUv3Le3C-CYVevSKrXw&oe=675FBF41",
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          width: 15,
        );
      },
      itemCount: properties.length,
    );
  }

  ListView second(double width, double height) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return TouchableScale(
          child: VerticalCardComponent(
            width: width * 0.5,
            height: height * 0.4,
            path:
                "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcR3bPHIg0n2TwJb8DsZC4T20PNX3okWGupTSOG9IyvdvvgwHVnq",
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          width: 15,
        );
      },
      itemCount: properties.length,
    );
  }

  ListView third(double width, double height) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return TouchableScale(
          child: VerticalCardComponent(
            width: width * 0.5,
            height: height * 0.4,
            path:
                "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSI7MS0iZv3HnjZW7G5vcS5BraqYFbMHBjNSJlHAWGV-P5JsUH_",
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          width: 15,
        );
      },
      itemCount: properties.length,
    );
  }

  Container searchBar(double width) {
    return Container(
      margin: const EdgeInsets.only(right: 25, left: 25, bottom: 10),
      width: width,
      child: const CustomizedTextField(
        isDense: true,
        color: Color(0xffF2F2F3),
        text: "Хайлт",
        prefixIcon: "assets/images/search-normal.png",
        suffixIcon: "assets/images/setting-5.png",
      ),
    );
  }
}
