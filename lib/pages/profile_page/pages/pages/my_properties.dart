import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mrent/components/horizontal_property.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/model/property_type.dart';
import 'package:mrent/pages/update_properties_field/update_properties_page.dart';
import 'package:mrent/utils/constants.dart';
import 'package:shimmer/shimmer.dart';

@RoutePage()
class MyPropertiesPage extends StatefulWidget {
  const MyPropertiesPage({
    required this.userPropertyDatas,
    super.key,
    this.user,
  });
  final dynamic user;
  final List<PropertyModel> userPropertyDatas;
  @override
  State<MyPropertiesPage> createState() => _MyPropertiesPageState();
}

class _MyPropertiesPageState extends State<MyPropertiesPage>
    with TickerProviderStateMixin {
  late SlidableController controller;
  String selectedType = "Бүгд";
  bool onSearch = false;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<PropertyModel> _founders = [];
  List<PropertyModel> properties = [];

  String getIconPath(String typeName) {
    switch (typeName.trim()) {
      case "Бүгд":
        return "assets/search/grid.png";
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

  final DataController dataController = DataController();
  Api api = Api();

  @override
  void initState() {
    super.initState();
    controller = SlidableController(this);
    properties = List.from(widget.userPropertyDatas);
    if (widget.user != null) {
      dataController.getRentedPropertiesData(widget.user.id);
    }
    _founders.addAll(widget.userPropertyDatas);

    _focusNode.addListener(_onFocusChange);
    dataController.getPropertyTypeDatas();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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

  void _onFocusChange() {
    if (!_focusNode.hasFocus && onSearch) {
      setState(() {
        onSearch = false;
        _founders = [];
      });
    }
  }

  void deleteProperty(int index) async {
    try {
      final propertiesToShow = onSearch ? _founders : _getFilteredProperties();

      final property = propertiesToShow[index];
      if (property.id == null) {
        debugPrint("Aldaa id alga");
        return;
      }

      final statusCode = await api.deleteProperties(
        properyId: property.id!,
      );

      if (statusCode == 200) {
        if (mounted) {
          setState(() {
            final originalIndex =
                properties.indexWhere((p) => p.id == property.id);
            if (originalIndex != -1) {
              properties.removeAt(originalIndex);

              if (onSearch) {
                _founders.removeAt(index);
              }
            }
          });
        }
      }
    } catch (e) {
      debugPrint("Ustgahad alda garlaa: $e");
    }
  }

  List<PropertyModel> _getFilteredProperties() {
    if (selectedType.isEmpty || selectedType == "Бүгд") {
      return properties;
    }

    return properties
        .where((property) =>
            property.propertyTypeId != null &&
            property.propertyTypeId?.typeName == selectedType)
        .toList();
  }

  Widget typeFilter(String typeName,
      {required int index, required List<PropertyType> propertyTypes}) {
    bool isSelected = selectedType == typeName;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedType = typeName;
        });
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          spacing: 10,
          children: [
            Row(
              spacing: 4,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    getIconPath(typeName),
                    height: index == 0 ? 18 : 10,
                    fit: BoxFit.fill,
                    color: textDefaultColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  typeName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Easing.legacy,
              child: isSelected
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
  }

  Widget _buildSearchInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        onChanged: _runFilter,
        decoration: InputDecoration(
          hintText: "Хайх...",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final propertiesToShow = onSearch ? _founders : _getFilteredProperties();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: backgroundColor,
        title: onSearch
            ? _buildSearchInput()
            : const Text("Миний түрээслүүлж буй"),
        actions: [
          IconButton(
            icon: Icon(onSearch ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                onSearch = !onSearch;
                if (!onSearch) {
                  _searchController.clear();
                  _founders = [];
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (!onSearch) ...[
            ValueListenableBuilder(
                valueListenable: dataController.propertyTypeNotifier,
                builder: (context, typeData, child) {
                  if (typeData == null || typeData.isEmpty) {
                    return SizedBox(
                      height: 40,
                      child: Shimmer.fromColors(
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
                  } else {
                    return Container(
                      padding: const EdgeInsets.only(left: 10, top: 15),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              typeFilter("Бүгд",
                                  index: 0, propertyTypes: typeData),
                              const SizedBox(width: 15),
                              ...List.generate(
                                typeData.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: typeFilter(
                                    typeData[index].typeName ?? "Бүгд",
                                    index: index + 1,
                                    propertyTypes: typeData,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }),
          ],
          Expanded(
            child: propertiesToShow.isEmpty
                ? Center(
                    child: Text(
                      onSearch
                          ? "Хайлтын үр дүн олдсонгүй"
                          : (selectedType == "Бүгд"
                              ? "Танд одоогоор түрээсэлж буй сууц алга"
                              : "Энэ төрлийн түрээсэлж буй сууц алга"),
                      style: const TextStyle(fontSize: 18),
                    ),
                  )
                : SizedBox(
                    width: width,
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shrinkWrap: true,
                      itemCount: propertiesToShow.length,
                      itemBuilder: (BuildContext context, int index) {
                        final property = propertiesToShow[index];

                        return GestureDetector(
                          onTap: () {
                            Slidable.of(context)?.close();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return UpdatePropertiesPage(
                                    propertyData: property,
                                  );
                                },
                              ),
                            );
                          },
                          child: ClipRRect(
                            child: Slidable(
                              key: ValueKey(property.id ?? 'no-id-${index}'),
                              groupTag: 'properties',
                              closeOnScroll: true,
                              endActionPane: ActionPane(
                                extentRatio: 0.2,
                                motion: const DrawerMotion(),
                                dismissible: DismissiblePane(
                                  onDismissed: () => deleteProperty(index),
                                  closeOnCancel: true,
                                ),
                                children: [
                                  CustomSlidableAction(
                                    onPressed: (context) {
                                      deleteProperty(index);
                                    },
                                    backgroundColor: const Color(0xffFF2761),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      bottomLeft: Radius.circular(25),
                                    ),
                                    child: Center(
                                      child: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: Image.asset(
                                          "assets/trash.png",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              child: HorizontalProperty(
                                propertyData: property,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: height * 0.015,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
