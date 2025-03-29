import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Urls.dart';
import 'newtryemotion.dart';

class ItemDetailPages extends StatefulWidget {
  final String name;
  final String image;

  const ItemDetailPages({super.key, required this.name, required this.image});

  @override
  _ItemDetailPagesState createState() => _ItemDetailPagesState();
}

class _ItemDetailPagesState extends State<ItemDetailPages> {
  List<String> reviews = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      final response = await http.post(
        Uri.parse('${Url.Urls}/get_reviews_item'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"item": widget.name}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          reviews = List<String>.from(data['reviews'].map((review) => review['review']));
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load reviews');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching reviews: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top background with text
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
                    widget.name,
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

          // Main content with image and reviews section
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.14),
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: 10),

                // Text above the image
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),

                // Image section
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.image,
                      width: 300,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Reviews Section
                Text(
                  'Reviews',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : reviews.isEmpty
                      ? Center(child: Text('No reviews found.'))
                      : ListView.builder(
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Review ${index + 1}'),
                        subtitle: Text(reviews[index]),
                      );
                    },
                  ),
                ),
                SizedBox(height: 30),

                // Sentiment Analysis Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SentimentChartPage(
                          name: widget.name,
                          image: widget.image,
                        ),
                      ),
                    );
                  },
                  child: Text('View Sentiment Analysis'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
