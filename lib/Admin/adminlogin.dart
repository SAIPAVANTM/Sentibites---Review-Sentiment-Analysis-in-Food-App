import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sentibites/Admin/forgot.dart';
import 'package:sentibites/Auth/User_Loginpage.dart';
import 'package:sentibites/Auth/tools.dart';

import '../Urls.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false; // State for loading indicator

  Future<void> loginAdmin(BuildContext context) async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar(context, 'Email and password are required');
      return;
    }

    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      final response = await http.post(
        Uri.parse('${Url.Urls}/admin/login'), // Replace with your backend URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Login successful
        _showSnackbar(context, responseData['message']);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminToolPage(), // Navigate to the admin tools page
          ),
        );
      } else {
        // Login failed
        _showSnackbar(context, responseData['message'] ?? 'Login failed');
      }
    } catch (e) {
      _showSnackbar(context, 'An error occurred: $e');
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
                  top: 65,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => signuppage(),
                        ),
                      );
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 27, left: 10),
                    child: Text(
                      'Admin Log In',
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
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 0),
                    Text(
                      'Welcome, Admin',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Log in to explore, review, and understand the users and the owners of the application.',
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => adminforgot(),
                            ),
                          );
                        },
                        child: Text('Forgot Password?'),
                      ),
                    ),
                    SizedBox(height: 30),
                    _buildLoginButton(context),
                    if (isLoading)
                      Center(
                        child: CircularProgressIndicator(),
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

  Widget _buildTextField(TextEditingController controller, String hintText, {bool obscureText = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.yellow[600]!, width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
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
        onPressed: () => loginAdmin(context),
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
