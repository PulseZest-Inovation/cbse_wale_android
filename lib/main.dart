import 'package:cbse_wale_android/utils/FirebaseInitializationApp.dart';
import 'package:cbse_wale_android/widgets/colorTheme.dart';
import 'package:flutter/material.dart';
import 'login/checkLogin.dart';

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
