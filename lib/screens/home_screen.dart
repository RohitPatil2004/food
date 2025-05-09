import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../services/theme_service.dart';
import 'restaurant_search_screen.dart';
import 'ingredient_selection_screen.dart';
import 'settings_screen.dart';
import 'bookmark_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const RestaurantSearchScreen(),
    const IngredientSelectionScreen(),
    const BookmarkScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.deepOrange,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.blue, // Change this to your desired color
        unselectedItemColor: Colors.grey, // Change this to your desired color
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Restaurants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Ingredients',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

// const List<Widget> _screens = [
//   RestaurantSearchScreen(),
//   IngredientSelectionScreen(),
//   SettingsScreen(),
// ];
