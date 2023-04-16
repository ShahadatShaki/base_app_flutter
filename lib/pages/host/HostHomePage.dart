import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/pages/UserProfilePage.dart';
import 'package:base_app_flutter/pages/guest/home/ExplorePage.dart';
import 'package:base_app_flutter/pages/guest/home/InboxPage.dart';
import 'package:base_app_flutter/pages/guest/home/MyBookings.dart';
import 'package:base_app_flutter/pages/guest/home/NotificationPage.dart';
import 'package:base_app_flutter/pages/host/home/HostCalenderPage.dart';
import 'package:base_app_flutter/pages/host/home/MyReservation.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:flutter/material.dart';

class HostHomePage extends StatefulWidget {
  const HostHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HostHomePage> createState() => _HostHomePageState();
}

class _HostHomePageState extends State<HostHomePage> {
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
                    name: AssetsName.calender,
                    color: _selectedIndex == 0
                        ? AppColors.appColor
                        : AppColors.darkGray)),
            label: 'Reservation',
          ),
          BottomNavigationBarItem(
            icon: Container(
                margin: EdgeInsets.only(bottom: 4),
                child: Component.showIcon(
                    name: AssetsName.message,
                    color: _selectedIndex == 1
                        ? AppColors.appColor
                        : AppColors.darkGray)),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Container(
                margin: EdgeInsets.only(bottom: 4),
                child: Component.showIcon(
                    name: AssetsName.bookings,
                    color: _selectedIndex == 2
                        ? AppColors.appColor
                        : AppColors.darkGray)),
            label: 'Listing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Calender',
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
    MyReservation(),
    InboxPage(),
    MyBookings(),
    HostCalenderPage(),
    UserProfilePage()
  ];
}
