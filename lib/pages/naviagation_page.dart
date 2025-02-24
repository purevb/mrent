import 'package:auto_route/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mrent/model/user_model.dart';
import 'package:mrent/pages/favorite_page/favorite_checker.dart';
import 'package:mrent/pages/message_page/message_checker.dart';
import 'package:mrent/pages/profile_page/profile_checker.dart';
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

  Future<void> fetchUserById(String userId) async {
    if (userId.isEmpty) {
      print('Error: userId cannot be empty');
      return;
    }

    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (documentSnapshot.exists) {
        user = User.fromFirestore(documentSnapshot);
        print(
            'User Data: ${user!.name}, ${user!.email}, ${user!.phone}, ${user!.createdAt}');
      } else {
        print('User  not found');
      }
    } catch (e) {
      print('Error fetching user: $e');
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
            FavoriteChecker(
              user: user,
            ),
            RentChecker(
              user: user,
            ),
            MessageChecker(
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
                label: "Таалагдсан",
                icon: _buildIcon("assets/navigationbar/favorite.svg", 1),
              ),
              BottomNavigationBarItem(
                label: "Түрээсэлсэн",
                icon: _buildIcon("assets/navigationbar/trip.svg", 2),
              ),
              BottomNavigationBarItem(
                label: "Зурвас",
                icon: _buildIcon("assets/navigationbar/message.svg", 3),
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
}
