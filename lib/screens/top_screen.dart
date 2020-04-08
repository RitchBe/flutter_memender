import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../components/small_card.dart';

class TopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> routeArgument =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: TopList(routeArgument['order']),
      drawerScrimColor: Color(0x00),
      appBar: AppBar( 
        elevation: 0,
        backgroundColor: kBackgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: kHighlightColor,
        ),
        actions: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Text(
                '${routeArgument['order']}',
                style: TextStyle(
                    color: kHighlightColor, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TopList extends StatefulWidget {
  final String order;
  TopList(this.order);
  _TopListState createState() => _TopListState();
}

class _TopListState extends State<TopList> {

  String userId;
  List currentUserHasReportedUsers = [];




  String url;
  final FirebaseAuth auth = FirebaseAuth.instance;
 

    Future getUserRef() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;

    setState(() {
      userId = uid;
    });
    print(userId);
    getReported();

  }

  Future getReported() async {
    await Firestore.instance.collection('users').document(userId).get().then((user) {
      print('from the llopp');
      print(user);
      print(user['UserReported']);
      setState(() {
        if (user['UserReported'] == null) {
          currentUserHasReportedUsers = [];
          print(currentUserHasReportedUsers);
        } else {
          currentUserHasReportedUsers = user['UserReported'];

        }
      });
    });
  }


@override
  void initState() {
    super.initState();
    getUserRef();
  }





  @override
  
  Widget build(BuildContext context) {
    final FirebaseStorage storage = FirebaseStorage(
        app: Firestore.instance.app,
        storageBucket: 'gs://memender-47f82.appspot.com');

    DateTime beginDate;
    List memesSnapshot = [];

    if (widget.order == 'Monthly favorites') {
      beginDate = DateTime.now().subtract(Duration(days: 31));
    } else if (widget.order == 'Weekly favorites') {
      beginDate = DateTime.now().subtract(Duration(days: 7));
    }

    if (currentUserHasReportedUsers.length >= 0) {
          return Stack(
      children: <Widget>[
        StreamBuilder(
            stream:
                // widget.order == 'All time favorites' ?
                Firestore.instance
                    .collection('memes')
                    .orderBy('upvote', descending: true)
                    .orderBy('downvote')
                    .snapshots()
            // :
            // Firestore.instance.collection('memes').orderBy('upvote', descending: true).orderBy('downvote').snapshots()
            ,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return const Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFCFB4F1))),
                );
      

              if (widget.order == "Monthly favorites") {
                snapshot.data.documents.forEach((doc) => {
                      (DateTime.now()
                                  .difference(
                                      new DateTime.fromMicrosecondsSinceEpoch(
                                          doc['dateCreation'] * 1000))
                                  .inDays <=
                              31) || currentUserHasReportedUsers.contains(doc['userId']) != false
                          ? memesSnapshot.add(doc)
                          : ''
                    });
              } else if (widget.order == "Weekly favorites") {
                snapshot.data.documents.forEach((doc) => {
                      (DateTime.now()
                                  .difference(
                                      new DateTime.fromMicrosecondsSinceEpoch(
                                          doc['dateCreation'] * 1000))
                                  .inDays <=
                              7) || currentUserHasReportedUsers.contains(doc['userId']) != true 
                          ? memesSnapshot.add(doc)
                          : ''
                    });
              } else {

                snapshot.data.documents.forEach((doc) => {
                currentUserHasReportedUsers.contains(doc['userId'])  != true ?
                memesSnapshot.add(doc) :
                null
                });
              }

   

              return ListView.builder(
                shrinkWrap: true,
                itemCount: memesSnapshot.length,
                itemBuilder: (BuildContext context, int i) =>
                    SmallCardList(context, memesSnapshot[i], storage, 'top')


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
