import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/loginPage.dart';
import '../widgets/customFlutterToast.dart';

class LogoutFxn extends StatelessWidget {
  static void logout(BuildContext context) async {
    try {
      // Retrieve the current user from Firebase Authentication
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Sign out from Firebase
        await FirebaseAuth.instance.signOut();
        print('User signed out successfully');

        prefs.clear();

        ToastUtil.showToast(
          message: "Logged out successfully!",
          fontSize: 18.0,
        );

        // Navigate to the login screen
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    LoginPage())); // Replace with your login route
      } else {
        print('Document not found');
      }
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
