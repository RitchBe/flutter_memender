import 'package:flutter/material.dart';
import 'package:memender/screens/favorite.dart';
import '../screens/profile.dart';
import '../screens/favorite.dart';
import 'package:memender/constants.dart';

class NestedTabBar extends StatefulWidget {
  @override
  _NestedTabBarState createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  TabController _nestedTabController;

  @override
  void initState() {
    super.initState();
    _nestedTabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TabBar(
          controller: _nestedTabController,
          indicatorColor: kHighlightColor,
          labelColor: kHighlightColor,
          unselectedLabelColor: Colors.black54,
          isScrollable: true,
          tabs: <Widget>[
            Tab(
              text: "Upload",
            ),
            Tab(
              text: "Favorite",
            ),
          ],
        ),
        Expanded(
                  child: Container(
            
            
            height: screenHeight * 0.73,
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _nestedTabController,
              children: <Widget>[
                Container(child: Profile()), //ListView
                Container(child: Favorite()), //ListView
              ],
            ),
          ),
        )
      ],
    );
  }
}
