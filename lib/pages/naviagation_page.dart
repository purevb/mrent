import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/fb_user_model.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/pages/favorite_page/favorite_checker.dart';
import 'package:mrent/pages/profile_page/profile_checker.dart';
import 'package:mrent/pages/property_detail_page/components/google_maps.dart';
import 'package:mrent/pages/rent_history_page/rent_checker.dart';
import 'package:mrent/pages/trip_page/trip_page.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/utils/constants.dart';
import 'package:provider/provider.dart';

@RoutePage()
class NavigationPage extends StatefulWidget {
  const NavigationPage({this.id, super.key});
  final String? id;

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _dataArrived = false;
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
      // Load properties first
      await _dataController.getPropertiesData();

      // Then load user if ID exists
      if (widget.id != null && widget.id!.isNotEmpty) {
        await _loadUserData(widget.id!);
      }

      setState(() {
        _dataArrived = true;
        _isLoading = false;
      });
    } catch (e) {
      log('Initialization error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUserData(String userId) async {
    try {
      final document = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (document.exists) {
        final fbUser = FbUserModel.fromFirestore(document);
        final mongoUser = await _api.getMongoUser(userId);

        if (mounted) {
          final provider =
              Provider.of<PropertyProvider>(context, listen: false);
          provider.authenticatedUser(mongoUser);

          setState(() {
            _mongoUser = mongoUser;
          });
        }
      }
    } catch (e) {
      log('Error loading user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: ValueListenableBuilder(
          builder: (context, propertyData, child) {
            return IndexedStack(
              index: _currentIndex,
              children: [
                TripPage(
                  getData: _dataArrived,
                  propertyDatas: propertyData ?? [],
                ),
                MapSample(
                  propertyData: propertyData ?? [],
                  hasFloatButton: false,
                  hasAppBar: true,
                ),
                RentChecker(
                  user: _mongoUser,
                ),
                FavoriteChecker(
                  user: _mongoUser,
                ),
                ProfileChecker(
                  user: _mongoUser,
                ),
              ],
            );
          },
          valueListenable: _dataController.propertyDataNotifier,
        ),
        bottomNavigationBar: Theme(
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
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                label: "Аялах",
                icon: _buildIcon("assets/navigationbar/search.svg", 0),
              ),
              BottomNavigationBarItem(
                label: "Байршил",
                icon: _buildIcon("assets/navigationbar/lco.svg", 1),
              ),
              BottomNavigationBarItem(
                label: "Түрээсэлсэн",
                icon: _buildPngIcon(
                    "assets/navigationbar/icons8-m-key-100.png", 2),
              ),
              BottomNavigationBarItem(
                label: "Таалагдсан",
                icon: _buildIcon("assets/navigationbar/favorite.svg", 3),
              ),
              BottomNavigationBarItem(
                label: "Профайл",
                icon: _buildIcon("assets/navigationbar/profile.svg", 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(String assetPath, int index) {
    return SizedBox(
      height: 30,
      width: 30,
      child: Center(
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
      ),
    );
  }

  Widget _buildPngIcon(String assetPath, int index) {
    return SizedBox(
      height: 35,
      width: 35,
      child: Center(
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
      ),
    );
  }
}
