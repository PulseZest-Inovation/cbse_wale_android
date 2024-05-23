import 'package:cbse_wale_android/courses/courseDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CourseDisplay extends StatefulWidget {
  final List<Map<String, dynamic>> courseList;

  const CourseDisplay({
    Key? key,
    required this.courseList,
  }) : super(key: key);

  @override
  _CourseDisplayState createState() => _CourseDisplayState();
}

class _CourseDisplayState extends State<CourseDisplay> {
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CourseDetails(courseData: courseData)), // Page to navigate to
        );
      },
      child: Card(
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
                  width: double.infinity,
                  height: 100.0,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                height: 70,
                child: Text(
                  courseData['title'],
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
                'Class - ${courseData['class']}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                ),
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
                '${formatDate(courseData['startDate'])} : ${formatDate(courseData['endDate'])}',
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: widget.courseList.length == 0
            ? Center(child: Text('No courses available'))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int i = 0;
                              i <= widget.courseList.length - 1;
                              i += 2) ...[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, top: 8.0, right: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                      child: buildInfoCard(
                                          courseData: widget.courseList[i])),
                                  if (i + 1 < widget.courseList.length) ...[
                                    Expanded(
                                        child: buildInfoCard(
                                            courseData:
                                                widget.courseList[i + 1])),
                                  ] else
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.46),
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
}
