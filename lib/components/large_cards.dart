import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:memender/components/data.dart';
import 'package:memender/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memender/services/sign_in.dart';
import 'package:share/share.dart';



class CardSwiper extends StatefulWidget {
  @override
  _CardSwiperState createState() => _CardSwiperState();
}

class _CardSwiperState extends State<CardSwiper> {
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
          await tx.update(postRef, <String, dynamic>{
            'downvote': postSnapshot.data['downvote'] + 1,
            'total': postSnapshot.data['total'] + 1
          });
        }
      });
    } else {
      Firestore.instance.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        if (postSnapshot.exists) {
          await tx.update(postRef, <String, dynamic>{
            'upvote': postSnapshot.data['upvote'] + 1,
            'total': postSnapshot.data['total'] + 1
          });
        }
      });
    }
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
                  child: Text('Loading'),
                );
              return TinderSwapCard(
                  orientation: AmassOrientation.BOTTOM,
                  totalNum: snapshot.data.documents.length,
                  stackNum: 6,
                  swipeEdge: 0.8,
                  maxWidth: MediaQuery.of(context).size.width * 0.98,
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  minHeight: MediaQuery.of(context).size.height * 0.6,
                  cardBuilder: (context, index) => Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                RawMaterialButton(
                                  child: Icon(
                                    Icons.bookmark_border,
                                    color: kHighlightColor,
                                  ),
                                ),
                              ],
                            ),
                            snapshot.data.documents.first != null
                                ? Image.network(
                                    snapshot.data.documents[index]['url'])
                                : Text('Loading..'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
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
                                            '${snapshot.data.documents[index]['name']}%',
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
                                        child: Text('kk',
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
                                        color: Colors.pink,
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    Share.share(snapshot.data.documents[index]['url']);
                                  },
                                )
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
                  });
            })
      ],
    );
  }
}
