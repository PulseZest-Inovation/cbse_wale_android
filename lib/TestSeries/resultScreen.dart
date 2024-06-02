import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/appBar.dart';

class ResultScreen extends StatefulWidget {
  final Map<String, List<int>> selectedOptions;
  final int attempted;
  final int totalQues;
  final Map<String, dynamic> testData;
  final int timeLeft;

  const ResultScreen(
      {Key? key,
      required this.selectedOptions,
      required this.attempted,
      required this.totalQues,
      required this.testData,
      required this.timeLeft})
      : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  double percentage = 0.0;
  String msg = '';
  double score = 0;
  double totalMarks = 0;
  bool isError = false;
  bool isLoading = true;
  String percentString = '';
  int correct = 0;

  void initState() {
    super.initState();
    getScore();
  }

  String formatTime(int remainingSeconds) {
    int hours = (remainingSeconds / 3600).floor();
    int minutes = ((remainingSeconds % 3600) / 60).floor();
    int seconds = remainingSeconds % 60;
    String hrs = hours.toString().padLeft(2, '0');
    String mins = minutes.toString().padLeft(2, '0');
    String secs = seconds.toString().padLeft(2, '0');
    String timeString = '';
    if (hrs != '00') {
      timeString = hrs + ' Hours, ' + mins + ' Minutes, ' + secs + ' Seconds';
    } else if (mins != '00') {
      timeString = mins + 'Minutes, ' + secs + ' Seconds';
    } else {
      timeString = secs + ' Seconds';
    }
    return timeString;
  }

  void getScore() {
    double scoredMarks = 0.0;
    double total = 0.0;
    int correctAns = 0;
    final sectionData = widget.testData['sections'];
    // print('sections = $sectionData');
    // print(sectionData.length);
    for (int i = 0; i < sectionData.length; i++) {
      String sectionName = sectionData[i]['sectionName'];
      final selectedAnswers = widget.selectedOptions[sectionName];
      final correctAnswers = sectionData[i]['questions'];
      // print(selectedAnswers);
      // print(correctAnswers);
      double correctMarks = sectionData[i]['marksPerQues'].toDouble();
      double wrongMarks = sectionData[i]['negativeMarking'].toDouble();
      total += sectionData[i]['totalQuestions'] * correctMarks;
      if (selectedAnswers == null) {
        print("No answers selected for section: $sectionName");
        setState(() {
          isError = true;
        });
        return;
      }

      if (correctAnswers.length != selectedAnswers.length) {
        print(
            "Number of questions and answers don't match for section: $sectionName");
        setState(() {
          isError = true;
        });
        return;
      }

      for (int i = 0; i < correctAnswers.length; i++) {
        if (selectedAnswers[i] != -1) {
          print(
              '$sectionName + $i + ${selectedAnswers[i]} + ${correctAnswers[i]['correctAns']}');
          if (correctAnswers[i]['correctAns'] == selectedAnswers[i]) {
            scoredMarks += correctMarks;
            correctAns++;
          } else {
            scoredMarks -= wrongMarks;
          }
        }
      }
    }
    setState(() {
      correct = correctAns;
      score = scoredMarks;
      totalMarks = total;
      isLoading = false;
      percentage = (score * 100) / totalMarks;
      percentString = percentage.toStringAsFixed(2);
      if (percentage < 40) {
        msg = 'You need to work hard! Focus more on your weak points.';
      } else if (percentage >= 40 && percentage < 70) {
        msg = 'Nice Try! You are making progress.';
      } else {
        msg = 'Excellent! Keep up the great work.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: 'Result',
        value: false,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.black))
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Color(0xFFF57C00),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                'View Solutions',
                                style: GoogleFonts.acme(color: Colors.black),
                              )),
                          SizedBox(height: 10),
                          Text(
                            msg,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Let\'s see how you performed!',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors
                                      .white, // Set background color to white
                                  shape: BoxShape
                                      .circle, // Maintain the circular shape
                                ),
                                child: ClipOval(
                                  child: SizedBox.fromSize(
                                    size: Size.fromRadius(
                                        35.0), // Adjust radius as needed
                                    child: Image.asset(
                                      'assets/icons/high-score.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Column(
                                children: [
                                  Text(
                                    'Score',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    '$score/$totalMarks',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color:
                                  Colors.white, // Set background color to white
                              shape: BoxShape
                                  .circle, // Maintain the circular shape
                            ),
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(
                                    20.0), // Adjust radius as needed
                                child: Image.asset(
                                  'assets/icons/percentage.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            percentString,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text('Percentage')
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color:
                                  Colors.white, // Set background color to white
                              shape: BoxShape
                                  .circle, // Maintain the circular shape
                            ),
                            child: ClipOval(
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(
                                    20.0), // Adjust radius as needed
                                child: Image.asset(
                                  'assets/icons/exam.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            widget.attempted.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text('Attempted')
                        ],
                      ),
                    ],
                  ),
                  if (widget.timeLeft != 0) ...[
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(
                                20.0), // Adjust radius as needed
                            child: Image.asset(
                              'assets/icons/timeLeft.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Time Taken :   ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formatTime(widget.timeLeft),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          ClipOval(
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(
                                  15.0), // Adjust radius as needed
                              child: Image.asset(
                                'assets/icons/correct.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            correct.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text('Correct')
                        ],
                      ),
                      Column(
                        children: [
                          ClipOval(
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(
                                  15.0), // Adjust radius as needed
                              child: Image.asset(
                                'assets/icons/wrong.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            (widget.attempted - correct).toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text('Incorrect')
                        ],
                      ),
                      Column(
                        children: [
                          ClipOval(
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(
                                  15.0), // Adjust radius as needed
                              child: Image.asset(
                                'assets/icons/notDone.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            (widget.totalQues - widget.attempted).toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text('Not Attempted')
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
