import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/model/fb_user_model.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/map_pages/google_maps.dart';
import 'package:mrent/pages/search_page/search_page.dart';
import 'package:mrent/utils/constants.dart';
import 'package:shimmer/shimmer.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MainAppBar({
    required this.hasLeading,
    required this.chooseType,
    this.properties,
    this.onSearchPressed,
    required this.hasLocationBar,
    this.user,
    super.key,
  });
  final FbUserModel? user;
  final bool hasLeading;
  final Function(String) chooseType;
  final Function()? onSearchPressed;
  final bool hasLocationBar;
  final List<PropertyModel>? properties;
  @override
  State<MainAppBar> createState() => _MainAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(150);
}

class _MainAppBarState extends State<MainAppBar> {
  int currentIndex = 0;
  final ScrollController _scrollController = ScrollController();
  DataController dataController = DataController();
  @override
  void initState() {
    dataController.getPropertyTypeDatas();
    super.initState();
  }

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

  String getIconPath(String typeName) {
    switch (typeName.trim()) {
      case "Байгалийн сайхан":
        return "assets/search/amazing_views.png";
      case "Байшин":
        return "assets/search/house.png";
      case "Голтой ойрхон":
        return "assets/search/near_river.png";
      case "Майхан":
        return "assets/search/tent.png";
      case "Гэр":
        return "assets/search/yurt.png";
      default:
        return "assets/search/grid.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return AppBar(
      shadowColor: Colors.black,
      toolbarHeight: height * (0.1),
      elevation: 1,
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Column(
          children: [
            Row(
              children: [
                if (widget.hasLeading)
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(CupertinoIcons.back),
                  ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SearchPage(
                                user: widget.user,
                                properties: widget.properties!);
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.only(
                          left: widget.hasLeading ? 0 : 30, right: 30),
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
                          SizedBox(
                            width: width * 0.8 - 60,
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: SvgPicture.asset(
                                    fit: BoxFit.fitHeight,
                                    "assets/search/searchbutton.svg",
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Хайлт",
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    // ignore: deprecated_member_use
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (widget.hasLocationBar == true) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: VerticalDivider(),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return CustomizeMap(
                                          hasFloatButton: true,
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
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ValueListenableBuilder(
              valueListenable: dataController.propertyTypeNotifier,
              builder: (context, propertyType, child) {
                if (propertyType == null) {
                  return SizedBox(
                    height: 70.0,
                    child: Shimmer.fromColors(
                      // ignore: deprecated_member_use
                      baseColor: Colors.grey.withOpacity(0.2),
                      highlightColor: Colors.white,
                      child: ListView.separated(
                        padding: const EdgeInsets.only(
                          left: 30,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            spacing: 10,
                            children: [
                              Container(
                                height: 30,
                                width: 30,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                              )
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            width: 10,
                          );
                        },
                      ),
                    ),
                  );
                }
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  height: 70,
                  alignment: const Alignment(0, 0),
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      final typeName = index == 0
                          ? "Бүгд"
                          : propertyType[index - 1].typeName ?? "";
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = index;
                          });
                          _scrollToIndex(index);
                          widget.chooseType(typeName);
                        },
                        child: Container(
                          // ignore: deprecated_member_use
                          color: backgroundColor.withOpacity(0),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FractionalTranslation(
                                    translation: index == 0
                                        ? const Offset(0, -0.028)
                                        : const Offset(0, 0),
                                    child: Container(
                                      height: 55,
                                      alignment: Alignment.bottomCenter,
                                      child: Image.asset(
                                        getIconPath(index == 0
                                            ? "Бүгд"
                                            : propertyType[index - 1]
                                                    .typeName ??
                                                ""),
                                        height: index == 0 ? 18 : 25,
                                        fit: BoxFit.contain,
                                        color: textDefaultColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Container(
                                    alignment: Alignment.bottomCenter,
                                    height: 55,
                                    child: Text(
                                      index == 0
                                          ? "Бүгд"
                                          : propertyType[index - 1]
                                              .typeName
                                              .toString(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
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
                    itemCount: propertyType.length + 1,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        width: 5,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
