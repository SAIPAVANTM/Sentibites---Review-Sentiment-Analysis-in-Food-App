import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Urls.dart';  // For JSON decoding

class change extends StatefulWidget {
  const change({super.key});

  @override
  _ChangeState createState() => _ChangeState();
}

class _ChangeState extends State<change> {
  // Controllers for the text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _newPriceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  // Function to handle price update
  Future<void> updatePrice() async {
    final String apiUrl = '${Url.Urls}/owner/change-price';  // Replace with your backend API URL

    // Prepare data to send
    Map<String, dynamic> data = {
      'name': _nameController.text,
      'category': _categoryController.text,
      'new_price': _newPriceController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // If server returns a 200 OK response, show a success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Item price updated successfully."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.pop(context); // Optionally go back to the previous page
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        // If the response is not OK, show an error message
        throw Exception("Failed to update price");
      }
    } catch (e) {
      // Handle error if the request fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to update the price. Please try again."),
            actions: [
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
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top yellow background with back button
          Container(
            height: MediaQuery.of(context).size.height * 0.20, // Adjust top height
            color: Colors.blueGrey[900], // Yellow color for the top section
            child: Stack(
              children: [
                // Back button at the top left corner
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
                // Change Price text moved further down
                Positioned(
                  top: 70, // Adjust this value to move the text further down
                  left: MediaQuery.of(context).size.width * 0.31, // Center the text horizontally
                  child: Text(
                    'Change Price',
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
          // White background container with curved top edges
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.80, // Remaining part
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
                    SizedBox(height: 50), // Space between the title and inputs

                    // Text instructions
                    Text(
                      'Enter the following details:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 50),

                    // Item Name
                    Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            'Name:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              controller: _nameController,
                              style: TextStyle(color: Colors.white), // Input text color
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.white54), // Hint text color
                                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),

                    // New Price
                    Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            'New Price:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              controller: _newPriceController,
                              style: TextStyle(color: Colors.white), // Input text color
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.white54), // Hint text color
                                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),

                    // Item Category
                    Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text(
                            'Category:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              controller: _categoryController,
                              style: TextStyle(color: Colors.white), // Input text color
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '',
                                hintStyle: TextStyle(color: Colors.white54), // Hint text color
                                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 60),

                    // Submit Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          updatePrice(); // Call the updatePrice function when submit is clicked
                        },
                        child: Text('Submit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey, // Button color
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40), // Padding
                          minimumSize: Size(350, 50), // Set width and height for the button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), // Rounded corners
                          ),
                          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
