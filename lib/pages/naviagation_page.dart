import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mrent/components/Shimmers/main_page_shimmer.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/favorite_page/favorite_checker.dart';
import 'package:mrent/pages/map_pages/google_maps.dart';
import 'package:mrent/pages/profile_page/profile_checker.dart';
import 'package:mrent/pages/rent_history_page/rent_checker.dart';
import 'package:mrent/pages/trip_page/trip_page.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/utils/constants.dart';
import 'package:provider/provider.dart';

@RoutePage()
class NavigationPage extends StatefulWidget {
  const NavigationPage({this.user, this.id, super.key});
  final String? id;
  final MongoUserModel? user;

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;
  bool _isLoading = false;
  late final DataController _dataController;
  late final Api _api;
  MongoUserModel? _mongoUser;
  final Key mapKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _dataController = DataController();
    _api = Api();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await _dataController.getPropertiesData();

      if (widget.id != null && widget.id!.isNotEmpty) {
        await _loadUserData(widget.id!);
      }

      if (mounted) {
        setState(() => _isLoading = true);
      }
    } catch (e) {
      log('Initialization error: $e');
      if (mounted) {
        setState(() => _isLoading = true);
      }
    }
  }

  Future<void> _loadUserData(String userId) async {
    try {
      final document = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (document.exists && mounted) {
        final mongoUser = await _api.getMongoUser(userId);
        if (mounted) {
          Provider.of<PropertyProvider>(context, listen: false)
              .authenticatedUser(mongoUser);
          setState(() => _mongoUser = mongoUser);
        }
      }
    } catch (e) {
      log('Error loading user: $e');
    }
  }

  Future<void> _refreshData() async {
    await Future.wait([
      _dataController.getPropertiesData(),
      if (widget.id != null && widget.id!.isNotEmpty) _loadUserData(widget.id!),
    ]);
  }

  void _handleNavigation(int index) {
    if (index == _currentIndex) {
      _refreshData();
    } else {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: ValueListenableBuilder<List<PropertyModel>?>(
          valueListenable: _dataController.propertyDataNotifier,
          builder: (context, propertyData, _) {
            if (!_isLoading) {
              return const ShimmerLoadingWidget();
            }
            return IndexedStack(
              index: _currentIndex,
              children: [
                TripPage(
                  refresh: _refreshData,
                  user: _mongoUser,
                  propertyDatas: propertyData ?? [],
                ),
                CustomizeMap(
                  key: mapKey,
                  propertyData: propertyData ?? [],
                  hasFloatButton: false,
                  hasAppBar: true,
                ),
                RentChecker(
                  user: _mongoUser ?? widget.user,
                ),
                FavoriteChecker(
                  user: _mongoUser ?? widget.user,
                ),
                ProfileChecker(
                  user: _mongoUser ?? widget.user,
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: _buildBottomNavBar(),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        backgroundColor: backgroundColor,
        unselectedFontSize: 10,
        selectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: const Color(0xff7D8588),
        selectedItemColor: mRed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        onTap: _handleNavigation,
        items: [
          _buildNavItem(
            label: "Аялах",
            iconPath: "assets/navigationbar/search.svg",
            isSvg: true,
            index: 0,
          ),
          _buildNavItem(
            label: "Байршил",
            iconPath: "assets/navigationbar/lco.svg",
            isSvg: true,
            index: 1,
          ),
          _buildNavItem(
            label: "Түрээсэлсэн",
            iconPath: "assets/navigationbar/icons8-m-key-100.png",
            isSvg: false,
            index: 2,
          ),
          _buildNavItem(
            label: "Таалагдсан",
            iconPath: "assets/navigationbar/favorite.svg",
            isSvg: true,
            index: 3,
          ),
          _buildNavItem(
            label: "Профайл",
            iconPath: "assets/navigationbar/profile.svg",
            isSvg: true,
            index: 4,
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required String label,
    required String iconPath,
    required bool isSvg,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    final iconSize = isSelected ? 35.0 : 30.0;
    final color = isSelected ? mRed : const Color(0xff7D8588);

    return BottomNavigationBarItem(
      label: label,
      icon: SizedBox(
        height: 35,
        width: 35,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: iconSize,
          width: iconSize,
          child: isSvg
              ? SvgPicture.asset(
                  iconPath,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                )
              : Image.asset(
                  iconPath,
                  fit: BoxFit.contain,
                  color: color,
                ),
        ),
      ),
    );
  }
}
