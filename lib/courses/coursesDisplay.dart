import 'package:cbse_wale_android/courses/courseDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CourseDisplay extends StatefulWidget {
  final List<Map<String, dynamic>> courseList;
  final String type;

  const CourseDisplay({
    Key? key,
    required this.courseList,
    required this.type,
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
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                courseData['thumbnail'],
                width: double.infinity,
                height: 200.0,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              height: 50,
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
            Row(
              children: [
                Icon(Icons.menu_book_rounded),
                SizedBox(width: 10),
                Text(
                  'Class - ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  courseData['class'] != null ? courseData['class'] : 'N/A',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.person),
                SizedBox(width: 10),
                Text(
                  'Teacher - ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  courseData['teacherName'] != null
                      ? courseData['teacherName']
                      : 'N/A',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.calendar_month_rounded),
                SizedBox(width: 10),
                Text(
                  widget.type == 'Future' ? 'Starts On' : 'Started On',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  courseData['startDate'] != null
                      ? ' - ${formatDate(courseData['startDate'])}'
                      : ' - N/A',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.calendar_month_rounded),
                SizedBox(width: 10),
                Text(
                  widget.type == 'Past' ? 'Ended On' : 'Ends On',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  courseData['endDate'] != null
                      ? ' - ${formatDate(courseData['endDate'])}'
                      : ' - N/A',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1.5,
            ),
            SizedBox(height: 5),
            Row(
              children: [
                courseData['salePrice'] != null && courseData['salePrice'] != ''
                    ? Row(
                        children: [
                          Text(
                            '₹ ' + courseData['price'] + '/-',
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(width: 25),
                          Text(
                            '₹ ' + courseData['salePrice'] + '/-',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      )
                    : Text(
                        '₹ ' + courseData['price'] + '/-',
                        style: TextStyle(fontSize: 18),
                      )
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CourseDetails(courseData: courseData)),
                    );
                  },
                  child: Text(
                    'Explore',
                    style: GoogleFonts.acme(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.orange, // Set button background to orange
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Add optional rounded corners
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Buy Now',
                    style: GoogleFonts.acme(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.orange, // Set button background to orange
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Add optional rounded corners
                    ),
                  ),
                ),
              ],
            )
          ],
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
                              i += 1) ...[
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

//share icon in course details

//show only those - isPublished = true;
