import 'package:cbse_wale_android/courses/courseList.dart';
import 'package:cbse_wale_android/profile.dart';
import 'package:cbse_wale_android/utils/FirebaseInitializationApp.dart';
import 'package:cbse_wale_android/widgets/colorTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login/loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: AppColors.primary,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: AppColors.text), // Text color
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: InfoPage(),
      // LoginPage(),
    );
  }
}
