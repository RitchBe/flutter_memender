import 'package:flutter/material.dart';
import '../constants.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_bar.dart';
import '../components/large_cards.dart';

class Profile extends StatelessWidget {
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
    return Center(
      child: Container(
        child: Text("What up"),
      ),
    );
  }
}
