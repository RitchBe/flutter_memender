import 'package:flutter/material.dart';
import 'package:memender/screens/profile.dart';
import 'package:memender/screens/top_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(new MaterialApp(
    title: 'FlutterFire App',
    routes: <String, WidgetBuilder>{
      '/': (BuildContext context) => _handleWindowDisplay(),
      '/profile': (BuildContext context) => Profile(),
      '/top': (BuildContext context) => TopScreen(),

    }
  ));
}

Widget _handleWindowDisplay() {
  //Check if user is logged in or not
  return StreamBuilder(
    stream: FirebaseAuth.instance.onAuthStateChanged,
    builder: (BuildContext context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: Text("Loading"));
      } else {
        if (snapshot.hasData) {
          return Home();
        } else {
          return LoginScreen();
        }
      }
    },
    
  );
}
