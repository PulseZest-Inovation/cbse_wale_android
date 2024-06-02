import 'dart:async';
import 'package:cbse_wale_android/TestSeries/resultScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/appBar.dart';

class GiveTest extends StatefulWidget {
  final Map<String, dynamic> testData;

  const GiveTest({Key? key, required this.testData}) : super(key: key);

  @override
  State<GiveTest> createState() => _GiveTestState();
}

class _GiveTestState extends State<GiveTest> {
  String selectedSection = "";
  int currentQuestion = 1;
  int totalQues = 0;
  List<String> sectionNames = [];
  Map<String, List<int>> quesNumbers = {};
  Map<String, List<int>> selectedOptions = {};
  Map<String, List<int>> visited = {};
  Map<String, List<int>> markedReview = {};
  Map<String, List<dynamic>> questionData = {};
  int time = 0;
  Timer? timer;
  int attempted = 0;
  int notAttempted = 0;
  int visitedEle = 0;
  int notVisitedEle = 0;
  int AnsMarked = 0;
  int MarkedForReview = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getSectionNames();
    questionList();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        time--;
        if (time == 0) {
          timer?.cancel();
          // Handle timer completion (e.g., submit test automatically)
        }
      });
    });
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
      timeString = hrs + ':' + mins + ':' + secs;
    } else {
      timeString = mins + ':' + secs;
    }
    return timeString;
  }

  void calculateValues() async {
    setState(() {
      visited.forEach((sectionName, questions) {
        int count = questions.where((visit) => visit == 1).length;
        visitedEle += count;
      });
      notVisitedEle = totalQues - visitedEle;
      selectedOptions.forEach((sectionName, questions) {
        attempted += questions.where((attempt) => attempt != -1).length;
      });
      notAttempted = totalQues - attempted - notVisitedEle;

      markedReview.forEach((sectionName, questions) {
        for (int i = 0; i < questions.length; i++) {
          if (questions[i] == 1) {
            if (selectedOptions[sectionName]![i] == -1) {
              MarkedForReview++;
            } else {
              AnsMarked++;
            }
          }
        }
      });

      isLoading = false;
    });
  }

  Color getQuestionCircleColor(int i) {
    int start = quesNumbers[selectedSection]![0];
    if (currentQuestion == i) {
      return Colors.white;
    } else {
      if (visited[selectedSection]![i - start] == 1) {
        if (selectedOptions[selectedSection]![i - start] != -1)
          return Colors.green;
        else {
          if (markedReview[selectedSection]![i - start] == 0)
            return Colors.red;
          else
            return Colors.white;
        }
      } else {
        return Colors.orange;
      }
    }
  }

  void getSectionNames() {
    print('test data = ${widget.testData}');
    int end = 0;
    for (int i = 0; i < widget.testData['sections'].length; i++) {
      String name = widget.testData['sections'][i]['sectionName'];
      sectionNames.add(name);
      int nums = widget.testData['sections'][i]['totalQuestions'];
      if (i == 0) {
        quesNumbers[name] = [1, nums];
      } else {
        quesNumbers[name] = [end + 1, end + nums];
      }
      end = widget.testData['sections'][i]['totalQuestions'] + end;
      setState(() {
        selectedOptions[name] = List.generate(nums, (index) => -1);
        visited[name] = List.generate(nums, (index) => 0);
        markedReview[name] = List.generate(nums, (index) => 0);
        totalQues = widget.testData['totalQuestions'];
        time = widget.testData['totalTime'] * 60;
      });
    }

    // print(quesNumbers);

    setState(() {
      selectedSection = sectionNames[0];
    });
  }

  void questionList() {
    for (int i = 0; i < widget.testData['sections'].length; i++) {
      questionData[widget.testData['sections'][i]['sectionName']] =
          widget.testData['sections'][i]['questions'];
    }
    // print('question dataaaaa ==== $questionData');
  }

  Widget buildQuestion(int start, int quesNum, String sectionName) {
    // print('quesnum = ' + quesNum.toString());
    // print('start = ' + start.toString());
    Map<String, dynamic> mp = questionData[sectionName]?[quesNum - start];
    setState(() {
      visited[sectionName]![quesNum - start] = 1;
      // visitedEle += 1;
    });
    // print(visited);
    // print(selectedOptions);
    // print(markedReview);
    int selectedOption = selectedOptions[selectedSection]![quesNum - start];
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Text(mp['question'], style: const TextStyle(fontSize: 16.0)),
            const SizedBox(height: 10.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: mp['options'].length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(mp['options'][index]),
                  leading: Radio(
                    value: index,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOptions[selectedSection]![quesNum - start] =
                            value as int;
                        // if(selectedOptions[selectedSection]![quesNum - start]!=-1) {
                        //   attempted += 1;
                        // }
                        selectedOption = value;
                      });
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        text: widget.testData['title'],
        value: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  formatTime(time),
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectedSection,
                    items: sectionNames
                        .map<DropdownMenuItem<String>>(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Container(
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        e,
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedSection = value ?? '';
                        //first unvisited question of new section
                        currentQuestion = quesNumbers[selectedSection]![0]; // +
                        // visited[selectedSection]!.indexWhere((visit) => visit == 1);
                      });
                      // print(value);
                    }, // Use the callback function
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    if (markedReview[selectedSection]![currentQuestion -
                            quesNumbers[selectedSection]![0]] ==
                        0) {
                      markedReview[selectedSection]![currentQuestion -
                          quesNumbers[selectedSection]![0]] = 1;
                    } else
                      markedReview[selectedSection]![currentQuestion -
                          quesNumbers[selectedSection]![0]] = 0;
                    setState(() {});
                  },
                  icon: Icon(
                    markedReview[selectedSection]![currentQuestion -
                                quesNumbers[selectedSection]![0]] ==
                            0
                        ? Icons.star
                        : Icons.star_border_rounded,
                    color: Colors.white,
                  ),
                  label: Text(
                    markedReview[selectedSection]![currentQuestion -
                                quesNumbers[selectedSection]![0]] ==
                            0
                        ? "Mark for Review"
                        : "Unmark for review",
                    style: GoogleFonts.acme(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.orange, // Set button background to orange
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                    'Marks Per Question: + ${widget.testData['sections'][widget.testData['sections'].indexWhere((section) => section['sectionName'] == selectedSection)]['marksPerQues'].toString()}'),
                Text(
                    'Negative Marking: - ${widget.testData['sections'][widget.testData['sections'].indexWhere((section) => section['sectionName'] == selectedSection)]['negativeMarking'].toString()}'),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int i = quesNumbers[selectedSection]![0];
                      i <= quesNumbers[selectedSection]![1];
                      i++) ...[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          currentQuestion = i;
                        });
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: getQuestionCircleColor(i),
                            ),
                            child: Center(
                              child: Text(
                                i.toString(),
                                style: TextStyle(
                                    color: currentQuestion == i ||
                                            (markedReview[selectedSection]![i -
                                                        quesNumbers[
                                                                selectedSection]![
                                                            0]] ==
                                                    1 &&
                                                selectedOptions[
                                                            selectedSection]![
                                                        i -
                                                            quesNumbers[
                                                                    selectedSection]![
                                                                0]] ==
                                                    -1)
                                        ? Colors.orange
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0.0,
                            right: 0.0,
                            child: markedReview[selectedSection]![
                                        i - quesNumbers[selectedSection]![0]] ==
                                    1
                                ? Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.indigo,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.star_rounded,
                                      size: 12.0,
                                      color: Colors.orange,
                                    ))
                                : SizedBox(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                  ]
                ],
              ),
            ),
            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 10),
            buildQuestion(quesNumbers[selectedSection]![0], currentQuestion,
                selectedSection),
            // Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (currentQuestion > 1)
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        if (currentQuestion >
                            quesNumbers[selectedSection]![0]) {
                          currentQuestion--;
                        } else {
                          int selectedSectionIndex =
                              sectionNames.indexOf(selectedSection);
                          if (selectedSectionIndex > 0) {
                            selectedSection =
                                sectionNames[selectedSectionIndex - 1];
                            currentQuestion = quesNumbers[selectedSection]![1];
                          }
                        }
                      });
                    },
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Previous",
                      style: GoogleFonts.acme(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.orange, // Set button background to orange
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ElevatedButton.icon(
                  onPressed: () => setState(() =>
                      selectedOptions[selectedSection]![currentQuestion -
                          quesNumbers[selectedSection]![0]] = -1),
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Clear",
                    style: GoogleFonts.acme(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.orange, // Set button background to orange
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    setState(() {
                      if (currentQuestion == totalQues) {
                        calculateValues();
                        isLoading
                            ? Center(child: CircularProgressIndicator())
                            : showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    surfaceTintColor: Colors.orange,
                                    title: Text('Submit Test'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Do you want to submit the test?'),
                                        SizedBox(height: 20),
                                        Container(
                                          height: 100,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Column(children: [
                                                  Text('Attempted'),
                                                  Text('Unattempted'),
                                                  Text('Marked for Review'),
                                                  Text(
                                                      'Ans & Marked for Review'),
                                                  Text('Not Visited'),
                                                ]),
                                                const VerticalDivider(
                                                  color: Colors.black,
                                                ),
                                                SizedBox(width: 10),
                                                Column(children: [
                                                  Text(attempted.toString()),
                                                  Text(notAttempted.toString()),
                                                  Text(MarkedForReview
                                                      .toString()),
                                                  Text(AnsMarked.toString()),
                                                  Text(
                                                      notVisitedEle.toString()),
                                                ]),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                          setState(() {
                                            attempted = 0;
                                            notAttempted = 0;
                                            notVisitedEle = 0;
                                            visitedEle = 0;
                                            AnsMarked = 0;
                                            MarkedForReview = 0;
                                          });
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ResultScreen(
                                                selectedOptions: selectedOptions,
                                                attempted: attempted,
                                                totalQues: totalQues,
                                                testData: widget.testData,
                                                timeLeft: widget.testData['totalTime'] * 60 - time,
                                              ),
                                            ),
                                                (route) => false, // This will remove all the previous routes
                                          );
                                          timer?.cancel();
                                          timer = null;
                                        },

                                        child: Text(
                                          'Submit',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ).then((value) => {
                                  setState(() {
                                    attempted = 0;
                                    notAttempted = 0;
                                    notVisitedEle = 0;
                                    visitedEle = 0;
                                    AnsMarked = 0;
                                    MarkedForReview = 0;
                                  }),
                                  if (value == true)
                                    {
                                      // Handle test submission logic (e.g., call an API)
                                    }
                                });
                      } else if (currentQuestion <
                          quesNumbers[selectedSection]![1]) {
                        currentQuestion++;
                      } else {
                        int selectedSectionIndex =
                            sectionNames.indexOf(selectedSection);
                        if (selectedSectionIndex < selectedSection.length - 1) {
                          selectedSection =
                              sectionNames[selectedSectionIndex + 1];
                          currentQuestion = quesNumbers[selectedSection]![0];
                        }
                      }
                    });
                  },
                  icon: Icon(
                    currentQuestion == totalQues
                        ? Icons.check_box_rounded
                        : Icons.arrow_forward_rounded,
                    color: Colors.white,
                  ),
                  label: Text(
                    currentQuestion == totalQues ? "Submit" : "Next",
                    style: GoogleFonts.acme(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.orange, // Set button background to orange
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
