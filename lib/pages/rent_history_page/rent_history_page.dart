import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/model/user_model.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/utils/constants.dart';
import 'package:provider/provider.dart';

class RentHistoryPage extends StatefulWidget {
  const RentHistoryPage({required this.user, super.key});
  final User user;

  @override
  State<RentHistoryPage> createState() => _RentHistoryPageState();
}

class _RentHistoryPageState extends State<RentHistoryPage> {
  bool onSearch = false;
  int currentIndex = 0;
  final ScrollController _scrollController = ScrollController();

  final FocusNode _focusNode = FocusNode();
  List<PropertyModel> _founders = [];

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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PropertyProvider>(context, listen: false);
      _founders = provider.userFavoriteProperties;
      setState(() {});
    });
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
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
    const itemWidth = 170.0;
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
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // toolbarHeight: 40,
        backgroundColor: backgroundColor,
        elevation: 0,
        title: const Text("Түрээсэлсэн"),
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
                      focusNode: _focusNode,
                      onChanged: (value) => _runFilter(value),
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
        child: Column(
          children: [
            SizedBox(
              height: height - 250,
              child: const Center(
                child: Text(
                  "Танд одоогоор таалагдсан сууц алга байна.",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
