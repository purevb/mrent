import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mrent/pages/trip_page/component/object.dart';

class TripPage extends StatefulWidget {
  const TripPage({super.key});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 100,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0.8,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 30, left: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1000),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                height: height * 0.075,
                child: Row(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: SvgPicture.asset(
                        fit: BoxFit.fitHeight,
                        "assets/search/searchbutton.svg",
                      ),
                    ),
                    const Text(
                      "Search",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                height: 85,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      child: SizedBox(
                        width: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 55,
                              alignment: Alignment.bottomCenter,
                              child: CachedNetworkImage(
                                height: 35,
                                imageUrl:
                                    "https://instagram.fuln6-1.fna.fbcdn.net/v/t1.15752-9/475460784_9082467491866861_4998900830106392510_n.png?stp=cp0_dst-png&_nc_cat=102&ccb=1-7&_nc_sid=0024fc&_nc_ohc=5v6VYkx5Z4EQ7kNvgE3r5gs&_nc_oc=AdjphqIBie0G2mT2CySK4IqEImh66PDitJWehshXrOcZg9qJncUeyBfJpnoIGdu_MKg&_nc_zt=23&_nc_ht=instagram.fuln6-1.fna&oh=03_Q7cD1gEpe-pUXxYkd5HGOjia4uWRGwlCGcUPW6sEQPQTJ2sKOg&oe=67CB7F71",
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                              child: Text(
                                "Data",
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              switchInCurve: Easing.legacy,
                              child: currentIndex == index
                                  ? Container(
                                      width: 40,
                                      key: ValueKey<int>(index),
                                      height: 2,
                                      decoration: const BoxDecoration(
                                        color: Colors.black,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: 10,
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 5,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return const TheObject();
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 20);
          },
          itemCount: 10,
        ),
      ),
    );
  }
}
