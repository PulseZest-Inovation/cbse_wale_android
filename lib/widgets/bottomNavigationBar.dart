import 'package:cbse_wale_android/HomePage/homePage.dart';
// import 'package:cbse_wale_android/courses/courseList.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../TestSeries/testsDisplay.dart';

class BottomBar extends StatefulWidget {
  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with WidgetsBindingObserver {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  final List<Widget> _tabs = [
    HomePage(),
    HomePage(),
    HomePage(),
    TestsDisplay(),
    HomePage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // updateUserStatus(true);
  }

  @override
  void dispose() {
    // updateUserStatus(false);
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // void updateUserStatus(bool isOnline) async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     if (user != null) {
  //       await FirebaseFirestore.instance
  //           .collection('students')
  //           .doc(user.uid)
  //           .update({'isOnline': isOnline});
  //
  //       if (!isOnline) {
  //         Timestamp lastSeenTime = Timestamp.now();
  //         await FirebaseFirestore.instance
  //             .collection('students')
  //             .doc(user.uid)
  //             .update({'lastSeen': lastSeenTime});
  //       }
  //     }
  //   } catch (e) {
  //     print('Error updating user status: $e');
  //   }
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);
  //   switch (state) {
  //     case AppLifecycleState.paused:
  //     case AppLifecycleState.detached:
  //       updateUserStatus(false);
  //       break;
  //     case AppLifecycleState.resumed:
  //       updateUserStatus(true);
  //       break;
  //     default:
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _tabs,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.orange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Notes',
            backgroundColor: Colors.orange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail_lock_sharp),
            label: 'Study',
            backgroundColor: Colors.orange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Test',
            backgroundColor: Colors.orange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
            backgroundColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}
