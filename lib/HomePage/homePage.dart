import 'dart:async';
import 'package:cbse_wale_android/courses/coursesDisplay.dart';
import 'package:cbse_wale_android/widgets/appBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/sideBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? currentUser;
  Map<String, dynamic>? teacherData;
  String url = '';
  bool isLoading = false;
  List<String> imageUrls = [];
  List<Map<String, dynamic>> courseInfo = [];
  List<Map<String, dynamic>> activeCourses = [];
  List<Map<String, dynamic>> pastCourses = [];
  List<Map<String, dynamic>> futureCourses = [];

  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    initialiseUrl();
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
    courseData();
  }

  void initialiseUrl() async {
    await fetchImageUrls();
  }

  void courseData() async {
    await fetchCourses();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> fetchImageUrls() async {
    final imagesCollection = FirebaseFirestore.instance.collection('images');
    final querySnapshot = await imagesCollection.get();

    for (var queryDoc in querySnapshot.docs) {
      final url = queryDoc.get('url') as String;
      if (url != null) {
        imageUrls.add(url);
      } else {
        print('Document ${queryDoc.id} is missing the "url" field.');
      }
    }
  }

  Future<void> fetchCourses() async {
    final coursesCollection = FirebaseFirestore.instance.collection('courses');
    final querySnapshot = await coursesCollection.get();
    setState(() {
      courseInfo = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    });

    for (var course in courseInfo) {
      final startDateString = course['startDate'];
      final endDateString = course['endDate'];
      final startDate = DateTime.parse(startDateString);
      final endDate = DateTime.parse(endDateString);
      final now = DateTime.now();

      if (startDate.isAfter(now)) {
        // startDate is after now
        futureCourses.add(course);
      } else if (endDate.isBefore(now)) {
        // endDate is before now
        pastCourses.add(course);
      } else {
        //consider it active
        activeCourses.add(course);
      }
      print(course);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(text: 'Courses'),
      drawer: SideBar(),
      body: isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey.shade100,
              highlightColor: Colors.grey.shade100,
              child: ListView.builder(
                itemCount: 5, // Number of shimmer items
                itemBuilder: (context, index) => ListTile(
                  title: Container(
                    height: 80.0,
                    color: Colors.grey[200],
                  ),
                ),
              ),
            )
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
                              CourseDisplay(
                                  courseList: activeCourses, type: 'Active'),
                              CourseDisplay(
                                  courseList: pastCourses, type: 'Past'),
                              CourseDisplay(
                                  courseList: futureCourses, type: 'Future'),
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
