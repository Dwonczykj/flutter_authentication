import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_authentication/screens/add_video.dart';
// import 'package:flutter_authentication/screens/messages.dart';
import 'package:flutter_authentication/screens/profile_page.dart';
// import 'package:flutter_authentication/screens/search.dart';
import 'package:flutter_authentication/screens/feed.dart';
import 'package:flutter_authentication/screens/register_page.dart';
import 'package:flutter_authentication/utils/variables.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FirebaseAuth _auth;
  late User _user;
  late List pageoptions;

  int page = 0;
  customicon() {
    return Container(
      width: 45,
      height: 27,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            width: 38,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 250, 45, 108),
                borderRadius: BorderRadius.circular(7)),
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            width: 38,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 32, 211, 234),
                borderRadius: BorderRadius.circular(7)),
          ),
          Center(
            child: Container(
              height: double.infinity,
              width: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Icon(Icons.add, size: 20),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // _initialization.whenComplete(() {
    _auth = FirebaseAuth.instance;
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        setState(() {
          pageoptions = [
            RegisterPage()
          ];
        });
        
      } else {
        print('User is signed in!');
        setState(() {
          _user = user;
          pageoptions = [
            Feed(user: user),
            ProfilePage(user: user),
            // SearchPage(),
            // AddVideoPage(),
            // Messages(),
            // ProfilePage(FirebaseAuth.instance.currentUser.uid),
            RegisterPage()
          ];
        });
        
      }
    });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageoptions[page],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            page = index;
          });
        },
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.black,
        currentIndex: page,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30),
              title: Text(
                "Home",
                style: mystyle(12),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 30),
              title: Text(
                "Search",
                style: mystyle(12),
              )),
          BottomNavigationBarItem(
              icon: customicon(),
              title: Text(
                "",
                style: mystyle(12),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.message, size: 30),
              title: Text(
                "Messages",
                style: mystyle(12),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30),
              title: Text(
                "Profile",
                style: mystyle(12),
              ))
        ],
      ),
    );
  }
}
