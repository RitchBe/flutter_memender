import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(new MaterialApp(
    title: 'FlutterFire App',
    home: _handleWindowDisplay(),
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
          return MainScreen();
        } else {
          return LoginScreen();
        }
      }
    },
    
  );
}
