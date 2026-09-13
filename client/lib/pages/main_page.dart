import 'dart:convert';

import 'package:client/pages/category.dart';
import 'package:client/pages/home.dart';
import 'package:client/pages/profile.dart';
import 'package:client/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int currentPageIndex = 0;

  late List pages = [HomePage(), SearchPage(), CategoryPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Schologg",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight(600)),
        ),
        backgroundColor: Colors.deepPurple[300],
      ),
      body: pages[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.deepPurple[400],
        selectedIndex: currentPageIndex,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Colors.white),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search, color: Colors.white),
            label: "Search",
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view),
            selectedIcon: Icon(Icons.grid_view_rounded, color: Colors.white),
            label: "Category",
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            selectedIcon: Icon(Icons.person, color: Colors.white),
            label: "Profile",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.mode_edit_outline),
      ),
    );
  }
}
