import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Urls.dart'; // To handle JSON responses

class owneranalysis2 extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String dob;

  const owneranalysis2({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.dob,
  });

  @override
  _OwnerAnalysis2State createState() => _OwnerAnalysis2State();
}

class _OwnerAnalysis2State extends State<owneranalysis2> {
  bool isBlocked = false;
  final String fetchStatusUrl = '${Url.Urls}/admin/owner-status'; // Fetch status endpoint
  final String updateStatusUrl = '${Url.Urls}/admin/owners'; // Update status endpoint

  @override
  void initState() {
    super.initState();
    fetchOwnerStatus();
  }

  // Function to fetch the owner's status
  Future<void> fetchOwnerStatus() async {
    try {
      final response = await http.get(Uri.parse(fetchStatusUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final owner = data.firstWhere(
              (element) => element['email'] == widget.email,
          orElse: () => null,
        );
        if (owner != null) {
          setState(() {
            isBlocked = owner['status'] == 'Blocked';
          });
        }
      } else {
        showPopup("Error fetching status: ${response.body}");
      }
    } catch (e) {
      showPopup("Failed to fetch status. Please try again.");
    }
  }

  // Function to handle block/unblock actions
  Future<void> handleBlockUnblock() async {
    setState(() {
      isBlocked = !isBlocked;
    });

    String status = isBlocked ? 'Blocked' : 'Active';

    try {
      final response = await http.post(
        Uri.parse(updateStatusUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'email': widget.email,
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        showPopup("Owner ${isBlocked ? 'blocked' : 'unblocked'} successfully.");
      } else {
        showPopup("Error: ${response.body}");
      }
    } catch (e) {
      showPopup("Failed to update status. Please try again.");
    }
  }

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

  @override
  Widget build(BuildContext context) {
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
                  top: 70,
                  left: 13,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Owner Analysis',
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
                      'Owner Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        print('${widget.name} - ${widget.email} - ${widget.phone} button pressed');
                      },
                      child: Text(
                        '${widget.name} - ${widget.email} - ${widget.phone}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                        minimumSize: Size(250, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    SizedBox(height: 90),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${widget.name}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Email: ${widget.email}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Contact: ${widget.phone}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Date of Birth: ${widget.dob}',
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
                                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                                  minimumSize: Size(120, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  isBlocked ? 'Unblock' : 'Block',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
