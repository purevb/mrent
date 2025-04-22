import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mrent/components/main_appbar.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/favorite_model.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/property_detail_page/property_detail_page.dart';
import 'package:mrent/pages/trip_page/component/object.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TripPage extends StatefulWidget {
  final MongoUserModel? user;
  final List<PropertyModel> propertyDatas;
  final bool? gotData;
  final RefreshCallback? refresh;

  const TripPage({
    this.user,
    required this.propertyDatas,
    this.gotData,
    this.refresh,
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
      if (mounted) {
        setState(() {
          _isFavoritesLoading = false;
        });
      }
      return;
    }

    try {
      log("Loading favorites for user: ${widget.user!.id}");
      final favoriteModels = await api.getFavorites(widget.user!.id!);
      log("Loaded ${favoriteModels.length} favorites");

      if (!mounted) return;

      final provider = Provider.of<PropertyProvider>(context, listen: false);
      List<PropertyModel> favoritePropertyObjects = [];

      for (var favModel in favoriteModels) {
        if (favModel.propertyId != null) {
          final property = widget.propertyDatas.firstWhere(
            (p) => p.id == favModel.propertyId!.id,
            orElse: () => favModel.propertyId!,
          );
          favoritePropertyObjects.add(property);
        }
      }

      provider.addFavoriteProperties(favoritePropertyObjects);

      setState(() {
        favoriteProperties = favoriteModels
            .where((fav) => fav.propertyId?.id != null)
            .map((fav) => fav.propertyId!.id!)
            .toList();
        _isFavoritesLoading = false;
      });
    } catch (e) {
      log("Error loading favorites: $e");
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
        if (widget.propertyDatas.isEmpty) {
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
          return RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                widget.refresh?.call() ?? Future.value(),
                _loadFavorites(),
              ]);
            },
            child: ListView.separated(
              itemCount: displayData.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                int reversedIndex = displayData.length - index - 1;
                final property = displayData[reversedIndex];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PropertyDetailPage(
                        propertyData: property,
                      ),
                    ),
                  ),
                  child: TheObject(
                    propertyData: property,
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }
}
