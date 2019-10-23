import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memender/components/nestedTabBarView.dart';
import 'package:memender/screens/top_screen.dart';
import '../constants.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_bar.dart';
import '../components/large_cards.dart';
import '../components/main_drawer.dart';
import 'profile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:flushbar/flushbar.dart';
import '../components/nestedTabBarView.dart';

class Home extends StatefulWidget {


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  String url = '';
  File _image;





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

  // void getMemes() async {
  //   final ref = FirebaseStorage.instance.ref().child('images/meme-1.jpg');
  //   var url = Uri.parse(await ref.getDownloadURL());
  //   setState(() {
  //     url = url;
  //   });
  // }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var uuid = new Uuid();
    setState(() {
      _image = image;
      print(_image);
    });
    final StorageReference storageReference = FirebaseStorage.instance.ref().child('images/').child('${uuid.v1()}');
    final StorageUploadTask uploadTask = storageReference.putFile(_image);
    final StreamSubscription<StorageTaskEvent> streamSubscription = uploadTask.events.listen((event) {
      print('EVENT ${event.type}');
    });

    await uploadTask.onComplete;
    streamSubscription.cancel();

      Flushbar(
      title:  "Your meme was send to the stratosphere 🚀",
      message:  "..better be funny or it will get destroy 💣 ",
      duration:  Duration(seconds: 4),  
      backgroundGradient: LinearGradient(
        colors: [Color(0xFFFF6996), Color(0xFF524A87)]
        )          
    )..show(context);


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
              icon: Image.asset('assets/home.png', width: 18.0,),
              activeIcon: Image.asset('assets/homeFocused.png', width: 18.0,),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Image.asset('assets/user.png', width: 18.0,),
              activeIcon: Image.asset('assets/userFocused.png', width: 18.0,),
              title: Text("Profile"),
            ),
          ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FlatButton(
        child: Image.asset(
          'assets/addMeme.png',
          height: 80.0,
        ),
        onPressed: (){
          getImage();

        },
      ),
      drawer: MainDrawer(),
      drawerScrimColor: Color(0x00),
      
    );
  }
}




//  Center(
//         child: RaisedButton(
//           child: Text('Log out'),
//       onPressed: () {
//         FirebaseAuth.instance.signOut().then((value) {
//             Navigator.of(context).pop();
//         });
//       },
//     ));