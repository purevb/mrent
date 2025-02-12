import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mrent/pages/favorite_page/favorite_page.dart';
import 'package:mrent/pages/message_page/message_page.dart';
import 'package:mrent/pages/profile_page/profile_page.dart';
import 'package:mrent/pages/rent_history_page/rent_history_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          TripPage(),
          FavoritePage(),
          RentHistoryPage(),
          MessagePage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
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
