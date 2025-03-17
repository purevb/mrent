import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/property_detail_page/components/google_maps.dart';
import 'package:mrent/pages/search_page/search_page.dart';
import 'package:mrent/utils/constants.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MainAppBar({
    required this.chooseType,
    this.properties,
    required this.hasLocationBar,
    super.key,
  });
  final Function(String) chooseType;
  final bool hasLocationBar;
  final List<PropertyModel>? properties;
  @override
  State<MainAppBar> createState() => _MainAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(140);
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
    const itemWidth = 105.0;
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
      "icon": "assets/search/grid.png",
      "iconName": "Бүгд",
      "iconType": "All"
    },
    1: {
      "icon": "assets/search/amazing_views.png",
      "iconName": "Байгалын сайхан",
      "iconType": "Nature",
    },
    2: {
      "icon": "assets/search/house.png",
      "iconName": " Байшин",
      "iconType": "House",
    },
    3: {
      "icon": "assets/search/near_river.png",
      "iconName": "Голтой ойрхон",
      "iconType": "River",
    },
    4: {
      "icon": "assets/search/tent.png",
      "iconName": "Майхан",
      "iconType": "Tent",
    },
    5: {
      "icon": "assets/search/yurt.png",
      "iconName": "Гэр",
      "iconType": "Yurts",
    },
  };

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return AppBar(
      toolbarHeight: height * (0.1),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: const EdgeInsets.only(left: 30, right: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SearchPage(
                                      properties: widget.properties!);
                                },
                              ),
                            );
                          },
                          child: Row(
                            spacing: 10,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: SvgPicture.asset(
                                  fit: BoxFit.fitHeight,
                                  "assets/search/searchbutton.svg",
                                  // ignore: deprecated_member_use
                                  color: Colors.black.withOpacity(0.8),
                                ),
                              ),
                              Text(
                                "Хайлт",
                                style: TextStyle(
                                  fontSize: 18,
                                  // ignore: deprecated_member_use
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (widget.hasLocationBar == true) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: VerticalDivider(),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return const MapSample(
                                      hasAppBar: true,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Icon(
                              CupertinoIcons.location,
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              height: 65,
              alignment: const Alignment(0, 0),
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
                      widget
                          .chooseType(appbarCategoryIcons[index]!['iconType']);
                    },
                    child: Container(
                      color: backgroundColor.withOpacity(0),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        spacing: 5,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 5,
                            children: [
                              FractionalTranslation(
                                translation: index == 0
                                    ? const Offset(0, -0.028)
                                    : const Offset(0, 0),
                                child: Container(
                                  height: 55,
                                  alignment: Alignment.bottomCenter,
                                  child: Image.asset(
                                    height: index == 0 ? 18 : 25,
                                    fit: BoxFit.contain,
                                    color: textDefaultColor,
                                    appbarCategoryIcons[index]!['icon'],
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.bottomCenter,
                                height: 55,
                                child: Text(
                                  appbarCategoryIcons[index]!['iconName'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
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
