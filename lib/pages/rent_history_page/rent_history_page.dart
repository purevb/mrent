import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/model/rented_properties_model.dart';
import 'package:mrent/pages/property_detail_page/property_detail_page.dart';
import 'package:mrent/pages/rent_history_page/component/rented_property.dart';
import 'package:mrent/pages/rent_history_page/component/shimmer_for_history.dart';
import 'package:mrent/utils/constants.dart';
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
  List<RentedPropertiesModel> bookingData = [];
  List<PropertyModel> properties = [];
  Api api = Api();

  @override
  void initState() {
    super.initState();
    dataController.getRentedPropertiesData(widget.user.id ?? "");
    _focusNode.addListener(_onFocusChange);
    dataController.getPropertyTypeDatas();

    dataController.rentedPropertiesNotifier.addListener(_updatePropertyList);
  }

  void _updatePropertyList() {
    if (dataController.rentedPropertiesNotifier.value != null) {
      setState(() {
        bookingData = List.from(dataController.rentedPropertiesNotifier.value!);
        properties = bookingData
            .where((booking) =>
                booking.bookingId != null &&
                booking.bookingId!.propertyId != null)
            .map((booking) => booking.bookingId!.propertyId!)
            .toList();
      });
    }
  }

  @override
  void dispose() {
    dataController.rentedPropertiesNotifier.removeListener(_updatePropertyList);
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  final TextEditingController _searchController = TextEditingController();
  List<PropertyModel> _founders = [];

  void _runFilter(String enteredKeyword) {
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
    if (selectedType.isEmpty || selectedType == "Бүгд") {
      return properties;
    }

    return properties
        .where((property) =>
            property.propertyTypeId != null &&
            property.propertyTypeId!.typeName == selectedType)
        .toList();
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

  Future<void> _refresh() async {
    dataController.getRentedPropertiesData(widget.user.id ?? "");
    _focusNode.addListener(_onFocusChange);
    dataController.getPropertyTypeDatas();
    dataController.rentedPropertiesNotifier.addListener(_updatePropertyList);
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

    return FocusDetector(
      onFocusGained: () {
        _refresh();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          // ignore: deprecated_member_use
          shadowColor: Colors.black.withOpacity(0.5),
          elevation: 1,
          automaticallyImplyLeading: false,
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
            preferredSize: const Size.fromHeight(70),
            child: ValueListenableBuilder(
              valueListenable: dataController.propertyTypeNotifier,
              builder: (context, propertyTypeData, child) {
                if (propertyTypeData == null) {
                  return SizedBox(
                    height: 40.0,
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
                                margin: const EdgeInsets.only(bottom: 10),
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
                    height: 55,
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
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Image.asset(
                                  height: 20,
                                  fit: BoxFit.contain,
                                  color: textDefaultColor,
                                  getIconPath(typeName),
                                ),
                                Text(
                                  typeName,
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
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
        body: RefreshIndicator(
          color: mRed,
          onRefresh: _refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ValueListenableBuilder(
              valueListenable: dataController.rentedPropertiesNotifier,
              builder: (BuildContext context, value, Widget? child) {
                if (value == null) {
                  return const ShimmerForRentHistory();
                }

                if (properties.isEmpty && value.isNotEmpty) {
                  Future.microtask(() {
                    setState(() {
                      bookingData = List.from(value);
                      properties = bookingData
                          .where((booking) =>
                              booking.bookingId != null &&
                              booking.bookingId!.propertyId != null)
                          .map((booking) => booking.bookingId!.propertyId!)
                          .toList();
                    });
                  });
                }

                if (displayItems.isEmpty) {
                  return SizedBox(
                    height: height - 185,
                    child: Center(
                      child: Text(
                        onSearch
                            ? "Хайлтад тохирох сууц олдсонгүй."
                            : "Танд одоогоор түрээсэлсэн сууц алга байна.",
                        style: GoogleFonts.inter(
                          color: textDefaultColor,
                        ),
                      ),
                    ),
                  );
                }

                return Container(
                  margin: const EdgeInsets.only(
                    left: 20,
                    top: 5,
                    bottom: 100,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      final currentProperty = displayItems[index];
                      final correspondingOrder = bookingData.firstWhere(
                        (booking) =>
                            booking.bookingId?.propertyId?.id ==
                            currentProperty.id,
                        orElse: () => bookingData.first,
                      );

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PropertyDetailPage(
                                propertyData: currentProperty,
                              ),
                            ),
                          );
                        },
                        child: Slidable(
                          endActionPane: ActionPane(
                            extentRatio: 0.15,
                            motion: const BehindMotion(),
                            children: [
                              CustomSlidableAction(
                                padding: EdgeInsets.zero,
                                onPressed: (context) async {
                                  await api
                                      .deleteRentedProperyHistory(
                                    bookingId:
                                        correspondingOrder.bookingId?.id ?? "",
                                    userId: widget.user.id ?? "",
                                  )
                                      .then((value) {
                                    if (value == 200) {
                                      final newList =
                                          List<RentedPropertiesModel>.from(
                                              dataController
                                                      .rentedPropertiesNotifier
                                                      .value ??
                                                  []);
                                      newList.removeWhere((booking) =>
                                          booking.bookingId?.id ==
                                          correspondingOrder.bookingId?.id);

                                      dataController.rentedPropertiesNotifier
                                          .value = newList;
                                    }
                                  });
                                },
                                backgroundColor: const Color(0xffFF2761),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                child: Image.asset(
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.fill,
                                  "assets/trash.png",
                                ),
                              ),
                            ],
                          ),
                          child: RentedProperty(
                            bookingdata: correspondingOrder.bookingId!,
                          ),
                        ),
                      );
                    },
                    itemCount: displayItems.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
