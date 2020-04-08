import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/small_card.dart';

class Favorite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: FavoriteScreen(),
      drawerScrimColor: Color(0x00),
    );
  }
}

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  void initState() {
    super.initState();
    inputData();
  }

  String userId;
  List userFavorites = [];
  inputData() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    // DocumentReference userRef =
    //     Firestore.instance.collection('users').document(uid);
    setState(() {
      userId = uid;
    });

    //  Firestore.instance
    //     .collection('users')
    //     .document(userId)
    //     .snapshots()
    //     .listen((data) => {
    //       //     setState(() {
    //       //       userFavorites = data['favorite'];
    //       //     }),
    //       // print(userFavorites),
    //       data['favorite'].forEach((doc) {
    //         print(doc);
    //         print('here');
    //         print(doc['memeId']);
    //         setState(() {
    //         userFavorites.add(doc);

    //         });
    //       })

    //         });
      
    
    
    // here you write the codes to input the data into firestore
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
                  .where('usersHasFavorite', arrayContains: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFFCFB4F1))),
                  );
                  if (snapshot.data.documents.length == 0)
                  return Center(
                    // child: Text('No uploaded image yet, hurry up. Little rascal.', style: kDrawerText),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 30.0),
                      child: Text('No favorites yet. Better take them when you see them !',

                      softWrap: true,
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
                    ),
                    );

                return Container(

                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int i) => SmallCardList(
                        context, snapshot.data.documents[i], storage, 'favorite'),
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
                  colors: [Color(0xFFEEEEEE), Color(0x00FFFFFF)],
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
