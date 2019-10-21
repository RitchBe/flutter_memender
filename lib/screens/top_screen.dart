import 'package:flutter/material.dart';
import '../constants.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_bar.dart';
import '../components/large_cards.dart';

class TopScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: ProfileScreen(),
      drawerScrimColor: Color(0x00),
    );
  }
}

class ProfileScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35.0, left: 10.0),
      child: Container(
        child: Column
        (children: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
            color: kHighlightColor,
            
          ),
        ],),
      ),
    );
  }
}
