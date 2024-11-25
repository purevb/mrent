import 'package:flutter/material.dart';
import 'package:mrent/pages/components/tips_for_you.dart';
import 'package:mrent/pages/components/touchable_scale.dart';

import 'components/horizantal_card.dart';
import 'components/text_field.dart';
import 'components/vertical_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  List<Widget> body = const [
    Icon(Icons.home),
    Icon(Icons.menu),
    Icon(Icons.person),
    Icon(Icons.favorite)
  ];
  var rentToggle = true;

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
                Container(
                  margin: const EdgeInsets.only(right: 15, left: 15, bottom: 5),
                  child: const Text(
                    "Таны байршил",
                    style: TextStyle(fontSize: 15, color: Color(0xff7D7F88)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 15, left: 15),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Image.asset(
                          "assets/images/location.png",
                          width: 20,
                        ),
                      ),
                      const Text(
                        "Улаанбаатар , Монгол",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 19),
                      ),
                    ],
                  ),
                ),
                searchBar(width),
                Container(
                  margin: const EdgeInsets.only(
                      right: 15, left: 15, top: 20, bottom: 20),
                  child: const Text(
                    "Tанд юу хэрэгтэй вэ?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                ),
                toggler(width),
                Container(
                  margin: const EdgeInsets.only(right: 15, left: 15, top: 20),
                  child: const Text(
                    "Тантай ойр",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.only(right: 15, left: 15, bottom: 10),
                  child: const Text(
                    "Завхан дахь 243 үл хөдлөх хөрөнгө ",
                    style: TextStyle(color: Color(0xff7D7F88), fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  height: height * 0.2,
                  child: first(),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 15, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Завхан дахь өндөр\nүнэлгээтэй",
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
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  height: height * 0.2,
                  child: second(),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  margin:
                      const EdgeInsets.only(right: 15, left: 15, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Дараагийн аялалаа\nхайж байна уу",
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
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  padding: const EdgeInsets.only(right: 10),
                  height: height * 0.25,
                  child: third(),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 15, left: 15),
                  child: const Text(
                    "Танд зориулсан tips",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 15, top: 20, right: 15),
                  padding: const EdgeInsets.only(right: 10),
                  child: fourth(),
                ),
                TouchableScale(
                  child: Container(
                    margin: const EdgeInsets.only(left: 15, top: 20, right: 15),
                    padding:
                        const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(54),
                        border: Border.all(
                          width: 2,
                          color: const Color(0xff6246EA),
                        )),
                    child: const Center(
                      child: Text(
                        "Илүү олон нийтлэл унших ",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Color(0xff6246EA)),
                      ),
                    ),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.only(left: 15, top: 20, right: 15),
                    height: height * 0.23,
                    width: width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff917AFD),
                                  Color(0xff6246EA),
                                ],
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Та өөрийн байрыг түрээслүүлэхийг хүсч байна уу?",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                                TouchableScale(
                                    child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(49),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    "Tүрээслэгч болох",
                                    style: TextStyle(
                                      color: Color(0xff6246EA),
                                    ),
                                  ),
                                ))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: width * 0.35,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            child: Image.asset(
                                fit: BoxFit.fitWidth,
                                "assets/images/puprple_house.png"),
                          ),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView first() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return TouchableScale(
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
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          width: 20,
        );
      },
      itemCount: properties.length,
    );
  }

  ListView second() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return TouchableScale(
          child: NearToYouComponenState(
            path:
                "https://scontent.xx.fbcdn.net/v/t1.15752-9/462641873_1100989061595783_4075707448027261257_n.png?_nc_cat=109&ccb=1-7&_nc_sid=0024fc&_nc_ohc=Ueq55peeF98Q7kNvgEJz5w3&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.xx&oh=03_Q7cD1QEJmKq3P3ziKvAFE3VmTbajTKhfULRl181Ri-K6OdMLIA&oe=675FF7D8",
            text: properties[index]["text"]!,
            location: properties[index]["location"]!,
            rent: properties[index]["rent"]!,
            roomCount: properties[index]["roomCount"]!,
            square: properties[index]["square"]!,
            rating: properties[index]["rating"]!,
            ratingCount: properties[index]["ratingCount"]!,
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          width: 20,
        );
      },
      itemCount: properties.length,
    );
  }

  ListView third() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return const TouchableScale(
          child: VerticalCardComponent(
            path:
                "https://scontent.xx.fbcdn.net/v/t1.15752-9/462558027_591998583259847_4304968298902437579_n.png?stp=dst-png_s480x480&_nc_cat=102&ccb=1-7&_nc_sid=0024fc&_nc_ohc=bYYM3CmE6isQ7kNvgEBuWgf&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.xx&oh=03_Q7cD1QEjWxcmzRszvMECZYneKaHKKXloMMjIV5FNUv1LlOMllw&oe=67600A3C",
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

  ListView fourth() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return const TouchableScale(
          child: TipsForYou(
            path:
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQ3Qfvw2xdCHXrUjsp9A94J0rWcH3VVaIj7gDHb3HT81ZjP1HR",
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 15,
        );
      },
      itemCount: 2,
    );
  }

  Container toggler(double width) {
    return Container(
      margin: const EdgeInsets.only(right: 15, left: 15),
      padding: const EdgeInsets.all(8),
      width: width,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.055),
        borderRadius: BorderRadius.circular(72),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  rentToggle = true;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(72),
                  gradient: rentToggle
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                              Color(0xff917AFD),
                              Color(0xff6246EA),
                            ])
                      : const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.transparent, Colors.transparent],
                        ),
                ),
                child: Center(
                  child: Text(
                    "Түрээслэх",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: rentToggle
                          ? Colors.white
                          : Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  rentToggle = false;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(72),
                  gradient: rentToggle
                      ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.transparent, Colors.transparent],
                        )
                      : const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xff917AFD),
                            Color(0xff6246EA),
                          ],
                        ),
                ),
                child: Center(
                  child: Text(
                    "Үл хөдлөх",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: !rentToggle
                          ? Colors.white
                          : Colors.black.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
        text: "Хайлт",
        prefixIcon: "assets/images/search-normal.png",
        suffixIcon: "assets/images/setting-5.png",
      ),
    );
  }
}
