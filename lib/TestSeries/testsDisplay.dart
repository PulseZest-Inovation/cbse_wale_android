import 'package:cbse_wale_android/TestSeries/testDetails.dart';
import 'package:cbse_wale_android/widgets/appBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestsDisplay extends StatefulWidget {
  const TestsDisplay({
    Key? key,
  }) : super(key: key);

  @override
  _TestsDisplayState createState() => _TestsDisplayState();
}

class _TestsDisplayState extends State<TestsDisplay> {
  @override
  void initState() {
    super.initState();
    fetchTestSeries();
  }

  List<Map<String, dynamic>> testsInfo = [];

  Future<void> fetchTestSeries() async {
    final testsCollection = FirebaseFirestore.instance.collection('testSeries');
    final querySnapshot = await testsCollection.get();

    setState(() {
      testsInfo = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
    });
    print(testsInfo);
  }

  Widget buildInfoCard({required Map<String, dynamic> testData}) {
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
            Container(
              height: 30,
              child: Text(
                testData['title'],
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TestDetails(
                                testData: testData,
                              )),
                    );
                  },
                  child: Text(
                    'Solutions',
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TestDetails(
                                testData: testData,
                              )),
                    );
                  },
                  child: Text(
                    'Practice',
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
        appBar: CustomAppBar(text: 'Test Series'),
        body: testsInfo.length == 0
            ? Center(child: Text('No Test Series available'))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int i = 0;
                              i <= testsInfo.length - 1;
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
                                          testData: testsInfo[i])),
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
