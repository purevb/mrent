import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/favorite_page/favorite_checker.dart';
import 'package:mrent/pages/profile_page/profile_checker.dart';
import 'package:mrent/pages/map_pages/google_maps.dart';
import 'package:mrent/pages/rent_history_page/rent_checker.dart';
import 'package:mrent/pages/trip_page/trip_page.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: ValueListenableBuilder<List<PropertyModel>?>(
          valueListenable: _dataController.propertyDataNotifier,
          builder: (context, propertyData, _) {
            if (!_isLoading) {
              return _buildShimmerLoading(height, width);
            }
            return IndexedStack(
              index: _currentIndex,
              children: [
                TripPage(
                  refresh: _refreshData,
                  user: _mongoUser,
                  propertyDatas: propertyData ?? [],
                ),
                MapSample(
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

  Widget _buildShimmerLoading(double height, double width) {
    return Container(
      padding: const EdgeInsets.only(top: 65),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.only(left: 30, right: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: textDefaultColor.withOpacity(0.15),
                        blurRadius: 2,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  height: height * 0.07,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: width * 0.8 - 60,
                        child: Row(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                "assets/search/searchbutton.svg",
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Хайлт",
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: VerticalDivider(),
                      ),
                      Expanded(
                        child: Icon(
                          CupertinoIcons.location,
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Shimmer.fromColors(
            period: const Duration(seconds: 1),
            // ignore: deprecated_member_use
            baseColor: Colors.grey.withOpacity(0.1),
            highlightColor: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                  child: ListView.separated(
                    padding: const EdgeInsets.only(left: 30),
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (_, __) => Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                  ),
                ),
                SizedBox(
                  height: height - 56 - 70 - 174,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: 5,
                    itemBuilder: (_, __) => Container(
                      height: height * 0.45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black,
                      ),
                      child: Column(
                        children: [
                          Container(
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
                          ),
                        ],
                      ),
                    ),
                    separatorBuilder: (_, __) => const SizedBox(height: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
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
          _buildNavItem("Аялах", "assets/navigationbar/search.svg", 0),
          _buildNavItem("Байршил", "assets/navigationbar/lco.svg", 1),
          _buildPngNavItem(
              "Түрээсэлсэн", "assets/navigationbar/icons8-m-key-100.png", 2),
          _buildNavItem("Таалагдсан", "assets/navigationbar/favorite.svg", 3),
          _buildNavItem("Профайл", "assets/navigationbar/profile.svg", 4),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      String label, String assetPath, int index) {
    return BottomNavigationBarItem(
      label: label,
      icon: _buildIcon(assetPath, index),
    );
  }

  BottomNavigationBarItem _buildPngNavItem(
      String label, String assetPath, int index) {
    return BottomNavigationBarItem(
      label: label,
      icon: _buildPngIcon(assetPath, index),
    );
  }

  Widget _buildIcon(String assetPath, int index) {
    return SizedBox(
      height: 30,
      width: 30,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: _currentIndex == index ? 30 : 25,
        width: _currentIndex == index ? 30 : 25,
        child: SvgPicture.asset(
          assetPath,
          fit: BoxFit.contain,
          colorFilter: ColorFilter.mode(
            _currentIndex == index ? mRed : const Color(0xff7D8588),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _buildPngIcon(String assetPath, int index) {
    return SizedBox(
      height: 35,
      width: 35,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: _currentIndex == index ? 35 : 30,
        width: _currentIndex == index ? 35 : 30,
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
          color: _currentIndex == index
              ? mRed
              : const Color.fromARGB(255, 106, 112, 114),
        ),
      ),
    );
  }
}
