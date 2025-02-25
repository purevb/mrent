import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrent/model/user_model.dart';
import 'package:mrent/pages/favorite_page/components/favorite_property.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/utils/constants.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({
    this.user,
    super.key,
  });
  final User? user;

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
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
    final provider =
        Provider.of<PropertyProvider>(context).userFavoriteProperties;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // toolbarHeight: 40,
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text("Таалагдсан"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.search,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(35),
          child: SizedBox(
            height: 35,
            child: ListView.separated(
              padding: const EdgeInsets.only(left: 20),
              controller: _scrollController,
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
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: currentIndex == index
                          ? mRed
                          // ignore: deprecated_member_use
                          : Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      spacing: 10,
                      children: [
                        Text(
                          appbarCategoryIcons[index]!['iconName'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Image.asset(
                          height: 15,
                          fit: BoxFit.contain,
                          color: textDefaultColor,
                          appbarCategoryIcons[index]!['icon'],
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
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              if (provider!.isNotEmpty) ...[
                GridView.builder(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return FavoriteProperty(
                      propertyData: provider[index],
                    );
                  },
                  itemCount: provider.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: height * 0.3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    crossAxisCount: 2,
                  ),
                ),
              ] else ...[
                SizedBox(
                  height: height - 185,
                  child: Center(
                    child: Text(
                      "Танд одоогоор таалагдсан сууц алга байна.",
                      style: TextStyle(
                        color: textDefaultColor,
                      ),
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}
