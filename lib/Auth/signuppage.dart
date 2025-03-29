import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sentibites/Auth/topverification.dart';
import 'package:sentibites/Onboarding/onboardpage1.dart';
import 'package:http/http.dart' as http;
import '../HomePage/home.dart';
import '../Urls.dart';
import 'User_Loginpage.dart';
import 'loginpage.dart';


class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  Future<void> signUpUser() async {
    final validDomains = ['@gmail.com', '@yahoo.com', '@outlook.com', '@hotmail.com'];
    final email = emailController.text.trim();

    // Check if the email ends with a valid domain
    bool isValidDomain = validDomains.any((domain) => email.endsWith(domain));

    if (!isValidDomain) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email must end with @gmail.com, @yahoo.com, or @outlook.com')),
      );
      return;
    }

    // Check if the Date of Birth is in the correct format (DD/MM/YYYY)
    final dob = dobController.text.trim();
    final dobRegex = RegExp(r'^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/\d{4}$');

    if (!dobRegex.hasMatch(dob)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Date of Birth must be in the format DD/MM/YYYY')),
      );
      return;
    }

    // Store user data temporarily
    final Map<String, String> userData = {
      'name': fullNameController.text,
      'email': email,
      'password': passwordController.text,
      'mobilenumber': mobileController.text,
      'dob': dob,
    };

    try {
      // Navigate to OTP verification screen and wait for result
      final bool? verificationResult = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(
            email: email,
            userData: userData,
          ),
        ),
      );

      // If verification was successful, proceed with signup
      if (verificationResult == true) {
        await completeSignup(userData);
      }
    } catch (error) {
      print("Error in signup process: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign up. Please try again later.')),
      );
    }
  }


  Future<void> completeSignup(Map<String, String> userData) async {
    final signupUrl = Uri.parse('${Url.Urls}/signup');
    final adminUrl = Uri.parse('${Url.Urls}/admin/users_post');

    try {
      final signupResponse = await http.post(
        signupUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      print("Response from /signup: ${signupResponse.statusCode}");
      print("Body from /signup: ${signupResponse.body}");

      final adminResponse = await http.post(
        adminUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': userData['name'],
          'email': userData['email'],
          'contact': userData['mobilenumber'],
          'dob': userData['dob'],
        }),
      );

      print("Response from /admin/users_post: ${adminResponse.statusCode}");
      print("Body from /admin/users_post: ${adminResponse.body}");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => userlogin()),
      );
    } catch (error) {
      print("Error in completing signup: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to complete signup. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top yellow background
          Container(
            height: MediaQuery.of(context).size.height * 0.20,
            color: Colors.blueGrey[900],
            child: Stack(
              children: [
                // Back button at the top left corner
                Positioned(
                  left: 5,
                  top: 65,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      // Push the signup page to the stack when the back button is clicked
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => signuppage()),
                      );
                    },
                  ),
                ),
                Positioned(
                  left: 115,
                  top: 70,
                  child: Text(
                    'New Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // White background container with curved top edges
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full Name
                    Text(
                      'Full Name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: fullNameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Email
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Mobile Number
                    Text(
                      'Mobile Number',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: mobileController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Password
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Date of Birth
                    Text(
                      'Date of Birth',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: dobController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Agreement Text
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          text: 'By continuing, you agree to ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print('Terms of Service tapped');
                                },
                            ),
                            TextSpan(
                              text: ' and ',
                              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print('Privacy Policy tapped');
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Sign Up Button
                    Center(
                      child: ElevatedButton(
                        onPressed: signUpUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Login redirection text
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => userlogin()),
                          );
                        },
                        child: Text(
                          'Already have an account? Login here',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}