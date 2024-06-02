import 'package:cbse_wale_android/TestSeries/giveTest.dart';
import 'package:cbse_wale_android/widgets/appBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/customFlutterToast.dart';

class TestDetails extends StatefulWidget {
  final Map<String, dynamic> testData;

  const TestDetails({Key? key, required this.testData}) : super(key: key);

  @override
  State<TestDetails> createState() => _TestDetailsState();
}

class _TestDetailsState extends State<TestDetails> {
  @override
  void initState() {
    super.initState();
  }

  bool isChecked = false;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Total Questions:',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 15.0),
                        Text(
                          widget.testData['totalQuestions'].toString() ??
                              'Not specified',
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Total time (in mins):',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 15.0),
                        Text(
                          '${widget.testData['totalTime'].toString()} mins' ??
                              'Not specified',
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    // Table for sections
                    Table(
                      border: TableBorder.all(color: Colors.grey, width: 1.0),
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Center(
                                child: Text(
                                  'Sections',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Text(
                                  'Total Questions',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Text(
                                  'Negative Marking',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Text(
                                  'Time (in mins)',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Text(
                                  'Marks Per Question',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Create table rows for each section
                        ...widget.testData['sections']
                            .map((section) => _buildSectionTableRow(section))
                      ],
                    ),
                    SizedBox(height: 40.0),
                    Text(
                      'General Instructions:',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      widget.testData['generalInstructions'] ??
                          'No instructions provided.',
                      softWrap: true,
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 40.0),
                    Row(
                      children: [
                        Text(
                          'Language:',
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 15.0),
                        Text(
                          widget.testData['language'] ?? 'Not specified',
                        ),
                      ],
                    ),
                    SizedBox(height: 40.0),
                    Row(
                      children: [
                        Checkbox(
                          value: isChecked,
                          onChanged: (value) =>
                              setState(() => isChecked = value!),
                        ),
                        Expanded(
                          child: Text(
                            'I have read and understood the instructions. I agree that in case of not adhering to the exam instructions, I will be disqualified.',
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            // Spacer(), // Add space to push content up
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  if (isChecked)
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GiveTest(
                                testData: widget.testData,
                              )),
                    );
                  else
                    ToastUtil.showToast(message: 'Check the above checkbox!');
                },
                child: Text(
                  'Start Test',
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
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildSectionTableRow(Map<String, dynamic> section) {
    return TableRow(
      children: [
        TableCell(
          child: Center(
            child: Text(section['sectionName'] ?? 'N/A'),
          ),
        ),
        TableCell(
          child: Center(
            child: Text(section['totalQuestions'].toString()),
          ),
        ),
        TableCell(
          child: Center(
            child: Text(section['negativeMarking']?.toString() ?? 'N/A'),
          ),
        ),
        TableCell(
          child: Center(
            child: Text(section['time'].toString()),
          ),
        ),
        TableCell(
          child: Center(
            child: Text(section['marksPerQues'].toString()),
          ),
        ),
      ],
    );
  }
}
