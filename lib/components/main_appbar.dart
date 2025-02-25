import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mrent/pages/property_detail_page/components/google_maps.dart';
import 'package:mrent/utils/constants.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MainAppBar({required this.hasLocationBar, super.key});
  final bool hasLocationBar;
  @override
  State<MainAppBar> createState() => _MainAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(160);
}

class _MainAppBarState extends State<MainAppBar> {
  int currentIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToIndex(int index) {
    const itemWidth = 85.0;
    final screenWidth = MediaQuery.of(context).size.width;
    const padding = 10.0;
    double targetOffset =
        (itemWidth * index) - (screenWidth / 2) + (itemWidth / 2) + padding;
    targetOffset = targetOffset.clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Map<int, Map<String, dynamic>> appbarCategoryIcons = {
    0: {
      "icon": "assets/search/amazing_views.png",
      "iconName": "Байгалын сайхан",
    },
    1: {
      "icon": "assets/search/house.png",
      "iconName": " Байшин",
    },
    2: {
      "icon": "assets/search/near_river.png",
      "iconName": "Голтой ойрхон",
    },
    3: {
      "icon": "assets/search/tent.png",
      "iconName": "Майхан",
    },
    4: {
      "icon": "assets/search/yurt.png",
      "iconName": "Гэр",
    },
  };

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return AppBar(
      toolbarHeight: height * (0.11),
      shadowColor: Colors.black,
      backgroundColor: backgroundColor,
      elevation: 0.8,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        left: 30,
                        right: widget.hasLocationBar == true ? 10 : 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1000),
                      color: backgroundColor,
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: textDefaultColor.withOpacity(0.15),
                          blurRadius: 2,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    height: height * 0.07,
                    child: Row(
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
                        Text(
                          "Хайлт",
                          style: TextStyle(
                            fontSize: 18,
                            color: textDefaultColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.hasLocationBar == true)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const MapSample(
                          hasAppBar: true,
                        );
                      }));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      height: height * 0.05,
                      width: height * 0.05,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: textDefaultColor.withOpacity(0.15),
                            blurRadius: 2,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        shape: BoxShape.circle,
                        color: backgroundColor,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(
                        CupertinoIcons.location,
                      ),
                    ),
                  )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              height: 85,
              child: ListView.separated(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = index;
                      });
                      _scrollToIndex(index);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 55,
                            alignment: Alignment.bottomCenter,
                            child: Image.asset(
                              height: 25,
                              fit: BoxFit.contain,
                              color: textDefaultColor,
                              appbarCategoryIcons[index]!['icon'],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                            child: Text(
                              appbarCategoryIcons[index]!['iconName'],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
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
                                    decoration: BoxDecoration(
                                      color: mRed,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: appbarCategoryIcons.length,
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
    );
  }
}
