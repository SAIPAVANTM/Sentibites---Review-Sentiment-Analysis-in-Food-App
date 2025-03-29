import 'package:flutter/material.dart';
import 'package:sentibites/Auth/User_Loginpage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to User_SignupPage after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => signuppage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[700], // Set background color to yellow
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/cro.png', // Replace with your image path
              height: 250, // Adjust size as needed
            ),
            SizedBox(height: 20), // Space between image and text
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '',
                    style: TextStyle(
                      fontSize: 32, // Adjust text size as needed
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // "SENTI" in yellow
                    ),
                  ),
                  TextSpan(
                    text: '',
                    style: TextStyle(
                      fontSize: 32, // Adjust text size as needed
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // "BITES" in white
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
