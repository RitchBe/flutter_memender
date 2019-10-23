import 'package:flutter/material.dart';

import '../constants.dart';

import '../screens/home.dart';
import '../screens/profile.dart';
import 'large_cards.dart';
import 'nestedTabBarView.dart';

class CustomBottomBar extends StatefulWidget {
  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    CardSwiper(),
    NestedTabBar(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: kHighlightColor),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity, color: kHighlightColor),
            title: Text("Profile"),
          ),
        ]);
  }

  void getElement() {
    _widgetOptions.elementAt(_selectedIndex);
  }
}
