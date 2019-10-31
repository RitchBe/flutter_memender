import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:memender/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:flushbar/flushbar.dart';
import '../components/flushbarsString.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'dart:math';

import 'package:device_id/device_id.dart';

const String testDevice = '83f7cd37483f08ae';

class CardSwiper extends StatefulWidget {
  @override
  _CardSwiperState createState() => _CardSwiperState();
}

class _CardSwiperState extends State<CardSwiper> {
  int hasShuffle = 0;
  List goodDocs = [];
  Icon bookmark = Icon(
    Icons.bookmark_border,
    color: kHighlightColor,
  );
  bool hasBeenShuffle = false;
  List<DocumentSnapshot> documents = [];

  int countForAds = 0;
  bool swipingLike = false;
  bool swipingDislike = false;
  double opacityLeftNum = 0;
  double opacityRightNum = 0;

  String deviceID;

  void getDeviceId() async {
    String deviceID = await DeviceId.getID;
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  String userId;

  Future testData() async {
    Firestore.instance.collection('memes').snapshots().listen((data) => {
          data.documents.shuffle(),
          data.documents.forEach((doc) => {
                (doc['usersHasSeen'].contains(userId) && goodDocs.length > 2000)
                    ? print('i am')
                    : goodDocs.add(doc),
              })
        });
  }

  getUserRef() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    DocumentReference userRef =
        Firestore.instance.collection('users').document(uid);
    setState(() {
      userId = user.uid;
    });
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
    } else if (orientation == CardSwipeOrientation.RIGHT) {
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
      countForAds++;
    });

    if (countForAds % 10 == 0) {
      loadAndShowAds();
    }

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

    var random = new Random();
    int randomIndex = random.nextInt(favoriteFlush.length - 1);
    String title = favoriteFlush.keys.elementAt(randomIndex);
    String message = favoriteFlush.values.elementAt(randomIndex);

    Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: title,
        message: message,
        duration: Duration(seconds: 5),
        backgroundGradient:
            LinearGradient(colors: [Color(0xFFFF6996), Color(0xFF524A87)]))
      ..show(context);

    randomIndex = random.nextInt(favoriteFlush.length - 1);
  }

  final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
  );

  InterstitialAd _interstitialAd;
  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: 'ca-app-pub-1373918645012713/5272851675',
        listener: (MobileAdEvent event) {
          print('Interstitial ad even $event');
        });
  }

  loadAndShowAds() {
    _interstitialAd?.dispose();
    _interstitialAd = createInterstitialAd()..load();
    _interstitialAd?.show();
  }

  @override
  void initState() {
    super.initState();
    getUserRef();
    testData();
    getDeviceId();

    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-1373918645012713~9842652074');
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CardController controller;
    return Stack(
      children: <Widget>[
        StreamBuilder(
            stream: Firestore.instance.collection('memes').limit(1).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFCFB4F1))),
                );

              return Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.03),
                child: TinderSwapCard(
                    animDuration: 800,
                    orientation: AmassOrientation.BOTTOM,
                    totalNum: 500,
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
                                        saveMeme(goodDocs[index]);
                                      },
                                      child: bookmark),
                                ],
                              ),
                              Expanded(
                                child: goodDocs.first != null
                                    ? Image.network(goodDocs[index]['url'])
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
                                              goodDocs[index]['downvote'] > 0
                                                  ? '${((goodDocs[index]['downvote'] / goodDocs[index]['total']) * 100).round()}%'
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
                                      Share.share(goodDocs[index]['url']);
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
                                              goodDocs[index]['upvote'] > 0
                                                  ? '${((goodDocs[index]['upvote'] / goodDocs[index]['total']) * 100).round()}%'
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
                              ),
                            ],
                          ),
                        ),
                    cardController: controller = CardController(),
                    swipeUpdateCallback:
                        (DragUpdateDetails details, Alignment align) {
                      /// Get swiping card's alignment
                      ///
                      if (align.x < 2.0 && align.x > -2.0) {
                        setState(() {
                          opacityLeftNum = 0;
                          opacityRightNum = 0;
                        });
                      } else if (align.x < -2) {
                        //Card is LEFT swipin

                        setState(() {
                          opacityLeftNum = 0.7;

                          // swipingDislike = true;
                        });
                      } else if (align.x > 2) {
                        //Card is RIGHT swiping
                        setState(() {
                          // swipingLike = true;
                          opacityRightNum = 0.7;
                        });
                      }
                      if (align.x > 10.0 || align.x < -10.0) {
                        setState(() {
                          opacityLeftNum = 0;
                          opacityRightNum = 0;
                        });
                      }
                    },
                    swipeCompleteCallback:
                        (CardSwipeOrientation orientation, int index) {
                      /// Get orientation & index of swiped card!
                      setState(() {
                        swipingDislike = false;
                        swipingLike = false;
                        opacityLeftNum = 0;
                        opacityRightNum = 0;
                        bookmark = Icon(
                          Icons.bookmark_border,
                          color: kHighlightColor,
                        );
                      });
                      voting(orientation, goodDocs[index]);
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
        ),
        // swipingLike ?
        AnimatedOpacity(
            duration: Duration(milliseconds: 100),
            opacity: opacityRightNum,
            child: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.15,
                  left: MediaQuery.of(context).size.width * 0.1),
              child: Container(
                padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kPink,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                transform: Matrix4.rotationZ(-0.3),
                child: Text('LIKE',
                    style: TextStyle(
                        color: kPink, fontSize: 16.0, fontFamily: 'Lato')),
              ),
            )),
        AnimatedOpacity(
            duration: Duration(milliseconds: 100),
            opacity: opacityLeftNum,
            child: Container(
              margin: EdgeInsets.only(
                  // top: MediaQuery.of(context).size.height * 0.04,
                  left: MediaQuery.of(context).size.width * 0.75),
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
              decoration: BoxDecoration(
                border: Border.all(color: kBlue),
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              transform: Matrix4.rotationZ(0.3),
              child: Text('DISLIKE',
                  style: TextStyle(
                      color: kBlue, fontSize: 16.0, fontFamily: 'Lato')),
            ))
        // : SizedBox()
      ],
    );
  }
}
