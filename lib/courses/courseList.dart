import 'package:cbse_wale_android/widgets/appBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CourseList extends StatefulWidget {
  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  late List<Map<String, dynamic>> courses = [
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

  String formatDateToString(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    int year = dateTime.year;
    int month = dateTime.month; // Month is 1-indexed (January is 1)
    int day = dateTime.day;
    String formattedDate = '$day/${month.toString().padLeft(2, '0')}/$year';
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: CustomAppBar(text: 'Courses'),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildSection(title: 'My Library', icon: Icons.book),
                    buildSection(title: 'Live Classes', icon: Icons.live_tv),
                    buildSection(title: 'Live Tests', icon: Icons.assessment),
                  ],
                ),
              ),

              // Divider line
              const Divider(
                color: Colors.grey,
                thickness: 1.0,
                indent: 16.0,
                endIndent: 16.0,
              ),

              SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i <= courses.length - 1; i += 2) ...[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, top: 8.0, right: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                child: buildInfoCard(courseData: courses[i])),
                            if (i + 1 < courses.length) ...[
                              Expanded(
                                  child: buildInfoCard(
                                      courseData: courses[i + 1])),
                            ] else
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.46),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(height: 20),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSection({required String title, required IconData icon}) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32.0,
          color: Colors.blue,
        ),
        Text(
          title,
          style: GoogleFonts.acme(
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget buildInfoCard({required Map<String, dynamic> courseData}) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.42,
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                courseData['thumbnail'],
                width: double.infinity, // Stretch image to fill container width
                height: 100.0, // Set image height
                fit: BoxFit.cover, // Ensure image covers the entire area
              ),
            ),
            SizedBox(height: 8.0), // Add spacing between image and text
            Container(
              height: 70,
              child: Text(
                courseData['name'],
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1.5,
            ),
            Text(
              'Validity',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              '${formatDateToString(courseData['validityStart'])} : ${formatDateToString(courseData['validityEnd'])}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '₹ ${courseData['price']} /-',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
