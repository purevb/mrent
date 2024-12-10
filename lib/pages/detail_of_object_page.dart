import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/pages/components/touchable_scale.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DetailOfObjectPage extends StatefulWidget {
  const DetailOfObjectPage({super.key});

  @override
  State<DetailOfObjectPage> createState() => _DetailOfObjectPageState();
}

class _DetailOfObjectPageState extends State<DetailOfObjectPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final List<String> imgList = [
      'https://scontent.xx.fbcdn.net/v/t1.15752-9/465779527_553811244179204_8313992589326752841_n.png?stp=dst-png_s526x395&_nc_cat=101&ccb=1-7&_nc_sid=0024fc&_nc_ohc=QAArbCk6_O4Q7kNvgH7fJmr&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.xx&oh=03_Q7cD1QEXZnVXYuRx8XPzwqnfnuZs-QHo-s7yqt1-1MoMclgvZQ&oe=676E27F3',
      'https://scontent.xx.fbcdn.net/v/t1.15752-9/465779527_553811244179204_8313992589326752841_n.png?stp=dst-png_s526x395&_nc_cat=101&ccb=1-7&_nc_sid=0024fc&_nc_ohc=QAArbCk6_O4Q7kNvgH7fJmr&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.xx&oh=03_Q7cD1QEXZnVXYuRx8XPzwqnfnuZs-QHo-s7yqt1-1MoMclgvZQ&oe=676E27F3',
      'https://scontent.xx.fbcdn.net/v/t1.15752-9/465779527_553811244179204_8313992589326752841_n.png?stp=dst-png_s526x395&_nc_cat=101&ccb=1-7&_nc_sid=0024fc&_nc_ohc=QAArbCk6_O4Q7kNvgH7fJmr&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.xx&oh=03_Q7cD1QEXZnVXYuRx8XPzwqnfnuZs-QHo-s7yqt1-1MoMclgvZQ&oe=676E27F3',
      'https://scontent.xx.fbcdn.net/v/t1.15752-9/465779527_553811244179204_8313992589326752841_n.png?stp=dst-png_s526x395&_nc_cat=101&ccb=1-7&_nc_sid=0024fc&_nc_ohc=QAArbCk6_O4Q7kNvgH7fJmr&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.xx&oh=03_Q7cD1QEXZnVXYuRx8XPzwqnfnuZs-QHo-s7yqt1-1MoMclgvZQ&oe=676E27F3',
      'https://scontent.xx.fbcdn.net/v/t1.15752-9/465779527_553811244179204_8313992589326752841_n.png?stp=dst-png_s526x395&_nc_cat=101&ccb=1-7&_nc_sid=0024fc&_nc_ohc=QAArbCk6_O4Q7kNvgH7fJmr&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.xx&oh=03_Q7cD1QEXZnVXYuRx8XPzwqnfnuZs-QHo-s7yqt1-1MoMclgvZQ&oe=676E27F3',
      'https://scontent.xx.fbcdn.net/v/t1.15752-9/465779527_553811244179204_8313992589326752841_n.png?stp=dst-png_s526x395&_nc_cat=101&ccb=1-7&_nc_sid=0024fc&_nc_ohc=QAArbCk6_O4Q7kNvgH7fJmr&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.xx&oh=03_Q7cD1QEXZnVXYuRx8XPzwqnfnuZs-QHo-s7yqt1-1MoMclgvZQ&oe=676E27F3'
    ];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                  child: TouchableScale(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                  ),
                  child: TouchableScale(
                    onPressed: () {},
                    child: const Icon(
                      Icons.share,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              slider(height, imgList),
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Сурабая дахь Бромо\nуулыг харах бүхээг",
                          style: GoogleFonts.robotoCondensed(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 10, bottom: 10),
                          child: TouchableScale(
                            onPressed: () {},
                            child: Image.asset(
                                fit: BoxFit.fitWidth,
                                width: 20,
                                height: 20,
                                "assets/images/heart.png"),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 5),
                              width: 15,
                              height: 15,
                              child: Image.asset(
                                fit: BoxFit.fill,
                                "assets/images/star.png",
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 2.0),
                              child: Text("4.9"),
                            ),
                            const Text(
                              "(104 үзэгч)",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Image.asset(
                                "assets/images/bed.png",
                                width: 15,
                                height: 15,
                              ),
                            ),
                            const Text(
                              " 2 өрөө",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff7D7F88),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/grey_location.png",
                              width: 15,
                              height: 15,
                            ),
                            const Text(
                              "Улиастай ,Завхан",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff7D7F88),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Image.asset(
                                "assets/images/square.png",
                                width: 15,
                                height: 15,
                              ),
                            ),
                            const Text(
                              " 673 m2",
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xff7D7F88),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FeatureIcon(
                                label: 'Агааржуулагч', icon: Icons.ac_unit),
                            FeatureIcon(
                                label: 'Гал тогоо', icon: Icons.kitchen),
                            FeatureIcon(
                                label: 'үнэгүй зогсоол',
                                icon: Icons.local_parking),
                            FeatureIcon(
                                label: 'үнэгүй интернет', icon: Icons.wifi),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Map Section
                        Container(
                          height: 200,
                          color: Colors.grey[300], // Placeholder for map
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl:
                                "https://scontent.xx.fbcdn.net/v/t1.15752-9/462648092_601098165772788_825754241460003300_n.png?stp=dst-png_s600x600&_nc_cat=107&ccb=1-7&_nc_sid=0024fc&_nc_ohc=IB5r3nCh3rQQ7kNvgEpDOTD&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.xx&oh=03_Q7cD1QFNMvWOc_koBl1ybcqmTMQ9yzIFYDI9rDeH2urSwhhJUg&oe=677F1107" ??
                                    "http://via.placeholder.com/350x150",
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Nearby Locations Section
                        const Text('Хамгийн ойрхон объектууд',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        const NearbyItem(
                            icon: Icons.store,
                            label: 'Дэлгүүр',
                            distance: '200м'),
                        const NearbyItem(
                            icon: Icons.local_hospital,
                            label: 'Эмнэлэг',
                            distance: '130м'),
                        const NearbyItem(
                            icon: Icons.restaurant_rounded,
                            label: 'Хоолны газар',
                            distance: '400м'),
                        const SizedBox(height: 20),
                        // Booking Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Дундаж төлбөр',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey)),
                                Text('500₮/сард',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            TouchableScale(
                              onPressed: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(72),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xff917AFD),
                                      Color(0xff6246EA),
                                    ],
                                  ),
                                ),
                                child: Transform.translate(
                                  offset: const Offset(0, -1),
                                  child: const Text(
                                    "Түрээслэх",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  CarouselSlider slider(double height, List<String> imgList) {
    return CarouselSlider(
      options: CarouselOptions(
        height: height * 0.35,
        viewportFraction: 1.0,
        enlargeCenterPage: false,
        // autoPlay: false,
      ),
      items: imgList
          .map((item) => Center(
                  child: Image.network(
                item,
                fit: BoxFit.cover,
                height: height,
              )))
          .toList(),
    );
  }
}

class FeatureIcon extends StatelessWidget {
  final String label;
  final IconData icon;

  const FeatureIcon({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff917AFD),
                Color(0xff6246EA),
              ],
            ).createShader(bounds);
          },
          child: Icon(
            icon,
            size: 30,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class NearbyItem extends StatelessWidget {
  final String label;
  final String distance;
  final IconData icon;

  const NearbyItem({
    super.key,
    required this.icon,
    required this.label,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff917AFD),
                      Color(0xff6246EA),
                    ],
                  ).createShader(bounds);
                },
                child: Icon(
                  icon,
                  size: 25,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Text(label, style: const TextStyle(fontSize: 16)),
            ],
          ),
          Text(distance,
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}
