import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_bar.dart';
import '../components/large_cards.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  DocumentReference userRef;
  inputData() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    DocumentReference userRef =
        Firestore.instance.collection('users').document(uid);
    print('HERRRRRRE');
    print(uid);
    print(userRef);
    setState(() {
      userRef = userRef;
    });
    // here you write the codes to input the data into firestore
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseStorage storage = FirebaseStorage(
        app: Firestore.instance.app,
        storageBucket: 'gs://memender-47f82.appspot.com');
    return Stack(
      children: <Widget>[
        StreamBuilder(
            stream: Firestore.instance
                .collection('memes')
                .where('userId', isEqualTo: userRef)
                .limit(100)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const Center(
                  child: Text('Loading'),
                );
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int i) =>
                    UserCard(context, snapshot.data.documents[i], storage),
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
            height: MediaQuery.of(context).size.height * 0.15,
          ),
        )
      ],
    );
  }
}

class UserCard extends StatefulWidget {
  BuildContext context;
  DocumentSnapshot document;
  FirebaseStorage storage;

  UserCard(this.context, this.document, this.storage);

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  String url;

  void initState() {
    super.initState();
    uploadImage();
  }

  Future<String> uploadImage() async {
    print('~~~~~~~~~~~~~~~~~~~~~~~~wave~~~~~~~~~~~~~~~~~');
    StorageReference ref = widget.storage.ref().child(widget.document['name']);
    var imageUrl = await ref.getDownloadURL();

    setState(() {
      url = imageUrl.toString();
    });
    print('you will do it');
    print(url);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Expanded(
                    child: url == null
                        ? Text('Loading')
                        : Container(
                            child: Image.network(
                              url,
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
                            Icon(
                              Icons.favorite,
                              color: kPink,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 50.0),
                              child: Text('${widget.document['upvote']}',
                                  style: TextStyle(
                                      color: kHighlightColor,
                                      fontFamily: 'Lato')),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Icon(
                                Icons.thumb_down,
                                color: kBlue,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('${widget.document['downvote']}',
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
            )));
  }
}
