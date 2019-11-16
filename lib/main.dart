import 'package:flutter/material.dart';
import 'package:memender/constants.dart';
import 'package:memender/screens/profile.dart';
import 'package:memender/screens/top_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home.dart';
import 'screens/info.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {

  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,



    
    title: 'FlutterFire App',
    routes: <String, WidgetBuilder>{
      '/': (BuildContext context) => _handleWindowDisplay(),
      '/profile': (BuildContext context) => Profile(),
      '/top': (BuildContext context) => TopScreen(),
      '/info': (BuildContext context) => Info(),

    }
  ));
}

Widget _handleWindowDisplay() {
  //Check if user is logged in or not
  return Container(
    height: 500.0,
    width: 500.0,
    color: kBackgroundColor,
    child: StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFCFB4F1))));
        } else {
          if (snapshot.hasData) {
            return Home();
          } else {
            return LoginScreen();
          }
        }
      },
      
    ),
  );
}
