import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:memender/components/data.dart';
import 'package:memender/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memender/services/sign_in.dart';
import 'package:share/share.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CardSwiper extends StatefulWidget {
  @override
  _CardSwiperState createState() => _CardSwiperState();
}

class _CardSwiperState extends State<CardSwiper> {
  Icon bookmark = Icon(
    Icons.bookmark_border,
    color: kHighlightColor,
  );
  int testi = 0;
  void initState() {
    super.initState();
    getUserRef();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  String userId;

  getUserRef() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    DocumentReference userRef =
        Firestore.instance.collection('users').document(uid);
    setState(() {
      userId = user.uid;
    });
    print('HERE IS THE USER REf');
    print(user.uid);
    // here you write the codes to input the data into firestore
  }

  List<String> urls = [];

  voting(orientation, doc) async {
    String memeToVote = '';
    DocumentReference postRef = null;
    Firestore.instance
        .collection('memes')
        .where('name', isEqualTo: doc['name'])
        .snapshots()
        .listen((data) => {
              memeToVote = doc['memeId'],
              postRef =
                  Firestore.instance.collection('memes').document(memeToVote)
            });

    if (orientation == CardSwipeOrientation.LEFT) {
      Firestore.instance.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        if (postSnapshot.exists) {
          await tx.update(postRef, {
            'downvote': postSnapshot.data['downvote'] + 1,
            'total': postSnapshot.data['total'] + 1,
            'usersHasSeen': FieldValue.arrayUnion([userId]),
          });
        }
      });
    } else {
      Firestore.instance.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        if (postSnapshot.exists) {
          await tx.update(postRef, <String, dynamic>{
            'upvote': postSnapshot.data['upvote'] + 1,
            'total': postSnapshot.data['total'] + 1,
            'usersHasSeen': FieldValue.arrayUnion([userId])
          });
        }
      });
    }
        setState(() {
      bookmark = Icon(
    Icons.bookmark_border,
    color: kHighlightColor,
  );
    });

    // var list = List();
    // list.add('test');
    //  await postRef.updateData({"usersHasSeen": FieldValue.arrayUnion(list)});
  }

  saveMeme(document) async {
    try {
      var imageId = await ImageDownloader.downloadImage(document['url']);
      if (imageId == null) {
        return;
      }
    } on PlatformException catch (error) {
      print(error);
    }

    Firestore.instance
        .collection('memes')
        .document(document['memeId'])
        .updateData({
      'usersHasFavorite': FieldValue.arrayUnion([userId])
    });

    setState(() {
      bookmark = Icon(
    Icons.bookmark,
    color: kHighlightColor,
  );
    });

    Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Meme saved 🖼️",
        message: "..somewhere in your gallery 🔮️ ",
        duration: Duration(seconds: 4),
        backgroundGradient:
            LinearGradient(colors: [Color(0xFFFF6996), Color(0xFF524A87)]))
      ..show(context);
  }

  @override
  Widget build(BuildContext context) {
    CardController controller;
    return Stack(
      children: <Widget>[
        StreamBuilder(
            stream: Firestore.instance.collection('memes').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFCFB4F1))),
                );

              //   snapshot.data.documents[0]['usersHasSeen'].contains('users/ypFPQsrTAEUrAT1Xih9Ob1LkC8z1') ?
              //   snapshot.data.documents.remove(snapshot.data.documents[0])
              //  : print('I dont'),

              // snapshot.data.documents.removeWhere(['usersHasSeen'].contains('users/ypFPQsrTAEUrAT1Xih9Ob1LkC8z1') == true);
              // for (int i = 0; i < snapshot.data.documents.length - 1; i++) {
              //   snapshot.data.documents[i]['usersHasSeen']
              //           .contains(userId)
              //       ? snapshot.data.documents.remove(snapshot.data.documents[i])
              //       : print('I dont');
              // }

                    final List<DocumentSnapshot> documents = snapshot.data.documents.removeWhere(['usersHasSeen'].contains('users/ypFPQsrTAEUrAT1Xih9Ob1LkC8z1') == true);



              return Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.03),
                child: TinderSwapCard(
                    animDuration: 800,
                    orientation: AmassOrientation.BOTTOM,
                    totalNum: snapshot.data.documents.length,
                    stackNum: 5,
                    swipeEdge: 5,
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                    minWidth: MediaQuery.of(context).size.width * 0.89,
                    minHeight: MediaQuery.of(context).size.height * 0.69,
                    cardBuilder: (context, index) => Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  RawMaterialButton(
                                      onPressed: () {
                                        print('you my frind will be saved');
                                        saveMeme(
                                            snapshot.data.documents[index]);
                                      },
                                      child: bookmark),
                                ],
                              ),
                              Expanded(
                                child: snapshot.data.documents.first != null
                                    ? Image.network(
                                        snapshot.data.documents[index]['url'])
                                    : CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(0xFFCFB4F1))),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  RawMaterialButton(
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 8.0),
                                          child: Icon(
                                            Icons.thumb_down,
                                            color: kBlue,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              snapshot.data.documents[index]
                                                          ['downvote'] >
                                                      0
                                                  ? '${((snapshot.data.documents[index]['downvote'] / snapshot.data.documents[index]['total']) * 100).round()}%'
                                                  : '0%',
                                              style: TextStyle(
                                                color: kHighlightColor,
                                                fontFamily: 'Lato',
                                              )),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      controller.triggerLeft();
                                    },
                                  ),
                                  RawMaterialButton(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.share,
                                          color: Color(0xFFF9C9BA),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      Share.share(snapshot.data.documents[index]
                                          ['url']);
                                    },
                                  ),
                                  RawMaterialButton(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.favorite,
                                          color: kPink,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                              snapshot.data.documents[index]
                                                          ['upvote'] >
                                                      0
                                                  ? '${((snapshot.data.documents[index]['upvote'] / snapshot.data.documents[index]['total']) * 100).round()}%'
                                                  : '0%',
                                              style: TextStyle(
                                                  color: kHighlightColor,
                                                  fontFamily: 'Lato')),
                                        )
                                      ],
                                    ),
                                    onPressed: () {
                                      controller.triggerRight();
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                    cardController: controller = CardController(),
                    swipeUpdateCallback:
                        (DragUpdateDetails details, Alignment align) {
                      /// Get swiping card's alignment
                      if (align.x < 0) {
                        //Card is LEFT swipin

                      } else if (align.x > 0) {
                        //Card is RIGHT swiping

                      }
                    },
                    swipeCompleteCallback:
                        (CardSwipeOrientation orientation, int index) {
                      /// Get orientation & index of swiped card!
                      // memeCounter--;
                      // checkIfMoreMeme(index);
                      voting(orientation, snapshot.data.documents[index]);
                    }),
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
    );
  }
}
