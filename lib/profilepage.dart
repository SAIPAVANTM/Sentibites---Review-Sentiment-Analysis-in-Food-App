import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'HomePage/home.dart';
import 'Urls.dart';
import 'analysis/analysispage.dart';
import 'items/itemspage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "Loading...";
  String dob = "Loading...";
  String email = "Loading...";
  String mobileNumber = "Loading...";
  TextEditingController nameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    String apiUrl = '${Url.Urls}/get_last_user'; // Replace with your server's IP or URL
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          name = data['name'];
          dob = data['dob'];
          email = data['email'];
          mobileNumber = data['mobile_number'];
        });
      } else {
        setState(() {
          name = "Error fetching data";
          dob = "Error fetching data";
          email = "Error fetching data";
          mobileNumber = "Error fetching data";
        });
      }
    } catch (e) {
      setState(() {
        name = "Failed to fetch data";
        dob = "Failed to fetch data";
        email = "Failed to fetch data";
        mobileNumber = "Failed to fetch data";
      });
    }
  }

  Future<void> updateUserData() async {
    String apiUrl = '${Url.Urls}/update_user'; // Update URL
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'name': nameController.text.isNotEmpty ? nameController.text : name,
          'dob': dobController.text.isNotEmpty ? dobController.text : dob,
          'mobile_number': mobileController.text.isNotEmpty
              ? mobileController.text
              : mobileNumber,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
        fetchUserData(); // Reload the updated data
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top yellow background with My Profile title
          Container(
            height: MediaQuery.of(context).size.height * 0.20, // Top 20% height
            color: Colors.blueGrey[900], // Yellow color for the top section
            child: Stack(
              children: [
                // Back button at the top left corner
                Positioned(
                  left: 5,
                  top: 50,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous screen
                    },
                  ),
                ),
                // "My Profile" text in the center
                Center(
                  child: Text(
                    'My Profile',
                    style: TextStyle(
                      fontSize: 24, // H2 size
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // White background container with curved top edges for profile content
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75, // Remaining part
              decoration: BoxDecoration(
                color: Colors.white, // White background color for profile content
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
                    // Profile picture section
                    Center(
                      child: ClipOval(
                        child: Image.asset(
                          'assets/happy.jpg', // Replace with your image path
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Space between the profile picture and name

                    // Full Name section aligned to the left
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Full Name', // User's name or placeholder text
                        style: TextStyle(
                          fontSize: 16, // Same size as the user info fields
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900], // Change color to black
                        ),
                      ),
                    ),
                    SizedBox(height: 10), // Space between name and yellow box

                    // Yellow box with the name of the user
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[350], // Yellow color for the box
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      child: Center(
                        child: Text(
                          name, // Display user name
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Space between yellow box and next fields

                    // Date of Birth section
                    _buildUserInfoField('Date of Birth', dob, dobController),

                    // Email section
                    _buildUserInfoField('Email', email, TextEditingController()),

                    // Phone number section
                    _buildUserInfoField('Phone Number', mobileNumber, mobileController),

                    SizedBox(height: 30), // Space between fields
                  ],
                ),
              ),
            ),
          ),

          // Positioned Edit icon button at the bottom center
          Positioned(
            bottom: 0, // Adjust the space from the bottom
            left: MediaQuery.of(context).size.width * 0.42, // Center horizontally
            child: IconButton(
              icon: Icon(
                Icons.edit, // Edit icon
                size: 40, // Icon size
                color: Colors.grey, // Icon color (yellow)
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Edit Profile'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: nameController..text = name,
                            decoration: InputDecoration(labelText: 'Full Name'),
                          ),
                          TextField(
                            controller: dobController..text = dob,
                            decoration: InputDecoration(labelText: 'Date of Birth'),
                          ),
                          TextField(
                            controller: mobileController..text = mobileNumber,
                            decoration: InputDecoration(labelText: 'Phone Number'),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            updateUserData();
                            Navigator.pop(context);
                          },
                          child: Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[900],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
              SizedBox(width: 60),
              IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Items()),
                  );
                },
              ),
              SizedBox(width: 60),
              IconButton(
                icon: Icon(Icons.favorite, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => analy1()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for building user info fields
  Widget _buildUserInfoField(String label, String value, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, // Label for the field (e.g., Date of Birth, Email, etc.)
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              value, // The value of the field (e.g., date, email, phone)
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
