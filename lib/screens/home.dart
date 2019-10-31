import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memender/components/nestedTabBarView.dart';
import 'package:memender/screens/top_screen.dart';

import '../constants.dart';
import '../components/custom_app_bar.dart';

import '../components/large_cards.dart';
import '../components/main_drawer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flushbar/flushbar.dart';
import '../components/nestedTabBarView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/flushbarsString.dart';
import 'dart:math';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  String url = '';
  File _image;
  String userId;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    getUserRef();
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

  static List<Widget> _widgetOptions = <Widget>[
    CardSwiper(),
    NestedTabBar(),
    TopScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future _replaceUserId(id) async {
    DocumentReference postRef = null;

    int i = 0;
    while (i <= 12) {
      Firestore.instance
          .collection('memes')
          .document(id)
          .updateData({'userId': userId});
      Future.delayed(Duration(seconds: 7));
      i++;
    }
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var uuid = new Uuid();
    var id = uuid.v1();
    setState(() {
      _image = image;
    });
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child('images/').child('$id');
    final StorageUploadTask uploadTask = storageReference.putFile(_image);
    final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
      print('EVENT ${event.type}');
    });

    await uploadTask.onComplete.then((data) => _replaceUserId(id));
    streamSubscription.cancel();

    var random = new Random();
    int randomIndex = random.nextInt(addFlush.length - 1);
    String title = addFlush.keys.elementAt(randomIndex);
    String message = addFlush.values.elementAt(randomIndex);

    Flushbar(
        title: title,
        message: message,
        duration: Duration(seconds: 5),
        backgroundGradient:
            LinearGradient(colors: [Color(0xFFFF6996), Color(0xFF524A87)]))
      ..show(context);
    randomIndex = random.nextInt(shareFlush.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: kBackgroundColor,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 0.0,
          selectedItemColor: Colors.pink,
          currentIndex: _selectedIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/home.png',
                width: 18.0,
              ),
              activeIcon: Image.asset(
                'assets/homeFocused.png',
                width: 18.0,
              ),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/user.png',
                width: 18.0,
              ),
              activeIcon: Image.asset(
                'assets/userFocused.png',
                width: 18.0,
              ),
              title: Text("Profile"),
            ),
          ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FlatButton(
        child: Image.asset(
          'assets/addMeme.png',
          height: 80.0,
        ),
        onPressed: () {
          getImage();
        },
      ),
      drawer: MainDrawer(),
      drawerScrimColor: Color(0x00),
    );
  }
}
