import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding
import 'package:sentibites/Owner/ownertools.dart'; // Owner tool page
import 'package:sentibites/Auth/forgotpswdpage.dart'; // Forgot password page
import 'package:sentibites/Owner/ownerforgot.dart';

import '../Auth/User_Loginpage.dart';
import '../Urls.dart'; // Owner forgot password page

class OwnerLogin extends StatefulWidget {
  const OwnerLogin({super.key});

  @override
  State<OwnerLogin> createState() => _OwnerLoginState();
}

class _OwnerLoginState extends State<OwnerLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Function to handle login
  // Function to handle login
  Future<void> _checkCredentials() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email and Password cannot be empty')));
      return;
    }

    try {
      // Fetch owner status from /admin/owner-status
      final statusResponse = await http.get(Uri.parse('${Url.Urls}/admin/owner-status'));

      if (statusResponse.statusCode == 200) {
        final List<dynamic> ownerStatusList = json.decode(statusResponse.body);

        // Find the status for the entered email
        final ownerStatus = ownerStatusList.firstWhere(
                (owner) => owner['email'] == email,
            orElse: () => null
        );

        if (ownerStatus == null || ownerStatus['status'] != 'active' && ownerStatus['status'] != 'Active') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Your account is not active. Please contact support.')));
          return;
        }

        // If status is active, check credentials for login
        final response = await http.post(
          Uri.parse('${Url.Urls}/check_credentials'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'email': email, 'password': password}),
        );

        // Check if the response is successful
        if (response.statusCode == 200) {
          // Navigate to the Owntool page if credentials are correct
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => owntool(), // Navigate to Owntool page
            ),
          );
        } else {
          final responseBody = json.decode(response.body);

          if (responseBody['message'] != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseBody['message'])));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unexpected response structure')));
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to fetch owner status.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top section with yellow background and back button
          Container(
            height: MediaQuery.of(context).size.height * 0.20,
            color: Colors.blueGrey[900],
            child: Stack(
              children: [
                Positioned(
                  left: 5,
                  top: 70, // Position the back button as needed
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => signuppage(), // Navigate to SignUpPage
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 75, // Move the "Owner Log In" text lower
                  left: 5,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Owner Log In',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // White background container with rounded corners
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.78,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: const EdgeInsets.all(19.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Welcome Owner!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Log in to explore, review, and understand the sentiments behind every dish you try.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 50),
                    Text(
                      'Email or Mobile Number',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    _buildTextField(emailController, ''),
                    SizedBox(height: 20),
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    _buildTextField(passwordController, '', obscureText: true),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Navigate to forgot password page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ownforgot(),
                            ),
                          );
                        },
                        child: Text('Forgot Password?'),
                      ),
                    ),
                    SizedBox(height: 30),
                    _buildLoginButton(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.yellow[600]!, width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Colors.white), // Set typed text color to white
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white),  // Set hint text color to white
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _checkCredentials,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        child: Text(
          'Log In',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
