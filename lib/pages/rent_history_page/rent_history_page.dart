import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/mongo_user_model.dart';
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
  final DataController dataController = DataController();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final Api api = Api();

  String selectedType = "Бүгд";
  List<RentedPropertiesModel> bookingData = [];
  List<RentedPropertiesModel> _foundersBookings = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _focusNode.addListener(_onFocusChange);
    dataController.rentedPropertiesNotifier.addListener(_updateBookingList);
  }

  Future<void> _initializeData() async {
    await dataController.getRentedPropertiesData(widget.user.id ?? "");
    await dataController.getPropertyTypeDatas();
  }

  void _updateBookingList() {
    final rentedProperties = dataController.rentedPropertiesNotifier.value;
    if (rentedProperties != null && mounted) {
      setState(() {
        bookingData = List.from(rentedProperties);
      });
    }
  }

  @override
  void dispose() {
    dataController.rentedPropertiesNotifier.removeListener(_updateBookingList);
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _runFilter(String enteredKeyword) {
    if (!mounted) return;

    List<RentedPropertiesModel> results = [];
    if (bookingData.isNotEmpty) {
      if (enteredKeyword.isEmpty) {
        results = bookingData;
      } else {
        results = bookingData
            .where((booking) =>
                booking.bookingId?.propertyId?.propertyName != null &&
                booking.bookingId!.propertyId!.propertyName!
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()))
            .toList();
      }
    }

    setState(() {
      _foundersBookings = results;
    });
  }

  List<RentedPropertiesModel> _getFilteredBookings() {
    if (selectedType.isEmpty || selectedType == "Бүгд") {
      return bookingData;
    }

    return bookingData
        .where((booking) =>
            booking.bookingId?.propertyId?.propertyTypeId?.typeName ==
            selectedType)
        .toList();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && onSearch && mounted) {
      setState(() {
        onSearch = false;
        _foundersBookings = [];
        _searchController.clear();
      });
    }
  }

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients) return;

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
    try {
      await _initializeData();
    } catch (e) {
      debugPrint('Error refreshing data: $e');
    }
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

  Future<void> _deleteRentedProperty(
      RentedPropertiesModel correspondingOrder) async {
    try {
      final result = await api.deleteRentedProperyHistory(
        bookingId: correspondingOrder.bookingId?.id ?? "",
        userId: widget.user.id ?? "",
      );

      if (result == 200 && mounted) {
        final currentList = dataController.rentedPropertiesNotifier.value;
        if (currentList != null) {
          final newList = List<RentedPropertiesModel>.from(currentList);
          newList.removeWhere((booking) =>
              booking.bookingId?.id == correspondingOrder.bookingId?.id);
          dataController.rentedPropertiesNotifier.value = newList;
        }
      }
    } catch (e) {
      debugPrint('Error deleting rented property: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final displayItems = (onSearch && _foundersBookings.isNotEmpty)
        ? _foundersBookings
        : _getFilteredBookings();

    return FocusDetector(
      onFocusGained: _refresh,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          shadowColor: Colors.black.withOpacity(0.5),
          elevation: 1,
          automaticallyImplyLeading: false,
          title: onSearch ? null : const Text("Түрээсэлсэн"),
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
              width: onSearch ? size.width - 40 : 56,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(onSearch ? 12 : 28),
                color: onSearch ? Colors.white : Colors.grey.shade200,
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
                          _foundersBookings = [];
                          _searchController.clear();
                        }
                      });
                    },
                    icon: Icon(
                      onSearch ? CupertinoIcons.xmark : CupertinoIcons.search,
                      color: Colors.black87,
                    ),
                  ),
                  if (onSearch)
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        onChanged: _runFilter,
                        onSubmitted: _runFilter,
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
                        padding: const EdgeInsets.only(left: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            height: 30,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 5),
                      ),
                    ),
                  );
                }

                final allTypes = [...propertyTypeData];

                return SizedBox(
                  height: 55,
                  child: ListView.separated(
                    padding: const EdgeInsets.only(left: 20),
                    controller: _scrollController,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: allTypes.length + 1,
                    itemBuilder: (context, index) {
                      final typeName = index == 0
                          ? "Бүгд"
                          : allTypes[index - 1].typeName ?? "";

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedType = typeName;
                            currentIndex = index;
                          });
                          _scrollToIndex(index);
                          if (onSearch) {
                            _focusNode.requestFocus();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Image.asset(
                                getIconPath(typeName),
                                height: 20,
                                fit: BoxFit.contain,
                                color: textDefaultColor,
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
                                        key: ValueKey<int>(index),
                                        width: 40,
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 5),
                  ),
                );
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
              builder: (context, value, child) {
                if (value == null) {
                  return const ShimmerForRentHistory();
                }

                if (bookingData.isEmpty && value.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _updateBookingList();
                  });
                }

                if (displayItems.isEmpty) {
                  return SizedBox(
                    height: size.height - 185,
                    child: Center(
                      child: Text(
                        onSearch
                            ? "Хайлтад тохирох захиалга олдсонгүй."
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
                    padding: const EdgeInsets.only(top: 10),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayItems.length,
                    itemBuilder: (context, index) {
                      final reversedIndex = displayItems.length - index - 1;
                      final currentBooking = displayItems[reversedIndex];

                      if (currentBooking.bookingId?.propertyId == null) {
                        return const SizedBox.shrink();
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PropertyDetailPage(
                                propertyData:
                                    currentBooking.bookingId!.propertyId!,
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
                                onPressed: (context) =>
                                    _deleteRentedProperty(currentBooking),
                                backgroundColor: const Color(0xffFF2761),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                child: Image.asset(
                                  "assets/trash.png",
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ],
                          ),
                          child: RentedProperty(
                            bookingdata: currentBooking.bookingId!,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
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
