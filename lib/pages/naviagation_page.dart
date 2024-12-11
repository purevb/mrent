import 'package:flutter/material.dart';
import 'package:mrent/pages/explore_page.dart';
import 'package:mrent/pages/favorite_page.dart';
import 'package:mrent/pages/profile_page.dart';
import 'home_page.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({this.id, super.key});
  final String? id;
  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  final screens = [
    const MyHomePage(),
    const ExplorePage(),
    const FavoritePage(),
    const ProfilePage(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index:
            _currentIndex, // Use _currentIndex to display the selected screen
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type:
            BottomNavigationBarType.fixed, // Use fixed type to prevent zooming
        unselectedItemColor: Color(0xff7D8588),
        selectedItemColor: Color(0xff6246EA),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            label: "Нүүр",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "Explore",
            icon: Icon(Icons.explore),
          ),
          BottomNavigationBarItem(
            label: "Таалагдсан",
            icon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: "Профайл",
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
