import 'package:flutter/material.dart';

import '../services/sign_in.dart';

import 'login_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:launch_review/launch_review.dart'; 


TextStyle infoText =
    TextStyle(fontFamily: 'Lato', color: Colors.white, fontSize: 15.0);
TextStyle largerText = TextStyle(
    
    fontFamily: 'Lato',
    // fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize: 20.0);

TextStyle reviewText = TextStyle(
    fontFamily: 'Lato',
    // fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline);
TextStyle mailText = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize: 15.0);

class Info extends StatelessWidget {
  const Info({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: InfoContent(),
        drawerScrimColor: Color(0x00));
  }
}

class InfoContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _launchURL() async {
      if (await canLaunch('mailto:info@memender.io')) {
        await launch('mailto:info@memender.io');
      } else {
        throw 'Could not launch email';
      }
    }

    Container emailLauncher = Container(
        height: 25.0,
        child: RawMaterialButton(
          child: Text(
            'info@memender.io',
            style: mailText,
          ),
          onPressed: () {
            _launchURL();
          },
        ));

    return Container(
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Color(0xFFFF6996), Color(0xFF524A87)])),
        child: Container(
          padding: EdgeInsets.only(top: 35.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                    color: Colors.white,
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                padding: EdgeInsets.only(left: 50.0, right: 50.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                          'I made Memender from scratch with my tiny little hands',
                          textAlign: TextAlign.center,
                          style: largerText),
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                          'Big thanks to all the memes creators I took the images from.',
                          textAlign: TextAlign.center,
                          style: largerText),
                      SizedBox(
                        height: 15.0,
                      ),
                      // Text(
                      //     "If you like it please let me a review!",
                      //     textAlign: TextAlign.center,
                      //     style: reviewText),
                      RawMaterialButton(
                          onPressed: () {
                            LaunchReview.launch();
                          },
                          child: Text(
                            "Hey you ! Liking this app so far? Make a review here!!",
                            textAlign: TextAlign.center,
                            style: reviewText,
                            ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        'Info ?',
                        textAlign: TextAlign.center,
                        style: infoText,
                      ),
                      emailLauncher,
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'Have a joke ?',
                        textAlign: TextAlign.center,
                        style: infoText,
                      ),
                      emailLauncher,
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'Ideas to change my life ?',
                        textAlign: TextAlign.center,
                        style: infoText,
                      ),
                      emailLauncher,
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'Buy the app for one million ?',
                        textAlign: TextAlign.center,
                        style: infoText,
                      ),
                      emailLauncher,
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'Anything else ?',
                        textAlign: TextAlign.center,
                        style: infoText,
                      ),
                      emailLauncher,
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'Offended ?',
                        textAlign: TextAlign.center,
                        style: infoText,
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Text(
                        '🐈',
                        style: TextStyle(fontSize: 25.0),
                      )
                    ]),
              ),
              Center(
                child: RawMaterialButton(
                  child: Text(
                    'Log out',
                    style: infoText,
                  ),
                  onPressed: () {
                    handleSignOut();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) {
                      return LoginScreen();
                    }), ModalRoute.withName('/'));
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
