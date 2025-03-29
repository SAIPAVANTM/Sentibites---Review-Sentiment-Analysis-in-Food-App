import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sentibites/Admin/userana2.dart';
import 'package:intl/intl.dart';
import '../Urls.dart';

class useranalysis1 extends StatefulWidget {
  const useranalysis1({super.key});

  @override
  _useranalysis1State createState() => _useranalysis1State();
}

class _useranalysis1State extends State<useranalysis1> {
  List<Map<String, String>> userDetailsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    String fetchApiUrl = '${Url.Urls}/fetch/admin/users'; // Fetch API endpoint
    String postApiUrl = '${Url.Urls}/post/admin/users';  // Post API endpoint

    try {
      final response = await http.get(Uri.parse(fetchApiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Prepare the user details list
        final List<Map<String, String>> fetchedUsers = (data['users'] as List).map((user) {
          // Parse and format the dob field
          String formattedDob;
          try {
            final originalFormat = DateFormat('EEE, dd MMM yyyy HH:mm:ss zzz');
            final parsedDate = originalFormat.parse(user['dob']);
            formattedDob = DateFormat('dd/MM/yyyy').format(parsedDate);
          } catch (e) {
            formattedDob = user['dob']; // Fallback to original if parsing fails
          }

          return {
            'name': user['name'].toString(),
            'email': user['email'].toString(),
            'contact': user['mobilenumber'].toString(),
            'dob': formattedDob,
          };
        }).toList();

        // Update the state with fetched users
        setState(() {
          userDetailsList = fetchedUsers;
          isLoading = false;
        });

        // Post each user to the admin_users table
        for (var user in fetchedUsers) {
          await postUserDetails(user, postApiUrl);
        }
      } else {
        throw Exception('Failed to fetch user details');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching user details: $e');
    }
  }

  Future<void> postUserDetails(Map<String, String> userDetails, String apiUrl) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': userDetails['name'],
          'email': userDetails['email'],
          'contact': userDetails['contact'],
          'dob': userDetails['dob'],
        }),
      );

      if (response.statusCode == 201) {
        print('User posted successfully: ${userDetails['email']}');
      } else {
        print('Failed to post user: ${userDetails['email']}');
      }
    } catch (e) {
      print('Error posting user details: $e');
    }
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
                  top: 71,
                  left: 10,
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
              height: MediaQuery.of(context).size.height * 0.78,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: isLoading
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : userDetailsList.isEmpty
                  ? Center(
                child: Text(
                  'No users available',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
                  : Column(
                children: [
                  SizedBox(height: 0),
                  Text(
                    'Users',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          userDetailsList.length,
                              (index) => Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => useranalysis2(
                                      userDetails:
                                      userDetailsList[index],
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                '${userDetailsList[index]['email']} - ${userDetailsList[index]['contact']}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 40),
                                minimumSize: Size(250, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
