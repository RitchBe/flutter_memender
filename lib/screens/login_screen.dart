import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:memender/constants.dart';
import 'package:memender/services/sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'home.dart';

class MyGlobals {
  GlobalKey _scaffoldKey;
  MyGlobals() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey;
}

MyGlobals myGlobals = new MyGlobals();

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  String _email, _password;

  Future<FirebaseUser> handleLogInEmail(String email, String password) async {
    AuthResult result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    final FirebaseUser user = result.user;
    assert(user != null);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await auth.currentUser();
    assert(user.uid == currentUser.uid);

    print('signInEmail succeeded');
  }

  Future<FirebaseUser> handleSignInEmail(String email, String password) async {
    AuthResult result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final FirebaseUser user = result.user;
    assert(user != null);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await auth.currentUser();
    assert(user.uid == currentUser.uid);

    print('signInEmail succeeded');
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _onAlertLoginPressed() {
    String localEmail = '';
    String localPassword = '';
    showDialog(
        context: context,
        builder: (dialogContex) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                  height: 270.0,
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: TextField(
                            style: TextStyle(
                                fontFamily: 'Lato', color: kHighlightColor),
                            autocorrect: false,
                            decoration: InputDecoration(
                                focusColor: Colors.pink,
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400])),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kHighlightColor, width: 2.0)),
                                border: UnderlineInputBorder()),
                            onChanged: (value) {
                              localEmail = value;
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: TextField(
                            style: TextStyle(
                                fontFamily: 'Lato', color: kHighlightColor),
                            autocorrect: false,
                            obscureText: true,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey[400])),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kHighlightColor, width: 2.0)),
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: UnderlineInputBorder()),
                            onChanged: (value) {
                              localPassword = value;
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          textBaseline: TextBaseline.alphabetic,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "By signing in, you accept the",
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                            RawMaterialButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, left: 3.0),
                                  child: Text('Privacy Policy',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.grey[400])),
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
                            Text('and the',
                                style: TextStyle(color: Colors.grey[400])),
                            RawMaterialButton(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 33.0, left: 3.0, right: 3.0),
                                  child: Text('Terms and Conditions',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.grey[400])),
                                ),
                                onPressed: () {
                                  _launchURL(
                                      'https://www.websitepolicies.com/policies/view/hPUxad33');
                                }),
                            Text('of Memender.',
                                style: TextStyle(color: Colors.grey[400]))
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding:
                                    EdgeInsets.only(left: 10.0, right: 10.0),
                                height: 37.0,
                                margin: EdgeInsets.only(right: 15.0),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[400],
                                        blurRadius: 1.0,
                                        offset: Offset(1, 1))
                                  ],
                                  borderRadius: BorderRadius.circular(40),
                                  gradient: LinearGradient(colors: <Color>[
                                    Color(0xffFF6996),
                                    Color(0xff524A87)
                                  ]),

                                  // color: Color(0xffFF6996)
                                ),
                                child: RawMaterialButton(
                                  child: Text(
                                    'Create account',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    handleSignInEmail(localEmail, localPassword)
                                        .whenComplete(() => {
                                              FirebaseAuth.instance
                                                  .currentUser()
                                                  .then((firebaseUser) {
                                                if (firebaseUser != null) {
                                                  Navigator.pop(dialogContex);
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return Home();
                                                      },
                                                    ),
                                                  );
                                                }
                                              })
                                            });
                                  },
                                ),
                              ),
                              RawMaterialButton(
                                fillColor: kWhite,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                child: Text('Log in',
                                    style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  handleLogInEmail(localEmail, localPassword)
                                      .whenComplete(() => {
                                            FirebaseAuth.instance
                                                .currentUser()
                                                .then((firebaseUser) {
                                              if (firebaseUser != null) {
                                                Navigator.pop(dialogContex);
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return Home();
                                                    },
                                                  ),
                                                );
                                              }
                                            })
                                          });
                                },
                              ),
                            ],
                          ),
                        )
                      ])));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: myGlobals.scaffoldKey,
        body: Stack(
          children: <Widget>[
            Container(
                child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 18.0, left: 8.0, right: 8.0),
                          child: SvgPicture.asset('assets/logoSvg.svg'),
                        ),
                        Text('One click away from the meme paradise',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                foreground: Paint()
                                  ..shader = LinearGradient(
                                    colors: <Color>[
                                      Color(0xffFF6996),
                                      Color(0xff524A87)
                                    ],
                                  ).createShader(
                                      Rect.fromLTWH(0.0, 0.0, 300.0, 7.0)),
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lato')),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 50.0),
                      child: Column(
                        children: <Widget>[
                          _signInButtonGoogle(),
                          SizedBox(
                            height: 15.0,
                          ),
                          _signInButtonFacebook(),
                          SizedBox(
                            height: 15.0,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            height: MediaQuery.of(context).size.height * 0.075,
                            child: RawMaterialButton(
                              splashColor: Colors.grey,
                              fillColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              highlightElevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    5, 17.5, 32, 17.5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.email,
                                      size: 25.0,
                                      color: Color(0xff524A87),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text('Email sign in',
                                          style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 20,
                                              color: Colors.grey)),
                                    ),
                                  ],
                                ),
                              ),
                              onPressed: () {
                                _onAlertLoginPressed();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
            Positioned(
              bottom: 4.0,
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    textBaseline: TextBaseline.alphabetic,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "By signing in, you accept the",
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      RawMaterialButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, left: 3.0),
                            child: Text('Privacy Policy',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.grey[400])),
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
                      Text('and the',
                          style: TextStyle(color: Colors.grey[400])),
                      RawMaterialButton(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 33.0, left: 3.0, right: 3.0),
                            child: Text('Terms and Conditions',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.grey[400])),
                          ),
                          onPressed: () {
                            _launchURL(
                                'https://www.websitepolicies.com/policies/view/hPUxad33');
                          }),
                      Text('of Memender.',
                          style: TextStyle(color: Colors.grey[400]))
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Widget _signInButtonFacebook() {
    return RawMaterialButton(
      onPressed: () {
        signInWithFacebook().whenComplete(() {
          FirebaseAuth.instance.currentUser().then((firebaseUser) {
            if (firebaseUser != null) {
              print("Is it me ???");
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Home();
                  },
                ),
              );
            }
          });
        });
      },
      fillColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.075,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                  image: AssetImage("assets/facebook_logo.png"), height: 40.0),
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Text(
                  'Facebook sign in',
                  style: TextStyle(
                      fontSize: 20, color: Colors.grey, fontFamily: 'Lato'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButtonGoogle() {
    return RawMaterialButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().whenComplete(() {
          FirebaseAuth.instance.currentUser().then((firebaseUser) {
            if (firebaseUser != null) {
              print("Is it me ???");
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Home();
                  },
                ),
              );
            }
          });
        });
      },
      fillColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.075,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 17, 32, 17),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(image: AssetImage("assets/google_logo.png"), height: 25.0),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  'Google Sign In',
                  style: TextStyle(
                    fontFamily: 'Lato',
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
