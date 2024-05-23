import 'package:cbse_wale_android/HomePage/homePage.dart';
import 'package:cbse_wale_android/widgets/appBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'coursesDisplay.dart';

class CourseDetails extends StatefulWidget {
  final Map<String, dynamic> courseData;
  const CourseDetails({
    Key? key,
    required this.courseData,
  }) : super(key: key);

  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  String formatDate(String dateString) {
    try {
      final DateTime parsedDate = DateTime.parse(dateString);
      final DateFormat outputFormat = DateFormat('dd/MM/yyyy');
      return outputFormat.format(parsedDate);
    } catch (e) {
      print('Error parsing date string: $e');
      return dateString; // Or return a default value if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: CustomAppBar(text: 'Course Details'),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        widget.courseData['thumbnail'],
                        height: 250.0,
                        width: MediaQuery.of(context).size.width * 0.8,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.courseData['title'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.courseData['description'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'Class - ${widget.courseData['class']}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Validity - ${widget.courseData['duration']}    ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        '(${formatDate(widget.courseData['startDate'])} : ${formatDate(widget.courseData['endDate'])})',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1,
                  ),
                  Expanded(
                    child: DefaultTabController(
                      length: 2, // Number of tabs
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
                                      "Details",
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Syllabus",
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
                                DetailsTab(),
                                SyllabusTab(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DetailsTab extends StatelessWidget {
  const DetailsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Details'));
  }
}

class SyllabusTab extends StatelessWidget {
  const SyllabusTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Syllabus'));
  }
}
