import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: RaisedButton(
          child: Text('Log out'),
      onPressed: () {
        FirebaseAuth.instance.signOut().then((value) {
            Navigator.of(context).pop();
        });
      },
    ));
  }
}
