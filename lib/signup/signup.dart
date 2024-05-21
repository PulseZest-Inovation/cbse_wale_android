import 'package:cbse_wale_android/signup/verifyEmail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/customFlutterToast.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  User? currentUser = FirebaseAuth.instance.currentUser;

  bool _showPassword = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<bool> isEmailInUse(String email) async {
    // Check if username or email is already in use in other documents
    QuerySnapshot emailQuery = await FirebaseFirestore.instance
        .collection('students')
        .where('email', isEqualTo: email)
        .get();
    return emailQuery.docs.isNotEmpty;
  }

  bool isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  bool isValidPhoneNumber(String phone) {
    final RegExp phoneRegExp = RegExp(r'^\d{10}$');
    return phoneRegExp.hasMatch(phone);
  }

  void _signup(BuildContext context) async {
    final String name = _nameController.text.trim();
    final String phone = _phoneController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (name.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty) {
      ToastUtil.showToast(
        message: "All the fields are required!",
        fontSize: 18.0,
      );
    } else {
      try {
        // Validate email format
        if (!isValidEmail(email)) {
          ToastUtil.showToast(
            message: "Invalid email format",
            fontSize: 18.0,
          );
          return;
        }

        // Validate mobile number format
        if (!isValidPhoneNumber(phone)) {
          ToastUtil.showToast(
            message: "Phone number should contain 10 digits",
            fontSize: 18.0,
          );
          return;
        }

        if (await isEmailInUse(email)) {
          ToastUtil.showToast(
            message: "Email is already in use",
            fontSize: 18.0,
          );
        }

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => Center(
            child: Container(
                height: 50, width: 50, child: CircularProgressIndicator()),
          ),
        );

        // Create user with email and password
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // Access the user object from userCredential
        User? user = userCredential.user;
        Timestamp curr = Timestamp.now();

        if (user != null) {
          // Add user data to Firestore
          await FirebaseFirestore.instance
              .collection('students')
              .doc(user.uid)
              .set({
            'name': name,
            'phone': phone,
            'email': email,
            'createdAt': curr,
          });

          ToastUtil.showToast(
            message: "Account Creation Successful!",
            fontSize: 18.0,
          );

          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => VerifyEmailPage(),
            ),
          );
        } else {
          ToastUtil.showToast(
            message: "Failed to create user",
            fontSize: 18.0,
          );
          Navigator.pop(context); // Dismiss loading indicator
        }
      } catch (e) {
        // Handle errors
        ToastUtil.showToast(
          message: "Something went wrong : $e",
          fontSize: 18.0,
        );

        print("Error: $e");
        Navigator.pop(context); // Dismiss loading indicator
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200], // Greyish background
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                Column(
                  children: [
                    Text(
                      'Create an Account!',
                      style: GoogleFonts.acme(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person),
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
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Contact Number',
                          prefixIcon: Icon(Icons.phone),
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
                      onPressed: () async {
                        _signup(context);
                      },
                      child: Text(
                        'Signup',
                        style: GoogleFonts.acme(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ],
                ),
                // ),
                SizedBox(height: 20),
                Divider(
                  thickness: 1.5,
                ),
                TextButton(
                  onPressed: () {
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Navigator.pop(context);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: GoogleFonts.acme(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '  Login',
                        style: GoogleFonts.acme(
                          color: Colors.orange,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
