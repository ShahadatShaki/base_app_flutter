import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/pages/UserProfilePage.dart';
import 'package:base_app_flutter/pages/guest/home/InboxPage.dart';
import 'package:base_app_flutter/pages/guest/home/MyBookings.dart';
import 'package:base_app_flutter/pages/guest/home/NotificationPage.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:flutter/material.dart';

import 'home/ExplorePage.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Container(
                margin: EdgeInsets.only(bottom: 4),
                child: Component.showIcon(
                    name: AssetsName.search,
                    color: _selectedIndex == 0
                        ? AppColors.appColor
                        : AppColors.darkGray)),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Container(
                margin: EdgeInsets.only(bottom: 4),
                child: Component.showIcon(
                    name: AssetsName.bookings,
                    color: _selectedIndex == 1
                        ? AppColors.appColor
                        : AppColors.darkGray)),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Container(
                margin: EdgeInsets.only(bottom: 4),
                child: Component.showIcon(
                    name: AssetsName.message,
                    color: _selectedIndex == 2
                        ? AppColors.appColor
                        : AppColors.darkGray)),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Container(
                margin: EdgeInsets.only(bottom: 4),
                child: Component.showIcon(
                    name: AssetsName.guest,
                    color: _selectedIndex == 4
                        ? AppColors.appColor
                        : AppColors.darkGray)),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.black87,
        unselectedFontSize: 12,
        selectedFontSize: 12,
        showUnselectedLabels: true,
        selectedItemColor: AppColors.appColor,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static final List<Widget> _widgetOptions = <Widget>[
    ExplorePage(),
    MyBookings(),
    InboxPage(),
    NotificationPage(),
    UserProfilePage()
  ];
}