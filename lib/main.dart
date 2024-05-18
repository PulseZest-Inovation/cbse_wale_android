import 'package:cbse_wale_android/utils/FirebaseInitializationApp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String message;

    if (user != null) {
      message = 'User ID: ${user.uid}';
    } else {
      message = 'User is not logged in';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Scaffold(
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
