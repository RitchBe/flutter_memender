import 'package:flushbar/flushbar_route.dart';

import '../constants.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'flushbarsString.dart';
import 'package:flushbar/flushbar_route.dart' as route;

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

  void initState() {
    super.initState();
    // getMemeImage();
  }

  // Future<String> getMemeImage() async {
  //   print('~~~~~~~~~~~~~~~~~~~~~~~~wave~~~~~~~~~~~~~~~~~');
  //   print(widget.document['dateCreation']);
  //   StorageReference ref = widget.storage.ref().child(widget.document['name']);
  //   var imageUrl = await ref.getDownloadURL();

  //   setState(() {
  //     url = imageUrl.toString();
  //   });
  //   print('you will do it');
  //   print(url);
  // }

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
            LinearGradient(colors: [Color(0xFFFF6996), Color(0xFF524A87)]))..show(widget.context);



   

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
         Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
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
                          padding: const EdgeInsets.only(right: 38.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, right: 8.0),
                                    child: Icon(
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
                              ),
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))),
       

      ]

          
    );
  }
}
