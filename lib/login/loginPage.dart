import 'package:cbse_wale_android/signup/signup.dart';
import 'package:cbse_wale_android/widgets/bottomNavigationBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../signup/verifyEmail.dart';
import '../widgets/colorTheme.dart';
import '../widgets/customFlutterToast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showPassword = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  Future _login(BuildContext cont) async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ToastUtil.showToast(
        message: "Both the fields are required!",
        fontSize: 18.0,
      );
    } else {
      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => Center(
            child: Container(
                height: 50, width: 50, child: CircularProgressIndicator()),
          ),
        );

        UserCredential userCredential;

        if (isValidEmail(email)) {
          print('email is valid');
          userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('students')
              .where('email', isEqualTo: email)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            final User? firebaseUser = userCredential.user;
            print(firebaseUser?.uid);
            print(firebaseUser?.emailVerified);
            print(firebaseUser?.email);

            if (firebaseUser != null && firebaseUser.emailVerified) {
              DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
                  .collection('students')
                  .doc(firebaseUser.uid)
                  .get();

              Map<String, dynamic> userData =
                  userSnapshot.data() as Map<String, dynamic>;
              // User is eligible to login
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('userId', firebaseUser.uid);
              prefs.setString('name', userData['name']);
              prefs.setString('email', userData['email']);
              prefs.setString('phone', userData['phone']);
              print("Login successful");

              ToastUtil.showToast(message: "Login Successful", fontSize: 18.0);
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => BottomBar(),
                ),
              );
            } else {
              print('Email not verified!');
              Navigator.pop(context);
              ToastUtil.showToast(
                  message: 'Please verify your email before logging in!',
                  fontSize: 18.0);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => VerifyEmailPage(),
                ),
              );
            }
          } else {
            print('User not found!');
            Navigator.pop(context);
            ToastUtil.showToast(
                message:
                    'User not found! Check the entered username/email and password.',
                fontSize: 18.0);
          }
        } else {
          Navigator.pop(context);
          ToastUtil.showToast(
              message: 'Invalid Email! Please check again.', fontSize: 18.0);
        }
      } catch (e) {
        // Handle any errors
        print('Error logging in: $e');
        Navigator.pop(context);
        ToastUtil.showToast(
            message: 'Something went wrong : $e.', fontSize: 18.0);
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication? googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Check if user already exists in Firebase based on email
        final String userEmail = googleUser.email;
        final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
            await FirebaseFirestore.instance
                .collection('students')
                .doc(userEmail)
                .get();

        if (docSnapshot.exists) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => Center(
              child: Container(
                  height: 50, width: 50, child: CircularProgressIndicator()),
            ),
          );

          final Map<String, dynamic> studentData = docSnapshot.data()!;
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userId', docSnapshot.reference.id);
          prefs.setString('name', studentData['name'] ?? '');
          prefs.setString('email', studentData['email']);
          prefs.setString('phone', studentData['phone'] ?? '');
          print("Login successful");

          ToastUtil.showToast(message: "Login Successful", fontSize: 18.0);
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => BottomBar(),
            ),
          );
          return;
        }

        // If user doesn't exist, create a new document with name and email
        final String documentId = userCredential.user!.uid;

        final Map<String, dynamic> studentData = {
          'name': googleUser.displayName ?? '',
          'email': userEmail,
          'mobileNumber': '',
        };
        await FirebaseFirestore.instance
            .collection('students')
            .doc(documentId)
            .set(studentData);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userId', documentId);
        prefs.setString('name', googleUser.displayName ?? '');
        prefs.setString('email', userEmail);
        prefs.setString('phone', '');
        print("Login successful");

        ToastUtil.showToast(message: "Login Successful", fontSize: 18.0);
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => BottomBar(),
          ),
        );

        return;
      } else {
        print('User did not sign in with Google');
        return null;
      }
    } on Exception catch (e) {
      print('Exception during sign-in: $e');
      ToastUtil.showToast(
          message: "Something went wrong : $e!", fontSize: 18.0);
      return;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 80),
                CircleAvatar(
                  radius: 80.0,
                  backgroundColor: Colors.grey,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/icons/bell.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "Welcome to CBSE WALE",
                  style: GoogleFonts.acme(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail),
                      contentPadding: EdgeInsets.all(16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_showPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.all(16.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _login(context);
                  },
                  child: Text(
                    'Login',
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
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SignUpPage(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New User?   ',
                        style: GoogleFonts.acme(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Register Now!',
                        style: GoogleFonts.acme(
                          fontSize: 18.0,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'or sign in with',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await signInWithGoogle();
                          // Handle successful sign-in (e.g., navigate to a different screen)
                          print('Sign-in successful!');
                        } on Exception catch (e) {
                          print('Sign-in failed: $e');
                          // Show an error message to the user (e.g., using SnackBar)
                        }
                      },
                      child: FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.white, // Set icon color to white
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//TODO: if successful login, set login var in database to true and check its value while logging in

// slider ki jagah logo
// email password
//register option
