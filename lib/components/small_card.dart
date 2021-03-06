import '../constants.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share/share.dart';


import 'package:flushbar/flushbar.dart';
import 'flushbarsString.dart';

class SmallCardList extends StatefulWidget {
  BuildContext context;
  DocumentSnapshot document;
  FirebaseStorage storage;
  String method;


  SmallCardList(this.context, this.document, this.storage, this.method);

  @override
  _SmallCardListState createState() => _SmallCardListState();
}

class _SmallCardListState extends State<SmallCardList> {
  String url;
  final FirebaseAuth auth = FirebaseAuth.instance;
 
  String userId;
    Icon bookmark = Icon(
    Icons.star_border,
    color: kHighlightColor,
  );

  Color unvoteBad = kBackgroundColor;
  Color unvoteBadText = kBackgroundColor;

  Color unvoteGoodText = kBackgroundColor;
  Color unvoteGood = kBackgroundColor;



    Future getUserRef() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;

    setState(() {
      userId = uid;
    });
    print(userId);


  }



@override
  void initState() {
    super.initState();
    getUserRef();
  }



  deleteMeme(document) async {
    await Firestore.instance
        .collection('memes')
        .document(document['memeId'])
        .delete();
    await widget.storage.ref().child('images/' + document['memeId']).delete();

    var random = new Random();
    int randomIndex = random.nextInt(deletedFlush.length - 1);
    String title = deletedFlush.keys.elementAt(randomIndex);
    String message = deletedFlush.values.elementAt(randomIndex);

    Flushbar(
        flushbarPosition: FlushbarPosition.BOTTOM,
        title: title,
        message: message,
        duration: Duration(seconds: 5),
        backgroundGradient:
            LinearGradient(colors: [Color(0xFFFF6996), Color(0xFF524A87)]))
      ..show(widget.context);

    randomIndex = random.nextInt(deletedFlush.length - 1);

    //     Flushbar(
    //   flushbarPosition: FlushbarPosition.TOP,
    //   title: "Meme saved 🖼️",
    //   message: "..somewhere in your gallery 🔮️ ",
    //   duration: Duration(seconds: 4),
    //   backgroundGradient:
    //       LinearGradient(colors: [Color(0xFFFF6996), Color(0xFF524A87)]))
    // ..show(context);
  }

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

upVote(document) {
    String memeToVote = '';
  DocumentReference postRef = null;
    Firestore.instance
        .collection('memes')
        .where('name', isEqualTo: document['name'])
        .snapshots()
        .listen((data) => {
              memeToVote = document['memeId'],
              postRef =
                  Firestore.instance.collection('memes').document(memeToVote)
            });


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


downVote(document) {
    String memeToVote = '';
  DocumentReference postRef = null;
    Firestore.instance
        .collection('memes')
        .where('name', isEqualTo: document['name'])
        .snapshots()
        .listen((data) => {
              memeToVote = document['memeId'],
              postRef =
                  Firestore.instance.collection('memes').document(memeToVote)
            });


      Firestore.instance.runTransaction((Transaction tx) async {
        DocumentSnapshot postSnapshot = await tx.get(postRef);
        if (postSnapshot.exists) {
          await tx.update(postRef, <String, dynamic>{
            'downvote': postSnapshot.data['upvote'] + 1,
            'total': postSnapshot.data['total'] + 1,
            'usersHasSeen': FieldValue.arrayUnion([userId])
          });
        }
      });
}

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
        widget.document['reported'] != true ?
      Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          child: Container(
              height: MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.width * 0.90,
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: Container(
               
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    color: kWhite,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200],
                        blurRadius: 5.0,
                        spreadRadius: 2.0,
                        offset: Offset(0.0, 5.0),
                      )
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[


                    widget.method == 'uploaded'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              RawMaterialButton(
                                onPressed: () {
                                  deleteMeme(widget.document);
                                },
                                child: Icon(
                                  Icons.delete_sweep,
                                  color: kHighlightColor,
                                ),
                              )
                            ],
                          )
                        : SizedBox(),

                 
                     Padding(
                       padding: const EdgeInsets.only(bottom: 8.0),
                       child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround, 
                       
                        children: <Widget> [
                          widget.method == "top" ?
                          RawMaterialButton(
                                      onPressed: () {
                                        openModalReport(widget.document);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Icon(
                                          Icons.error_outline,
                                          color: kHighlightColor,
                                          
                                        ),
                                        )
                                    ) : SizedBox(height: 0.0,),
                                                                    
                        RawMaterialButton(
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Icon(
                                      Icons.share,
                                      color: kHighlightColor,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                Share.share(widget.document['url'] +
                                    ' ' +
                                    "Send with Memender");
                              },
                            ),
                          widget.method == "top" ?

                            RawMaterialButton(
                                      onPressed: () {
                                        saveMeme(widget.document);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child:  bookmark
                                        )
                                      ) : SizedBox(height: 0.0,),


                        ],
                    ),
                     ) ,
                    
                        
                    Expanded(
                      // child: url == null
                      //     ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFCFB4F1)))
                      //     :
                      child: Container(
                        child: Image.network(
                          widget.document['url'],
                          scale: 2.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 38.0, bottom: 8.0, top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[

                          widget.document['usersHasSeen'].contains(userId) ?
                          Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, right: 8.0),
                                child:
                               
                                 Icon(
                                  Icons.thumb_down,
                                  color: kBlue,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Text('${widget.document['downvote']}',
                                    style: TextStyle(
                                        color: kHighlightColor,
                                        fontFamily: 'Lato')),
                              ),
                            ],
                          ) :

                        RawMaterialButton(
                          padding: EdgeInsets.only(left: 20.0),
                          constraints: BoxConstraints(
                            maxWidth: 61.0
                          ),
                          
                          onPressed: () {
                            downVote(widget.document);
                            setState(() {
                              unvoteBad = kBlue;
                              unvoteBadText = kHighlightColor;

                            });
                          },
                            child: Row(
                              children: <Widget>[

                                Padding(
                                      padding:
                                            const EdgeInsets.only(top: 8.0, right: 8.0),
                                        child:
                                       
                                         Icon(
                                          Icons.thumb_down,
                                          color: unvoteBad,
                                        ),
                                      ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 0.0),
                                  child: Text('${widget.document['downvote']}',
                                      style: TextStyle(
                                          color: unvoteBadText,
                                          fontFamily: 'Lato')),
                                ),
                              ],
                            ),
                        ),
                        
                          widget.document['usersHasSeen'].contains(userId) ?

                          Row(
                              children: <Widget>[
                                Icon(
                                  Icons.favorite,
                                  color: kPink,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text('${widget.document['upvote']}',
                                      style: TextStyle(
                                          color: kHighlightColor,
                                          fontFamily: 'Lato')),
                                ),
                              ],
                            ) :
                          RawMaterialButton(
                            padding: EdgeInsets.only(left: 20.0),
                        constraints: BoxConstraints(
                            maxWidth: 61.0
                          ),
                            onPressed: () {
                              upVote(widget.document);
                              setState(() {
                                unvoteGood = kPink;
                                unvoteGoodText = kHighlightColor;
                      
                              });
                            },
                            child: Row(
                            children: <Widget>[
                             Icon(
                                   Icons.favorite,
                                   color: unvoteGood,
                                 ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text('${widget.document['upvote']}',
                                    style: TextStyle(
                                        color: unvoteGoodText,
                                        fontFamily: 'Lato')),
                              ),
                            ],
                          ),
                                         )
                        ],
                      ),
                    ),
                  ],
                ),
              ))) :
              SizedBox(),
    ]);
  }
}
