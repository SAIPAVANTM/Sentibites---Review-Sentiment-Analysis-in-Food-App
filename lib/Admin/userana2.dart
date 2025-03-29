import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Urls.dart';

class useranalysis2 extends StatefulWidget {
  final Map<String, String> userDetails;

  const useranalysis2({super.key, required this.userDetails});

  @override
  _UserAnalysis2State createState() => _UserAnalysis2State();
}

class _UserAnalysis2State extends State<useranalysis2> {
  bool isBlocked = false;

  // Function to show a popup message
  void showPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Action"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Function to update user status (block/unblock)
  Future<void> updateStatus(String email, String status) async {
    try {
      String url = '${Url.Urls}/admin/users'; // Replace with your Flask server's URL

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'status': status}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        showPopup(responseData['message']);
      } else {
        final errorData = jsonDecode(response.body);
        showPopup(errorData['error'] ?? 'An error occurred');
      }
    } catch (e) {
      showPopup('Error: $e');
    }
  }

  // Function to handle block/unblock action
  void handleBlockUnblock() async {
    setState(() {
      isBlocked = !isBlocked;
    });

    final status = isBlocked ? 'Blocked' : 'Active';
    await updateStatus(widget.userDetails['email'] ?? '', status);
  }

  // Function to fetch the current status of the user based on their email
  Future<void> fetchUserStatus(String email) async {
    try {
      String url = '${Url.Urls}/get/admin/users/status'; // Endpoint to fetch user status
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Find the user status based on the email
        final userStatus = responseData['users_status'].firstWhere(
              (user) => user['email'] == email,
          orElse: () => {'status': 'Active'}, // Default to Active if not found
        );

        setState(() {
          isBlocked = userStatus['status'] == 'Blocked';
        });
      } else {
        showPopup('Failed to fetch user status');
      }
    } catch (e) {
      showPopup('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch user status when the page loads
    fetchUserStatus(widget.userDetails['email'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = widget.userDetails;

    return Scaffold(
      body: Stack(
        children: [
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
                  top: 71,
                  left: 5,
                  right: 0,
                  child: Center(
                    child: Text(
                      'User Analysis',
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
              height: MediaQuery.of(context).size.height * 0.79,
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
                    SizedBox(height: 0),
                    Text(
                      'User Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 80),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${userDetails['name']}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Email: ${userDetails['email']}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Contact: ${userDetails['contact']}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Date of Birth: ${userDetails['dob']}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: handleBlockUnblock,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isBlocked ? Colors.red : Colors.green,
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  textStyle: TextStyle(fontSize: 18),
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(
                                  isBlocked ? 'Unblock' : 'Block',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  textStyle: TextStyle(fontSize: 18),
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(
                                  'Go Back',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
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
