import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sentibites/HomePage/home.dart';
import '../Urls.dart';
import 'ownertools.dart';

class ownforgot extends StatefulWidget {
  const ownforgot({super.key});

  @override
  State<ownforgot> createState() => _OwnerForgotPasswordPageState();
}

class _OwnerForgotPasswordPageState extends State<ownforgot> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> resetPassword() async {
    final String apiUrl = '${Url.Urls}/owner/forgot-password';  // Replace with your actual API URL

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': emailController.text,
        'old_password': oldPasswordController.text,
        'new_password': newPasswordController.text,
        'confirm_new_password': confirmPasswordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // If the password reset is successful, navigate to 'owntool' page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => owntool()),
      );
    } else {
      // If the response is not successful, show the error message
      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'] ?? 'An error occurred')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top blue background with back button
          Container(
            height: MediaQuery.of(context).size.height * 0.20, // Adjust top height
            color: Colors.blueGrey[900], // Blue color for the top section
            child: Stack(
              children: [
                // Back button at the top left corner
                Positioned(
                  left: 5,
                  top: 70,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous screen
                    },
                  ),
                ),
                // Forgot Password text in the center with padding
                Positioned(
                  left: 15,
                  top: 37,
                  right: 0, // Increase this value to move the text further down
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0), // Add some padding to move the text down
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 24, // H2 size
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
              height: MediaQuery.of(context).size.height * 0.75, // Remaining part
              decoration: BoxDecoration(
                color: Colors.white, // White background color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), // Curved top-left corner
                  topRight: Radius.circular(50), // Curved top-right corner
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome and additional text
                    SizedBox(height: 0), // Space to align with the top background
                    Text(
                      'Please enter your new password to continue.',
                      style: TextStyle(
                        fontSize: 15, // Smaller size
                        fontWeight: FontWeight.normal, // Not bold
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 50), // Space between text and fields

                    // Email label outside the input field
                    Text(
                      'Email Address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    SizedBox(height: 8), // Space between label and input field

                    // Email input field with customized decoration
                    TextField(
                      controller: emailController,
                      style: TextStyle(color: Colors.white), // Text color set to white
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black, // Brighter blue color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30), // Curved corners
                          borderSide: BorderSide.none, // Remove the border outline
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent), // Transparent border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent), // Transparent border
                        ),
                      ),
                    ),
                    SizedBox(height: 16), // Space between input fields

                    // Old Password label outside the input field
                    Text(
                      'Old Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    SizedBox(height: 8), // Space between label and input field

                    // Old Password input field with customized decoration
                    TextField(
                      controller: oldPasswordController,
                      obscureText: true,
                      style: TextStyle(color: Colors.white), // Text color set to white
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black, // Brighter blue color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30), // Curved corners
                          borderSide: BorderSide.none, // Remove the border outline
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent), // Transparent border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent), // Transparent border
                        ),
                      ),
                    ),
                    SizedBox(height: 16), // Space between input fields

                    // New Password label outside the input field
                    Text(
                      'New Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    SizedBox(height: 8), // Space between label and input field

                    // New Password input field with customized decoration
                    TextField(
                      controller: newPasswordController,
                      obscureText: true,
                      style: TextStyle(color: Colors.white), // Text color set to white
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black, // Brighter blue color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30), // Curved corners
                          borderSide: BorderSide.none, // Remove the border outline
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent), // Transparent border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent), // Transparent border
                        ),
                      ),
                    ),
                    SizedBox(height: 16), // Space between input fields

                    // Confirm Password label outside the input field
                    Text(
                      'Confirm New Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                    SizedBox(height: 8), // Space between label and input field

                    // Confirm Password input field with customized decoration
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      style: TextStyle(color: Colors.white), // Text color set to white
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black, // Brighter blue color
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30), // Curved corners
                          borderSide: BorderSide.none, // Remove the border outline
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent), // Transparent border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.transparent), // Transparent border
                        ),
                      ),
                    ),
                    SizedBox(height: 32), // Space before the button

                    // Reset Password button
                    Center(
                      child: ElevatedButton(
                        onPressed: resetPassword,
                        child: Text('Reset Password'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[900],
                          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
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
