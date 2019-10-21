import 'package:flutter/material.dart';
import 'package:memender/screens/top_screen.dart';
import '../constants.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_bar.dart';
import '../components/large_cards.dart';
import '../components/main_drawer.dart';
import 'profile.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  String url = '';





  static List<Widget> _widgetOptions = <Widget>[
    CardSwiper(),
    Profile(),
    TopScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void getMemes() async {
    final ref = FirebaseStorage.instance.ref().child('images/meme-1.jpg');
    var url = Uri.parse(await ref.getDownloadURL());
    setState(() {
      url = url;
    });
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
      floatingActionButton: Container(
        child: Image.asset(
          'assets/addMeme.png',
          height: 80.0,
        ),
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