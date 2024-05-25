import 'package:cbse_wale_android/widgets/appBar.dart';
import 'package:cbse_wale_android/widgets/sideBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: CustomAppBar(text: 'Details'),
        drawer: SideBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Notes",
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
                                DetailsTab(courseData: widget.courseData),
                                SyllabusTab(courseData: widget.courseData),
                                NotesTab(),
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

class DetailsTab extends StatefulWidget {
  final Map<String, dynamic> courseData;
  const DetailsTab({
    Key? key,
    required this.courseData,
  }) : super(key: key);

  @override
  State<DetailsTab> createState() => _DetailsTabState();
}

class _DetailsTabState extends State<DetailsTab>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<int>? _studentEnrolledAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000), // Adjust duration as needed
      vsync: this,
    );

    int studentCount;
    try {
      studentCount = widget.courseData['studentsEnrolled'];
    } catch (e) {
      // Handle parsing error (e.g., print message)
      studentCount = 0;
    }

    _studentEnrolledAnimation = IntTween(begin: 0, end: studentCount)
        .animate(_controller!.drive(CurveTween(curve: Curves.easeInOut)));

    _controller!.forward();

    // Optional: Print initial values for debugging
    debugPrint('Student count: $studentCount');
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final teacherName = widget.courseData['teacher'] ?? 'N/A';
    final courseDuration = widget.courseData['duration'] ?? 'N/A';
    final courseValidity = 'Till Examination';
    final rating = widget.courseData['totalRating'];
    final ratingCount = widget.courseData['ratingCount'];
    final averageRating = rating / ratingCount;
    final avgDouble = averageRating.toDouble();
    final ratingFinal = avgDouble.toStringAsFixed(1);

    final studentsEnrolled = widget.courseData['studentsEnrolled'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Teacher Name:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            Text(
              teacherName,
              style: TextStyle(fontSize: 15.0),
            ),
            SizedBox(height: 20.0),
            const Divider(
              thickness: 1.5,
            ),
            SizedBox(height: 10.0),
            Text(
              'About this Course:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.access_time, size: 20.0),
                SizedBox(width: 5.0),
                Text(
                  'Duration: $courseDuration',
                  style: TextStyle(fontSize: 15.0),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 20.0),
                SizedBox(width: 5.0),
                Text(
                  'Validity: $courseValidity',
                  style: TextStyle(fontSize: 15.0),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.star, size: 20.0, color: Colors.amber),
                SizedBox(width: 5.0),
                Text(
                  'Rating: $ratingFinal',
                  style: TextStyle(fontSize: 15.0),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            const Divider(
              thickness: 1.5,
            ),
            SizedBox(height: 10.0),
            Text(
              'Students Enrolled:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            AnimatedBuilder(
              animation: _controller!,
              builder: (context, child) => Text(
                _studentEnrolledAnimation!.value.toInt().toString(),
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SyllabusTab extends StatelessWidget {
  final Map<String, dynamic> courseData;
  const SyllabusTab({
    Key? key,
    required this.courseData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: courseData['chapters'].length,
        itemBuilder: (context, index) {
          final chapter = courseData['chapters'][index];
          return ExpansionTile(
            title: Text(chapter['name']),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: chapter['topics'].length,
                itemBuilder: (context, topicIndex) {
                  final topic = chapter['topics'][topicIndex];
                  return ListTile(
                    title: Text(topic['name']),
                    onTap: () => _showVideoList(context, topic['videos']),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showVideoList(BuildContext context, List videos) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Videos',
            style: TextStyle(fontSize: 20),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: videos.length,
            itemBuilder: (context, videoIndex) {
              final video = videos[videoIndex];
              return ListTile(
                title: Text(video['description']),
                onTap: () => Navigator.pop(context),
              );
            },
          ),
        ],
      ),
    );
  }
}

class NotesTab extends StatelessWidget {
  const NotesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

//details - course duration, validity - till examination, rating, students enrolled till now
//teacher, about this course
//notes - pdfs
