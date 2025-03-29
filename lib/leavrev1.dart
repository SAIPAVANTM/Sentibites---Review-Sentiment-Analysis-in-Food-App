import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Urls.dart';

class LeaveReviewPage extends StatefulWidget {
  const LeaveReviewPage({super.key, required this.title});

  final String title;

  @override
  _LeaveReviewPageState createState() => _LeaveReviewPageState();
}

class _LeaveReviewPageState extends State<LeaveReviewPage> {
  TextEditingController _reviewController = TextEditingController();

  Future<void> _submitReview() async {
    // Get the review text from the controller
    String reviewText = _reviewController.text;

    if (reviewText.isEmpty) {
      // Show a message if review is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review is required')),
      );
      return;
    }

    try {
      // Prepare the data to be sent
      Map<String, dynamic> data = {'reviews': reviewText};

      // Send POST request to the API
      final response = await http.post(
        Uri.parse('${Url.Urls}/add_mexican_review'),  // Replace with your API URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        // If the response is successful, show a success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Submitted Successfully'),
              content: Text('Your review has been submitted.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);  // Close the dialog
                    Navigator.pop(context);  // Go back to the previous page
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // If the response is not successful, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit review. Please try again.')),
        );
      }
    } catch (e) {
      // Handle any errors during the HTTP request
      print("Error submitting review: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top yellow background with text and back button
          Container(
            height: MediaQuery.of(context).size.height * 0.14,
            color: Colors.blueGrey[900],
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Leave a Review',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 40),
                ],
              ),
            ),
          ),

          // Main content with review details
          DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/f1.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Tortilla Chips With Toppings',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return Icon(
                            Icons.star_border,
                            color: Colors.blue[100],
                            size: 40,
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _reviewController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Write your review here...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);  // Go back on cancel
                          },
                          child: Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[400],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _submitReview,  // Submit the review
                          child: Text('Submit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
