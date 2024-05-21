import 'package:cbse_wale_android/courses/courseList.dart';
import 'package:cbse_wale_android/utils/FirebaseInitializationApp.dart';
import 'package:cbse_wale_android/widgets/colorTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login/checkLogin.dart';
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
      home: CheckLogin(),
    );
  }
}

//bottom - home, notes, study, test, account (pic + email + profile + logout + my courses)
//appbar - user image - profile page, version, downloads, info, support, logout

//pdf - future scope
