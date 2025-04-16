import 'package:flutter/material.dart';
import 'package:mrent/components/main_appbar.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/favorite_model.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/property_detail_page/property_detail_page.dart';
import 'package:mrent/pages/trip_page/component/object.dart';
import 'package:mrent/utils/constants.dart';
import 'package:shimmer/shimmer.dart';

class TripPage extends StatefulWidget {
  final MongoUserModel? user;
  final List<PropertyModel> propertyDatas;
  final bool? gotData;

  const TripPage({
    this.user,
    required this.propertyDatas,
    this.gotData,
    super.key,
  });

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  late List<PropertyModel> filteredPropertyData;
  final DataController dataController = DataController();
  String selectedCategory = "Бүгд";
  List<String> favoriteProperties = [];
  bool _isFavoritesLoading = true;
  List<FavoriteModel> favoriteModels = [];
  Api api = Api();

  @override
  void initState() {
    super.initState();
    filteredPropertyData = List.from(widget.propertyDatas);
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    if (widget.user == null) {
      setState(() => _isFavoritesLoading = false);
      return;
    }

    try {
      favoriteModels = await api.getFavorites(widget.user!.id!);
      if (mounted) {
        setState(() {
          favoriteProperties =
              favoriteModels.map((fav) => fav.propertyId!.id!).toList();
          _isFavoritesLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isFavoritesLoading = false);
      }
    }
  }

  void filterTypes(String categoryType) {
    setState(() {
      selectedCategory = categoryType;
      filteredPropertyData = categoryType == "Бүгд"
          ? List.from(widget.propertyDatas)
          : widget.propertyDatas
              .where((property) =>
                  property.propertyTypeId!.typeName == categoryType)
              .toList();
    });
  }

  void _updateFavorite(String propertyId, bool isFavorite) {
    setState(() {
      if (isFavorite) {
        favoriteProperties.add(propertyId);
      } else {
        favoriteProperties.remove(propertyId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayData = selectedCategory == "Бүгд"
        ? widget.propertyDatas
        : filteredPropertyData;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: MainAppBar(
        hasLeading: false,
        properties: widget.propertyDatas,
        hasLocationBar: true,
        chooseType: filterTypes,
      ),
      body: Builder(builder: (context) {
        if (_isFavoritesLoading == true) {
          return Shimmer.fromColors(
            // ignore: deprecated_member_use
            baseColor: Colors.grey.withOpacity(0.1),
            highlightColor: Colors.white,
            child: ListView.separated(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
              ),
              scrollDirection: Axis.vertical,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: height * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: height * 0.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 10,
                );
              },
            ),
          );
        } else {
          return ListView.separated(
            itemCount: displayData.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final property = displayData[index];
              return PropertyListItem(
                property: property,
                isFavorite: favoriteProperties.contains(property.id),
                onFavoriteChanged: (isFavorite) {
                  _updateFavorite(property.id!, isFavorite);
                },
              );
            },
          );
        }
      }),
    );
  }
}

class PropertyListItem extends StatelessWidget {
  final PropertyModel property;
  final bool isFavorite;
  final Function(bool) onFavoriteChanged;

  const PropertyListItem({
    required this.property,
    required this.isFavorite,
    required this.onFavoriteChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PropertyDetailPage(propertyData: property),
        ),
      ),
      child: TheObject(
        propertyData: property,
        favoriteProperty: isFavorite,
      ),
    );
  }
}
