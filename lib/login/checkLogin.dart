import 'package:cbse_wale_android/courses/courseList.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginPage.dart';

class CheckLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _checkUserStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          final bool isLoggedIn = snapshot.data?['isLoggedIn'] ?? false;
          if (isLoggedIn) {
            return CourseList();
          } else {
            return LoginPage();
          }
        }
      },
    );
  }

  Future<Map<String, dynamic>> _checkUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');
    if (userId != null && userId.isNotEmpty) {
      return {'isLoggedIn': true};
    } else {
      return {'isLoggedIn': false};
    }
  }
}
