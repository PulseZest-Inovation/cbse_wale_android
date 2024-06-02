import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyB3Eegjf1x3aRISpSXD6Gdv25XdUVA8RmA",
        authDomain: "cbse-wale-4f2a9.firebaseapp.com",
        projectId: "cbse-wale-4f2a9",
        storageBucket: "cbse-wale-4f2a9.appspot.com",
        messagingSenderId: "804819670609",
        appId: "1:804819670609:web:9c14433840bf14910d0a70",
        measurementId: "G-LVWM1EW4GZ",

    ),

  );

  print("Firebase Initialized");

}
