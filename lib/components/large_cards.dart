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

//HOME CARD SWIPER

class CardSwiper extends StatefulWidget {
  @override
  _CardSwiperState createState() => _CardSwiperState();
}

class _CardSwiperState extends State<CardSwiper> {
  int hasShuffle = 0;
  List goodDocs = [];

  //TO CHANGE WHEN IMAGE IS LIKED
  Icon bookmark = Icon(
    Icons.star_border,
    color: kHighlightColor,
  );
  bool hasBeenShuffle = false;
  List<DocumentSnapshot> documents = [];

  // int countForAds = 0;
  bool swipingLike = false;
  bool swipingDislike = false;
  double opacityLeftNum = 0;
  double opacityRightNum = 0;

  List currentUserHasReportedUsers;

  String deviceID;

  final FirebaseAuth auth = FirebaseAuth.instance;
  String userId;

  Future getUserRef() async {
    setState(() {
      goodDocs= [];
    });
    try {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
        setState(() {
      userId = uid;
      

    });
      testData();
    } catch(error) {
      print(error);
      print('here is the error');
    }

    // DocumentReference userRef =
    //     Firestore.instance.collection('users').document(uid);



    // here you write the codes to input the data into firestore
  }

  //FUNCTION GETTING THE IMAGES.
  Future testData() async {
    print(' ia am here');
    await Firestore.instance.collection('users').document(userId).get().then((user) {
      print('here lies the user');
      print(user['UserReported']);
      setState(() {
        if (user['UserReported'] == null) {
          currentUserHasReportedUsers = [];
        } else {
          currentUserHasReportedUsers = user['UserReported'];

        }
      });
    });

    print('not here');
    Firestore.instance.collection('memes').snapshots().listen((data) => {
          data.documents.shuffle(),
          if (goodDocs.length < 5) {
            for ( var i = 400; i >- 1; i--) {
              print('getting more'),
              data.documents[i]['usersHasSeen'].contains(userId) || data.documents[i]['reported'] == true || currentUserHasReportedUsers.contains(data.documents[i]['userId']) ? null : 
              setState(() {
                if (goodDocs.length != 100) {
                  goodDocs.add(data.documents[i]);
                }

              })
            }
          }

          // data.documents.forEach((doc) => {
          //       doc['usersHasSeen'].contains(userId) || doc['reported'] == true || currentUserHasReportedUsers.contains(doc['userId']) == true
          //           ? null
          //           : goodDocs.add(doc),
          //     }),
      
        });
  }

  List<String> urls = [];

  voting(orientation, doc) async {
            print(goodDocs.length);

    print('VOTINg');
    print(doc['memeId']);
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
      print("Voting left");
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
      print("Voting righht");
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
    
    // setState(() {
    //   countForAds++;
    // });

    // if (countForAds % 20 == 0) {
    //   loadAndShowAds();
    // }

    // var list = List();
    // list.add('test');
    //  await postRef.updateData({"usersHasSeen": FieldValue.arrayUnion(list)});
  }

  saveMeme(document) async {
    // try {
    //   var imageId = await ImageDownloader.downloadImage(document['url']);
    //   if (imageId == null) {
    //     return;
    //   }
    // } on PlatformException catch (error) {
    //   print(error);
    // }

    Firestore.instance
        .collection('memes')
        .document(document['memeId'])
        .updateData({
      'usersHasFavorite': FieldValue.arrayUnion([userId])
    });
    // print(userId);
    //       Firestore.instance
    //         .collection('users')
    //         .document(userId)
    //         .updateData({
    //           'favorite': FieldValue.arrayUnion([document['memeId']])
    //           });

    setState(() {
      bookmark = Icon(
        Icons.star,
        color: kHighlightColor,
      );
    });

    var random = new Random();
    int randomIndex = random.nextInt(favoriteFlush.length - 1);
    print(randomIndex);
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

  // final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo();

  // InterstitialAd _interstitialAd;
  // InterstitialAd createInterstitialAd() {
  //   return InterstitialAd(
  //       adUnitId: 'ca-app-pub-1373918645012713/5272851675',
  //       listener: (MobileAdEvent event) {
  //         print('Interstitial ad even $event');
  //       });
  // }

  // loadAndShowAds() {
  //   _interstitialAd?.dispose();
  //   _interstitialAd = createInterstitialAd()..load();
  //   _interstitialAd?.show();
  // }

  openModalReport(badMeme) {
      showDialog(
        context: context,
        builder: (dialogContex) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                        constraints: BoxConstraints(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Report this image if you think it should be deleted. I will put it in the trash myself.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 17.0
                                      ),
                                    ),
                                  
                                    SizedBox(height: 15.0,),
                                     RawMaterialButton(
                                        fillColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(40)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                          child: Text('Report This Image',
                                          style: TextStyle(color: kWhite),),
                                        ),
                                        onPressed: () {
                                          reportMeme(badMeme);
                                        },
                                        ),
                                    SizedBox(height: 15.0,),
                                        
                                    
                                    Text(
                                      'Report this image and block this user. You will not see any of this user images anymore.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 17.0,
                                      
                                      ),
                                    ),
                                    SizedBox(height: 15.0,),

                                  RawMaterialButton(
                                        fillColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(40)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                                          child: Text('Block This User', style: TextStyle(color: kWhite)),
                                        ),
                                        onPressed: () {
                                          reportUser(badMeme);
                                        },
                                        ),
                                    SizedBox(height: 15.0,),

                                    
                                    Text(
                                      "For any image reported or User blocked I will investigate the user, and banish him from this lil meme paradise if I judge it necessary.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 17.0
                                      ),
                                      )
                                  ],
                                ),
                )
                              
              ),
            )
          );
        }
      );
  }

  reportUser(badMeme) {
    reportMeme(badMeme);
    print('bad user id');
    print(badMeme['userId']);
    print('current user');
    print(userId);
    DocumentReference postRef;
    String userToReport;

    Firestore.instance
    .collection('users')
    .where('uid', isEqualTo: userId)
    .snapshots()
    .listen((data) => {
          userToReport = badMeme['userId'],
          postRef =
              Firestore.instance.collection('users').document(userId)
        });

    Firestore.instance.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        if (postSnapshot.exists) {
          await tx.update(postRef, {
            'UserReported': FieldValue.arrayUnion([userId])
          });
        } else {
          print('something stings');
        }
      });



    setState(() {
      goodDocs = [];
    });
      testData();

    Navigator.pop(context);
            Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Thank you for keeping the street clean !!",
        message: "You are now part of the Memender Patrol 🚓",
        duration: Duration(seconds: 5),
        backgroundGradient:
            LinearGradient(colors: [Color(0xFFFF6996), Color(0xFF524A87)]))
      ..show(context);
  }

  reportMeme(badMeme) {
    print(badMeme['memeId']);
    DocumentReference postRef;
    String memeToReport;


    Firestore.instance
    .collection('memes')
    .where('name', isEqualTo: badMeme['name'])
    .snapshots()
    .listen((data) => {
          memeToReport = badMeme['memeId'],
          postRef =
              Firestore.instance.collection('memes').document(memeToReport)
        });

    Firestore.instance.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        if (postSnapshot.exists) {
          await tx.update(postRef, {
            'reported': true
          });
        } else {
          print('something stings');
        }
      });
          setState(() {
      goodDocs = [];
    });
      testData();

    Navigator.pop(context);
            Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Thank you for keeping the street clean !!",
        message: "You are now part of the Memender Patrol 🚓",
        duration: Duration(seconds: 5),
        backgroundGradient:
            LinearGradient(colors: [Color(0xFFFF6996), Color(0xFF524A87)]))
      ..show(context);
  }

  @override
  void initState() {
    super.initState();
    print('in the init state actually');
    getUserRef();
    // testData();

    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-1373918645012713~9842652074');
  }

  // @override
  // void dispose() {
  // _interstitialAd?.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    CardController controller;
    if (goodDocs.length > 5) {
return Stack(
      children: <Widget>[
             Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.03),
                child: TinderSwapCard(
                    animDuration: 800,
                    orientation: AmassOrientation.BOTTOM,
                    totalNum: 200,
                    stackNum: 4,
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[

                                  RawMaterialButton(
                                    onPressed: () {
                                      openModalReport(goodDocs[index]);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0, right: 30.0),
                                      child: Icon(
                                        Icons.error_outline,
                                        color: kHighlightColor,
                                        
                                      ),
                                      )
                                  ),
                                    
                                  RawMaterialButton(
                                      onPressed: () {
                                        saveMeme(goodDocs[index]);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8.0, left: 30.0),
                                        child: bookmark,
                                      )),
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
                                          padding: EdgeInsets.only(bottom: 10.0),
                                          child: Icon(
                                            Icons.thumb_down,
                                            color: kBlue,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 17.0, left: 5.0),
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
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 10.0),
                                          child: Icon(
                                            Icons.share,
                                            color: Color(0xFFF9C9BA),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      Share.share(goodDocs[index]['url'] +
                                          ' ' +
                                          "Send with Memender");
                                    },
                                  ),
                                  RawMaterialButton(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 10.0),
                                          child: Icon(
                                            Icons.favorite,
                                            color: kPink,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 17.0, left: 5.0),
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
                          Icons.star_border,
                          color: kHighlightColor,
                        );
                      });
                      voting(orientation, goodDocs[index]);
                    }),
              ),
            
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
                    color: Colors.green,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                transform: Matrix4.rotationZ(-0.3),
                child: Text('LIKE',
                    style: TextStyle(
                        color: Colors.green, fontSize: 16.0, fontFamily: 'Lato', fontWeight: FontWeight.bold )),
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
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              transform: Matrix4.rotationZ(0.3),
              child: Text('DISLIKE',
                  style: TextStyle(
                      color: Colors.red, fontSize: 16.0, fontFamily: 'Lato', fontWeight: FontWeight.bold)),
            ))
        // : SizedBox()
      ],
    );
    } else {
           return Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFCFB4F1))),
                );
    }
    
  } 
}
