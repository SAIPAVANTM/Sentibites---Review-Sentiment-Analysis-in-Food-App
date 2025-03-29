import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sentibites/Admin/ownerana2.dart';

import '../Urls.dart';

class owneranalysis1 extends StatefulWidget {
  const owneranalysis1({super.key});

  @override
  _owneranalysis1State createState() => _owneranalysis1State();
}

class _owneranalysis1State extends State<owneranalysis1> {
  // List to hold the data fetched from the Flask API
  List<Map<String, dynamic>> buttonDetailsList = [];

  // Function to fetch owner data from Flask API
  Future<void> fetchOwners() async {
    final response = await http.get(Uri.parse('${Url.Urls}/fetch_all_owners'));

    if (response.statusCode == 200) {
      // Parse the JSON response
      List<dynamic> ownersData = jsonDecode(response.body);

      // Update the buttonDetailsList with the fetched data
      setState(() {
        buttonDetailsList = ownersData.map((owner) {
          return {
            'name': owner['name'],
            'email': owner['email'],
            'contact': owner['contact'],
            'dob': owner['dob'],
          };
        }).toList();
      });

      // Post the fetched details to /add_owner_new
      for (var owner in ownersData) {
        await postOwnerDetails(owner);
      }
    } else {
      // Handle error
      print('Failed to load owners');
    }
  }

// Function to post owner details to the /add_owner_new route
  Future<void> postOwnerDetails(Map<String, dynamic> owner) async {
    final response = await http.post(
      Uri.parse('${Url.Urls}/add_owner_new'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': owner['name'],
        'email': owner['email'],
        'contact': owner['contact'],
        'dob': owner['dob'],
      }),
    );

    if (response.statusCode == 200) {
      print('Successfully posted owner: ${owner['name']}');
    } else {
      print('Failed to post owner: ${owner['name']}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOwners(); // Fetch data when the widget is initialized
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
              height: MediaQuery.of(context).size.height * 0.8,
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
                    SizedBox(height: 20),
                    Text(
                      'Owners',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 0),
                    // Display the fetched owners in the list
                    buttonDetailsList.isEmpty
                        ? Center(child: CircularProgressIndicator()) // Show loading indicator while data is being fetched
                        : ListView.builder(
                      itemCount: buttonDetailsList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var details = buttonDetailsList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => owneranalysis2(
                                    name: details['name']!,
                                    email: details['email']!,
                                    phone: details['contact']!,
                                    dob: details['dob']!,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              '${details['name']} - ${details['contact']}',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
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
                              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
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
