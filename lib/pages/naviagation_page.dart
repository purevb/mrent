import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mrent/model/user_model.dart';
import 'package:mrent/pages/favorite_page/favorite_checker.dart';
import 'package:mrent/pages/profile_page/profile_checker.dart';
import 'package:mrent/pages/property_detail_page/components/google_maps.dart';
import 'package:mrent/pages/rent_history_page/rent_checker.dart';
import 'package:mrent/pages/trip_page/trip_page.dart';
import 'package:mrent/utils/constants.dart';

@RoutePage()
class NavigationPage extends StatefulWidget {
  const NavigationPage({this.id, super.key});
  final String? id;

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;
  User? user;
  @override
  void initState() {
    super.initState();
    fetchUserById(widget.id ?? "");
  }

  Future<void> fetchUserById(String? userId) async {
    if (userId!.isEmpty) {
      log('Nevtreegu bn');
      return;
    }

    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (documentSnapshot.exists) {
        user = User.fromFirestore(documentSnapshot);
        log('User Data: ${user!.name}, ${user!.email}, ${user!.phone}, ${user!.createdAt}');
      } else {
        log('User  not found');
      }
    } catch (e) {
      log('Error fetching user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            TripPage(
              user: user,
            ),
            const MapSample(
              hasAppBar: true,
            ),
            RentChecker(
              user: user,
            ),
            FavoriteChecker(
              user: user,
            ),
            ProfileChecker(
              user: user,
            ),
          ],
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
