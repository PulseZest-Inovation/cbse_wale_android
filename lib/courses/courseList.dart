import 'dart:async';

import 'package:cbse_wale_android/courses/coursesDisplay.dart';
import 'package:cbse_wale_android/widgets/appBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CourseList extends StatefulWidget {
  const CourseList({super.key});

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  User? currentUser;
  Map<String, dynamic>? teacherData;
  String url = '';
  bool isLoading = false;
  List<String> imageUrls = [
    'https://images.hdqwalls.com/download/healing-within-wb-7680x4320.jpg',
    'https://images.hdqwalls.com/download/beerus-dragon-ball-qb-7680x4320.jpg',
    'https://media.istockphoto.com/id/1505391132/photo/summer-joy.jpg?s=2048x2048&w=is&k=20&c=veczVEsq_TfunScXvVqqepQSUpTPaYPCAMvpVCOgxSE=',
  ];
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (_currentPage < imageUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  late List<Map<String, dynamic>> activeCourses = [
    {
      'thumbnail':
          'https://images.hdqwalls.com/download/healing-within-wb-7680x4320.jpg',
      'name': 'Course1 kjnsiuwbf uheiuhqwedjbc iuwdiuqwdb',
      'validityStart': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().subtract(Duration(days: 30)).millisecondsSinceEpoch),
      'validityEnd': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().add(Duration(days: 60)).millisecondsSinceEpoch),
      'price': '25000',
    },
    {
      'thumbnail':
          'https://images.hdqwalls.com/download/healing-within-wb-7680x4320.jpg',
      'name': 'Course2 yashi yashi yashi yashi',
      'validityStart': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch),
      'validityEnd': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().add(Duration(days: 5)).millisecondsSinceEpoch),
      'price': '15000',
    },
    {
      'thumbnail':
          'https://media.istockphoto.com/id/1693725656/photo/light-blue-turquoise-cosmetic-ingredient-molecular-textured-background.jpg?s=1024x1024&w=is&k=20&c=ZlJ2Y3tbZt8PflVQD0gbBbt5jdkK_R5ZLr5v4ZRbI_U=',
      'name': 'Course3 kjnsiuwbf uheiuhqwedjbc iuwdiuqwdb',
      'validityStart': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().subtract(Duration(days: 30)).millisecondsSinceEpoch),
      'validityEnd': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().add(Duration(days: 60)).millisecondsSinceEpoch),
      'price': '25000',
    },
    {
      'thumbnail':
          'https://images.hdqwalls.com/download/healing-within-wb-7680x4320.jpg',
      'name': 'Course4 yashi yashi yashi yashi',
      'validityStart': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch),
      'validityEnd': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().add(Duration(days: 5)).millisecondsSinceEpoch),
      'price': '15000',
    },
    {
      'thumbnail':
          'https://images.unsplash.com/photo-1566438480900-0609be27a4be?q=80&w=394&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'name': 'Course5 yashi yashi yashi yashi',
      'validityStart': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch),
      'validityEnd': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().add(Duration(days: 5)).millisecondsSinceEpoch),
      'price': '15000',
    }
  ];

  late List<Map<String, dynamic>> pastCourses = [
    {
      'thumbnail':
          'https://media.istockphoto.com/id/1693725656/photo/light-blue-turquoise-cosmetic-ingredient-molecular-textured-background.jpg?s=1024x1024&w=is&k=20&c=ZlJ2Y3tbZt8PflVQD0gbBbt5jdkK_R5ZLr5v4ZRbI_U=',
      'name': 'Course3 kjnsiuwbf uheiuhqwedjbc iuwdiuqwdb',
      'validityStart': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().subtract(Duration(days: 30)).millisecondsSinceEpoch),
      'validityEnd': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().add(Duration(days: 60)).millisecondsSinceEpoch),
      'price': '25000',
    },
    {
      'thumbnail':
          'https://images.hdqwalls.com/download/healing-within-wb-7680x4320.jpg',
      'name': 'Course4 ',
      'validityStart': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch),
      'validityEnd': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().add(Duration(days: 5)).millisecondsSinceEpoch),
      'price': '15000',
    },
    {
      'thumbnail':
          'https://images.unsplash.com/photo-1566438480900-0609be27a4be?q=80&w=394&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'name': 'Course5 yashi yashi yashi yashi',
      'validityStart': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch),
      'validityEnd': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().add(Duration(days: 5)).millisecondsSinceEpoch),
      'price': '15000',
    }
  ];

  late List<Map<String, dynamic>> futureCourses = [
    {
      'thumbnail':
          'https://images.hdqwalls.com/download/healing-within-wb-7680x4320.jpg',
      'name': 'Course1 kjnsiuwbf uheiuhqwedjbc iuwdiuqwdb',
      'validityStart': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().subtract(Duration(days: 30)).millisecondsSinceEpoch),
      'validityEnd': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().add(Duration(days: 60)).millisecondsSinceEpoch),
      'price': '25000',
    },
    {
      'thumbnail':
          'https://images.unsplash.com/photo-1566438480900-0609be27a4be?q=80&w=394&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      'name': 'Course5 yashi yashi yashi yashi',
      'validityStart': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch),
      'validityEnd': Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().add(Duration(days: 5)).millisecondsSinceEpoch),
      'price': '15000',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: 'Courses'),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: imageUrls.length,
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Image.network(imageUrls[index]);
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(imageUrls.length,
                            (int index) {
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == index
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: DefaultTabController(
                    length: 3, // Number of tabs
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          child: const TabBar(
                            indicatorColor: Colors.blue,
                            indicatorWeight: 9.0,
                            tabs: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Active\nCourses",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Past\nCourses",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Future\nCourses",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              CourseDisplay(courseList: activeCourses),
                              CourseDisplay(courseList: pastCourses),
                              CourseDisplay(courseList: futureCourses),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
