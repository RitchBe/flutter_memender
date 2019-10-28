import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_screen.dart';

class Info extends StatelessWidget {
  const Info({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: InfoContent(),
      drawerScrimColor: Color(0x00),
      // appBar: AppBar(
      //   elevation: 0,
      //   leading: IconButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     icon: Icon(Icons.arrow_back),
      //     color: kHighlightColor,
      //   ),
      //   actions: <Widget>[
      //     Center(
      //       child: Padding(
      //         padding: const EdgeInsets.only(right: 15.0),
      //         child: Text(
      //           'Info',
      //           style: TextStyle(
      //               color: kHighlightColor, fontWeight: FontWeight.bold),
      //         ),
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}

class InfoContent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 1,
        width: MediaQuery.of(context).size.width * 1,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Color(0xFFFF6996), Color(0xFF524A87)])),
        child: Center(
          child: RawMaterialButton(
            child: Text('Log out'),
            onPressed: (){
              handleSignOut();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {return LoginScreen();}), ModalRoute.withName('/'));
            },
          ),
        )
        );
  }
}
