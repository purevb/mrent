import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/model/user_model.dart';
import 'package:mrent/pages/favorite_page/components/favorite_property.dart';
import 'package:mrent/pages/property_detail_page/property_detail_page.dart';
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
  TextEditingController _searchController = TextEditingController();
  bool onSearch = false;
  int currentIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  List<PropertyModel> _founders = [];
  List<PropertyModel> filteredPropertyDatas = [];
  String selectedType = "";

  void _runFilter(String enteredKeyword) {
    final provider = Provider.of<PropertyProvider>(context, listen: false);

    List<PropertyModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = provider.userFavoriteProperties;
    } else {
      results = provider.userFavoriteProperties
          .where((property) =>
              property.placeName != null &&
              property.placeName!
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _founders = results;
    });
  }

  @override
  void initState() {
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PropertyProvider>(context, listen: false);
      setState(() {
        filteredPropertyDatas = List.from(provider.userFavoriteProperties);
        _founders = List.from(provider.userFavoriteProperties);
      });
    });
    super.initState();

    _founders = [];
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && onSearch) {
      setState(() {
        onSearch = false;
      });
    }
  }

  void _scrollToIndex(int index) {
    const itemWidth = 150.0;
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
    double width = MediaQuery.of(context).size.width;
    final provider = Provider.of<PropertyProvider>(context, listen: false)
        .userFavoriteProperties;

    List<PropertyModel> typeFiltered = [];

    if (selectedType.isEmpty || selectedType == "All") {
      typeFiltered = List.from(provider);
    } else {
      typeFiltered = provider
          .where((property) => property.placeType == selectedType)
          .toList();
    }

    final displayItems =
        (onSearch && _founders.isNotEmpty) ? _founders : typeFiltered;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        elevation: 0,
        title: onSearch == false ? const Text("Таалагдсан") : const Text(""),
        centerTitle: true,
        actions: [
          AnimatedContainer(
            margin: const EdgeInsets.only(
              bottom: 10,
              left: 20,
              right: 20,
            ),
            curve: Curves.linear,
            duration: const Duration(milliseconds: 300),
            width: onSearch == false ? 56 : width - 40,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(onSearch ? 12 : 28),
              color: onSearch == false ? Colors.grey.shade200 : Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      onSearch = !onSearch;
                      if (onSearch) {
                        _focusNode.requestFocus();
                      } else {
                        _founders = [];
                        _searchController.clear();
                      }
                    });
                  },
                  icon: const Icon(
                    CupertinoIcons.search,
                    color: Colors.black87,
                  ),
                ),
                if (onSearch)
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      onChanged: (value) => _runFilter(value),
                      onSubmitted: (value) {
                        _runFilter(value);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Хайх...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                      autofocus: true,
                    ),
                  ),
              ],
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
                      selectedType =
                          appbarCategoryIcons[index]?['iconType'] ?? "";
                      currentIndex = index;
                      if (onSearch) {
                        _focusNode.requestFocus();
                      }
                    });
                    _scrollToIndex(index);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: currentIndex == index
                          ? mRed
                          : Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      spacing: 3,
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
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
          child: Column(
            children: [
              if (displayItems.isNotEmpty) ...[
                GridView.builder(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PropertyDetailPage(
                              propertyData: displayItems[index],
                            ),
                          ),
                        );
                      },
                      child: FavoriteProperty(
                        propertyData: displayItems[index],
                      ),
                    );
                  },
                  itemCount: displayItems.length,
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
                      onSearch
                          ? "Хайлтад тохирох сууц олдсонгүй."
                          : "Танд одоогоор таалагдсан сууц алга байна.",
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
