import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:memender/services/sign_in.dart';

import 'home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login Screen'),
        ),
        body: Container(
            child: Center(
          child: Container(
            width: 300,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration.collapsed(
                      hintText: "Email", border: UnderlineInputBorder()),
                  onChanged: (value) {
                    this.setState(() {
                      _email = value;
                    });
                
                  },
                ),
                TextField(
                  decoration: InputDecoration.collapsed(
                      hintText: "Password", border: UnderlineInputBorder()),
                  onChanged: (value) {
                    this.setState(() {
                      _password = value;
                    });
              
                  },
                ),
                RaisedButton(
                  child: Text('Sign in'),
                  onPressed: () {
                    FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password).then((onValue) {
                      
                    }).catchError((error) {
                      debugPrint(error);
                    });
                  },
                ),

                _signInButtonGoogle(),
              ],
            ),
          ),
        )));
  }


Widget _signInButtonGoogle() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
 signInWithGoogle().whenComplete(() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return Home();
          },
        ),
      );
    });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}