import 'package:base_app_flutter/pages/LoginPage.dart';
import 'package:flutter/material.dart';

import 'ListItemPage.dart';


class BottomNavPage extends StatefulWidget {

  const BottomNavPage({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNavPage> createState() => _BottomNavPageState();
}

class _BottomNavPageState extends State<BottomNavPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // NavigationBar Example
      bottomNavigationBar: NavigationBar(
        animationDuration: const Duration(milliseconds: 1000),
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        //backgroundColor: Colors.blue,
        //elevation: 10,
        //surfaceTintColor: Colors.lime,
        //height: 20,
        //labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
      body: <Widget>[
        ListItemPage(),
        LoginPage(),
        ListItemPage(),
        LoginPage(),
        ListItemPage()
      ][currentPageIndex],
    );
  }
}
