import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For encoding the request body
import 'package:sentibites/HomePage/home.dart';

import '../Auth/tools.dart';
import '../Urls.dart';

class adminforgot extends StatefulWidget {
  const adminforgot({super.key});

  @override
  State<adminforgot> createState() => _AdminForgotPasswordPageState();
}

class _AdminForgotPasswordPageState extends State<adminforgot> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Function to handle password reset
  Future<void> resetPassword() async {
    final email = emailController.text.trim();
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showMessage('All fields are required');
      return;
    }

    if (newPassword != confirmPassword) {
      _showMessage('New password and confirmation do not match');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${Url.Urls}/admin/forgot-password'), // Replace with your actual backend URL
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'old_password': oldPassword,
          'new_password': newPassword,
          'confirm_new_password': confirmPassword,
        }),
      );

      if (response.statusCode == 200) {
        _showMessage('Password updated successfully');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminToolPage()), // Replace with the next page after success
        );
      } else {
        final responseData = json.decode(response.body);
        _showMessage(responseData['message'] ?? 'Error occurred');
      }
    } catch (e) {
      _showMessage('Failed to connect to the server');
    }
  }

  // Function to display messages as a snackbar
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
                  top: 65,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous screen
                    },
                  ),
                ),
                // Forgot Password text in the center
                Positioned(
                  top: 70, // Adjust the top value to move it down
                  left: 10,
                  right: 0,
                  child: Center(
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
              ],
            ),
          ),
          // White background container with curved top edges
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.78, // Remaining part
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

                    // Email input field with customized decoration
                    _buildInputField('Email Address', emailController),
                    SizedBox(height: 16),

                    // Old Password input field
                    _buildInputField('Old Password', oldPasswordController, obscureText: true),
                    SizedBox(height: 16),

                    // New Password input field
                    _buildInputField('New Password', newPasswordController, obscureText: true),
                    SizedBox(height: 16),

                    // Confirm New Password input field
                    _buildInputField('Confirm New Password', confirmPasswordController, obscureText: true),
                    SizedBox(height: 40),

                    // Centered Submit button
                    Center(
                      child: ElevatedButton(
                        onPressed: resetPassword,
                        child: Center(child: Text('Submit')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey, // Button color (filled color)
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20), // Adjusted padding
                          minimumSize: Size(300, 50), // Set width and height for the button (adjusted)
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // Rounded corners
                          ),
                          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Adjusted font size and weight
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

  // Helper method to build the input fields
  Widget _buildInputField(String label, TextEditingController controller, {bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(color: Colors.white), // Set text color to white
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
      ],
    );
  }

}
