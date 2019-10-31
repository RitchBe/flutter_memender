import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_bar.dart';
import '../components/large_cards.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/small_card.dart';
import 'dart:math';
import 'package:flushbar/flushbar.dart';
import '../components/flushbarsString.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: ProfileScreen(),
      drawerScrimColor: Color(0x00),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    getUserRef();
  }

  DocumentReference userRef;
  String userId;
  getUserRef() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    DocumentReference userRef =
        Firestore.instance.collection('users').document(uid);
    setState(() {
      userId = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseStorage storage = FirebaseStorage(
        app: Firestore.instance.app,
        storageBucket: 'gs://memender-47f82.appspot.com');
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      child: Stack(
        children: <Widget>[
          StreamBuilder(
              stream: Firestore.instance
                  .collection('memes')
                  .where('userId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFCFB4F1))),
                  );
                return Container(
                  height: MediaQuery.of(context).size.height * 1,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int i) => SmallCardList(
                        context,
                        snapshot.data.documents[i],
                        storage,
                        'uploaded'),
                  ),
                );
              }),
          Positioned(
            bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xFFEFE4F7), Color(0x00FFFFFF)],
                ),
              ),
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.05,
            ),
          )
        ],
      ),
    );
  }
}
