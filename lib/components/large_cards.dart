import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:memender/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:math';

class CardSwiper extends StatefulWidget {
  @override
  _CardSwiperState createState() => _CardSwiperState();
}

class _CardSwiperState extends State<CardSwiper> with TickerProviderStateMixin {
  List<String> memesDocument = [];
  List<int> upvote = [];
  List<int> downvote = [];
  List<int> total= [];
  List<Uint8List> memeBytes = [];
  String url = 'NOT';
  int memeCounter = 0;

  final FirebaseStorage storage = FirebaseStorage(
    app: Firestore.instance.app,
    storageBucket: 'gs://memender-47f82.appspot.com' );

    Uint8List imageBytes;
    String errorMsg;

 getMemeNameAndRandom() async {
   Firestore.instance
      .collection('memes').snapshots().listen((data) => {
        data.documents.shuffle(),
        data.documents.take(1),
        data.documents.take(5).forEach((doc) => {
          memesDocument.add(doc['name']),
          upvote.add(doc['upvote']),
          downvote.add(doc['downvote']),
          total.add(doc['total']),
          print(upvote),
          getMemeFromStorage(doc['name'])  
        })
        });
}

getMemeFromStorage(memeName) async {
            storage.ref().child(memeName).getData(10000000).then((data) =>
            setState(() {
              memeBytes.add(data); 
              memeCounter++;   
            })
            ).catchError((e) =>
            setState(() {
              errorMsg = e.error;
            }));
            print('HERE FUCKIN HERE');
}

checkIfMoreMeme() {
  // print('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!here');
  // print(memeCounter);
  // if (memeCounter <=  2) {
  //   getMemeNameAndRandom();
  // } else {
  //   print('we good');
  // }
}

voting(orientation, index) async {
  String memeToVote = '';
  DocumentReference postRef= null;
      Firestore.instance.collection('memes').where('name', isEqualTo: memesDocument[index]).snapshots().listen((data)=> {
      memeToVote = data.documents.first.documentID,
      postRef =  Firestore.instance.collection('memes').document(memeToVote)
    });
  // final DocumentReference postRef = Firestore.instance.document('f2b5ae40-f3d4-11e9-9c20-eb9eb1756ef0');

  if(orientation == CardSwipeOrientation.LEFT) {
    Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(postRef);
    if (postSnapshot.exists) {
    await tx.update(postRef, <String, dynamic>{'downvote': postSnapshot.data['downvote'] + 1, 'total': postSnapshot.data['total'] + 1});
    }
  });
  } else {
        Firestore.instance.runTransaction((Transaction tx) async {
    DocumentSnapshot postSnapshot = await tx.get(postRef);
    if (postSnapshot.exists) {
    await tx.update(postRef, <String, dynamic>{'upvote': postSnapshot.data['upvote'] + 1, 'total': postSnapshot.data['total'] + 1});
    }
  });
  }
}

    




void initState() {
  super.initState();
  getMemeNameAndRandom();
}


  //TODO Manage to remove the behind stack.
  //TODO Faster animation.

  @override
  Widget build(BuildContext context) {
    var img = memeBytes.first != null ? Image.memory
    (memeBytes.first,
    fit: BoxFit.cover
    ) : Text(errorMsg != null ? errorMsg : 'Loading..');
    CardController controller;
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: TinderSwapCard(
          orientation: AmassOrientation.BOTTOM,
          totalNum: 4,
          stackNum: 4,
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
                          child: Icon(Icons.bookmark_border,color: kHighlightColor,),

                        ),
                      ],
                    ),
                    Image.memory(memeBytes[index]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: <Widget>[
                        RawMaterialButton(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.favorite,
                                color: kPink,
                              ),
                              Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: Text('${(100 * upvote[index] / total[index]).round()}%',
                                    style: TextStyle(
                                        color: kHighlightColor,
                                        fontFamily: 'Lato')),
                              )
                            ],
                          ),
                          onPressed: () {
                            controller.triggerLeft();
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
                                child: Text('${(100 * downvote[index] / total[index]).round()}%',
                                    style: TextStyle(

                                        color: kHighlightColor,
                                        fontFamily: 'Lato',)),
                              ),
                            ],
                          ),
                          onPressed: () {
                            controller.triggerRight();
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
          cardController: controller = CardController(),
          swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
            /// Get swiping card's alignment
            if (align.x < 0) {
              //Card is LEFT swipin
            


            } else if (align.x > 0) {
              //Card is RIGHT swiping
             
            }
          },
          swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
            /// Get orientation & index of swiped card!
                 memeCounter--;
                 checkIfMoreMeme();
                 voting(orientation, index);
          }),
    );
  }
}
