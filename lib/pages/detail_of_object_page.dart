import 'package:auto_route/annotations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/model/properties.dart';
import 'package:mrent/pages/components/touchable_scale.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../providers/favorite_provider.dart';
import 'payment_page.dart';

@RoutePage()
class DetailOfObjectPage extends StatefulWidget {
  const DetailOfObjectPage({required this.propertyData, super.key});
  final PropertyData propertyData;

  @override
  State<DetailOfObjectPage> createState() => _DetailOfObjectPageState();
}

class _DetailOfObjectPageState extends State<DetailOfObjectPage> {
  late List<String> imgList;

  @override
  void initState() {
    super.initState();
    imgList = widget.propertyData.images ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                TouchableScale(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
                TouchableScale(
                  onPressed: () {},
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
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
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          width: width * 0.8,
                          height: width * 0.15,
                          child: Text(
                            maxLines: 2,
                            widget.propertyData.description ?? "",
                            style: GoogleFonts.robotoCondensed(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        TouchableScale(
                          onPressed: () {
                            setState(() {});
                            provider.toggleFavorite(widget.propertyData);
                          },
                          child: Image.asset(
                              width: 20,
                              height: 20,
                              provider.isExist(widget.propertyData)
                                  ? "assets/images/like.png"
                                  : "assets/images/heart1.png"),
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
                            Text(
                              "(${widget.propertyData.squares})",
                              style: const TextStyle(
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
                            Text(
                              "${widget.propertyData.numBeds.toString()} өрөө",
                              style: const TextStyle(
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
                            Text(
                              widget.propertyData.location.toString(),
                              style: const TextStyle(
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
                            Text(
                              "${widget.propertyData.squares.toString()}м2",
                              style: const TextStyle(
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
                          width: width,
                          color: Colors.grey[300],
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl:
                                "https://scontent.xx.fbcdn.net/v/t1.15752-9/462648092_601098165772788_825754241460003300_n.png?stp=dst-png_s600x600&_nc_cat=107&ccb=1-7&_nc_sid=0024fc&_nc_ohc=IB5r3nCh3rQQ7kNvgEpDOTD&_nc_ad=z-m&_nc_cid=0&_nc_zt=23&_nc_ht=scontent.xx&oh=03_Q7cD1QFNMvWOc_koBl1ybcqmTMQ9yzIFYDI9rDeH2urSwhhJUg&oe=677F1107",
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(height: 20),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Дундаж төлбөр',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey)),
                                Text(
                                    '${widget.propertyData.nightlyPrice}₮/сард',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            TouchableScale(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PaymentPage()));
                              },
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

  const FeatureIcon({super.key, required this.label, required this.icon});

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
