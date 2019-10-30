import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:memender/services/sign_in.dart';
import 'package:memender/services/sign_in.dart' as prefix0;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/flutter_svg.dart';


import 'home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email, _password;

  @override
  Widget build(BuildContext context) {
    _launchURL(url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
        body: Container(
            child: Center(
          child: Container(
            width: 300,
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SvgPicture.asset('assets/logoSvg.svg'),
                ),
//                TextField(
//                  decoration: InputDecoration.collapsed(
//                      hintText: "Email", border: UnderlineInputBorder()),
//                  onChanged: (value) {
//                    this.setState(() {
//                      _email = value;
//                    });
//                  },
//                ),
//                TextField(
//                  decoration: InputDecoration.collapsed(
//                      hintText: "Password", border: UnderlineInputBorder()),
//                  onChanged: (value) {
//                    this.setState(() {
//                      _password = value;
//                    });
//                  },
//                ),
//                RaisedButton(
//                  child: Text('Sign in'),
//                  onPressed: () {
//                    FirebaseAuth.instance
//                        .signInWithEmailAndPassword(
//                            email: _email, password: _password)
//                        .then((onValue) {})
//                        .catchError((error) {
//                      debugPrint(error);
//                    });
//                  },
//                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      textBaseline: TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text("By loging in you accept the", style: TextStyle(),),
                        RawMaterialButton(

                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20.0, left: 3.0),
                              child: Text('Privacy Policy', style: TextStyle(decoration: TextDecoration.underline, color: Colors.grey[400])),
                            ),
                            onPressed: () {
                              _launchURL(
                                  'https://www.websitepolicies.com/policies/view/3yAkwiZZ');
                            }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('and the'),
                        RawMaterialButton(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 33.0, left:3.0, right: 3.0),
                              child: Text('Terms and Conditions', style: TextStyle(decoration: TextDecoration.underline, color: Colors.grey[400])),
                            ),
                            onPressed: () {
                              _launchURL(
                                  'https://www.websitepolicies.com/policies/view/hPUxad33');
                            }),
                        Text('of Memender.')
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _signInButtonGoogle(),
                    _signInButtonFacebook(),
                  ],),


              ],
            ),
          ),
        )));
  }

  Widget _signInButtonFacebook() {
    return RawMaterialButton(
      onPressed: () {
        signInWithFacebook().whenComplete(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return Home();
              },
            ),
          );
        });
      },
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/facebook_logo.png"), height: 25.0),
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Text(
                'Facebook Sign In',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _signInButtonGoogle() {
    return RawMaterialButton(
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
//      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 15.0),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                'Google Sign In',
                style: TextStyle(
                  fontSize: 15,
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
