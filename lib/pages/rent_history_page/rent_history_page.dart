import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/favorite_page/components/favorite_property.dart';
import 'package:mrent/pages/property_detail_page/property_detail_page.dart';
import 'package:mrent/pages/rent_history_page/component/shimmer_for_history.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class RentHistoryPage extends StatefulWidget {
  const RentHistoryPage({required this.user, super.key});
  final MongoUserModel user;

  @override
  State<RentHistoryPage> createState() => _RentHistoryPageState();
}

class _RentHistoryPageState extends State<RentHistoryPage> {
  bool onSearch = false;
  int currentIndex = 0;
  final ScrollController _scrollController = ScrollController();
  DataController dataController = DataController();
  final FocusNode _focusNode = FocusNode();
  String selectedType = "Бүгд";

  @override
  void initState() {
    super.initState();
    dataController.getRentedPropertiesData(widget.user.id ?? "");
    _focusNode.addListener(_onFocusChange);
    dataController.getPropertyTypeDatas();

    // _refreshData();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  final TextEditingController _searchController = TextEditingController();
  List<PropertyModel> _founders = [];

  void _runFilter(String enteredKeyword) {
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    List<PropertyModel> properties = provider.getUserfavoriteProperties;

    List<PropertyModel> results = [];
    if (properties.isNotEmpty) {
      if (enteredKeyword.isEmpty) {
        results = properties;
      } else {
        results = properties
            .where((property) =>
                property.propertyName != null &&
                property.propertyName!
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()))
            .toList();
      }
    }

    setState(() {
      _founders = results;
    });
  }

  List<PropertyModel> _getFilteredProperties() {
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    List<PropertyModel> properties = provider.getUserfavoriteProperties;

    if (selectedType.isNotEmpty && selectedType != "Бүгд") {
      properties = properties
          .where((property) =>
              property.propertyTypeId != null &&
              property.propertyTypeId!.typeName == selectedType)
          .toList();
    }
    return properties;
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && onSearch) {
      setState(() {
        onSearch = false;
        _founders = [];
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
    final displayItems = (onSearch && _founders.isNotEmpty)
        ? _founders
        : _getFilteredProperties();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        elevation: 0,
        title: onSearch == false ? const Text("Түрээсэлсэн") : const Text(""),
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
                  icon: Icon(
                    onSearch == false
                        ? CupertinoIcons.search
                        : CupertinoIcons.xmark,
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
          child: ValueListenableBuilder(
            valueListenable: dataController.propertyTypeNotifier,
            builder: (context, propertyTypeData, child) {
              if (propertyTypeData == null) {
                return SizedBox(
                  height: 30.0,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.withOpacity(0.2),
                    highlightColor: Colors.white,
                    child: ListView.separated(
                      padding: const EdgeInsets.only(
                        left: 20,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
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
                          width: 5,
                        );
                      },
                    ),
                  ),
                );
              } else {
                final allTypes = [
                  ...propertyTypeData,
                ];

                return SizedBox(
                  height: 35,
                  child: ListView.separated(
                    padding: const EdgeInsets.only(left: 20),
                    controller: _scrollController,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      final typeName = index == 0
                          ? "Бүгд"
                          : allTypes[index - 1].typeName ?? "";

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedType = typeName;
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
                            children: [
                              Text(
                                typeName,
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 3),
                              Image.asset(
                                height: 15,
                                fit: BoxFit.contain,
                                color: textDefaultColor,
                                getIconPath(typeName),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: allTypes.length + 1,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        width: 5,
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: dataController.rentedPropertiesNotifier,
          builder: (BuildContext context, value, Widget? child) {
            if (value == null) {
              return ShimmerForRentHistory();
            }

            if (displayItems.isEmpty) {
              return SizedBox(
                height: height - 185,
                child: Center(
                  child: Text(
                    onSearch
                        ? "Хайлтад тохирох сууц олдсонгүй."
                        : "Танд одоогоор таалагдсан сууц алга байна.",
                    style: GoogleFonts.inter(
                      color: textDefaultColor,
                    ),
                  ),
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.only(
                left: 20,
                top: 20,
                right: 20,
                bottom: 100,
              ),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
            );
          },
        ),
      ),
    );
  }
}
