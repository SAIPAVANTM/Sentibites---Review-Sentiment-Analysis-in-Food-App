import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Urls.dart';

class AddOwnersPage extends StatefulWidget {
  const AddOwnersPage({Key? key}) : super(key: key);

  @override
  _AddOwnersPageState createState() => _AddOwnersPageState();
}

class _AddOwnersPageState extends State<AddOwnersPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  Future<void> submitOwnerData() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String name = nameController.text.trim();
    final String contact = contactController.text.trim();
    final String dob = dobController.text.trim();

    if (email.isEmpty || password.isEmpty || name.isEmpty || contact.isEmpty || dob.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter all fields')),
      );
      return;
    }

    // Email validation: checks if it ends with @gmail.com or another valid domain
    RegExp emailRegEx = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegEx.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    // Contact validation: checks if it's a 10-digit number
    if (contact.length != 10 || !RegExp(r'^\d{10}$').hasMatch(contact)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contact number must be 10 digits')),
      );
      return;
    }

    try {
      String apiUrl = '${Url.Urls}/addownerlogin';

      // Send the data as JSON in a POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
          'contact': contact,
          'dob': dob,
        }),
      );

      // Log the response
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Show success dialog
        _showSuccessDialog();
      } else if (response.statusCode == 409) {
        // Show message if the owner already exists
        final errorResponse = jsonDecode(response.body);
        String message = errorResponse['message'] ?? 'Owner with this email already exists';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } else {
        // Handle other error statuses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add owner: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error connecting to server')),
      );
    }
  }


  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Owner added successfully!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top section with a back button and title
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
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  top: 70,
                  left: 10,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Add Owners',
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.80,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: contactController,
                      decoration: InputDecoration(
                        labelText: 'Contact',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: dobController,
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: submitOwnerData,
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                        minimumSize: Size(350, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
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
