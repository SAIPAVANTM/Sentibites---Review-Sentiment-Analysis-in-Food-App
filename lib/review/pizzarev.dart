import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Urls.dart';


class PizzaReviewPage extends StatefulWidget {
  const PizzaReviewPage({Key? key}) : super(key: key);

  @override
  _PizzaReviewPageState createState() => _PizzaReviewPageState();
}

class _PizzaReviewPageState extends State<PizzaReviewPage> {
  TextEditingController _reviewController = TextEditingController();
  int _starRating = 0; // Holds the selected star rating

  Future<void> _submitReview() async {
    if (_starRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a star rating')),
      );
      return;
    }

    String reviewText = _reviewController.text;

    try {
      // Prepare the data to be sent
      Map<String, dynamic> data = {
        'reviews': _reviewController.text.isEmpty ? 'No comments' : _reviewController.text,
      };

      // Send POST request to the API
      final response = await http.post(
        Uri.parse('${Url.Urls}/add_pizza_review'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Submitted Successfully'),
              content: Text('Your review has been submitted.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Go back to previous page
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit review. Please try again.')),
        );
      }
    } catch (e) {
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
          // Top header with back button and title
          Container(
            height: MediaQuery.of(context).size.height * 0.14,
            color: Colors.red[700],
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
                    'Pizza Review',
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

          // Main content
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
                        'assets/pizza.jpg',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Pizza',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Delicious Cheese Pizza',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Star rating
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return IconButton(
                            onPressed: () {
                              setState(() {
                                _starRating = index + 1;
                              });
                            },
                            icon: Icon(
                              index < _starRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 40,
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Review input
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
                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // Cancel and go back
                          },
                          child: Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[400],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _submitReview, // Submit the review
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
