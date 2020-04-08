import 'package:flutter/material.dart';
import 'package:memender/constants.dart';

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
      _launchURLPolicy(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
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

    return SingleChildScrollView(
      
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 1,
        

            ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          
        children: <Widget>[
            Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 1
                ),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [Color(0xffFF6996), Color(0xFF524A87)])),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0, left: 20.0),
                            child: IconButton(
                              iconSize: 30.0,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                  Icons.arrow_back,
                                 
                                  ),
                              
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        
                        padding: EdgeInsets.only(left: 50.0, right: 50.0),
                        child: Column(
                            
                            children: <Widget>[
                      
                              Text(
                                  'Big thanks to all the memes creators around the world.',
                                  textAlign: TextAlign.center,
                                  style: largerText),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.01,
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
                                    "Hey you ! Liking this app so far? Make a review here!",
                                    textAlign: TextAlign.center,
                                    style: reviewText,
                                    ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.025,
                              ),
                              Text(
                                'Info ?',
                                textAlign: TextAlign.center,
                                style: infoText,
                              ),
                              emailLauncher,
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.01,
                              ),
                              Text(
                                'Have a joke ?',
                                textAlign: TextAlign.center,
                                style: infoText,
                              ),
                              emailLauncher,
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.01,
                              ),
                              Text(
                                'Ideas to change my life ?',
                                textAlign: TextAlign.center,
                                style: infoText,
                              ),
                              emailLauncher,
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.01,
                              ),
                              Text(
                                'Buy the app for one million ?',
                                textAlign: TextAlign.center,
                                style: infoText,
                              ),
                              emailLauncher,
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.01,
                              ),
                              Text(
                                'Anything else ?',
                                textAlign: TextAlign.center,
                                style: infoText,
                              ),
                              emailLauncher,
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.01,
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
                      RawMaterialButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              child: Text('Privacy Policy',
                                  style: infoText
                                  ),
                              onPressed: () {
                                _launchURLPolicy(
                                    'https://www.websitepolicies.com/policies/view/3yAkwiZZ');
                              }),
                          RawMaterialButton(
                              child: Text('Terms and Conditions',
                                  style: infoText),
                              onPressed: () {
                                _launchURLPolicy(
                                    'https://www.websitepolicies.com/policies/view/hPUxad33');
                              })

                    ],
                  ),
                )),
        ],
      ),
          ),
    );
  }
}