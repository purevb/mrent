import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:mrent/pages/explore_page.dart';
import 'package:mrent/pages/favorite_page.dart';
import 'package:mrent/pages/profile_page.dart';
import 'home_page.dart';

@RoutePage()
class NavigationPage extends StatefulWidget {
  const NavigationPage({required this.id, super.key});
  final String id;

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const MyHomePage(),
          const ExplorePage(),
          const FavoritePage(),
          ProfilePage(id: widget.id),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: const Color(0xff7D8588),
        selectedItemColor: const Color(0xff6246EA),
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
