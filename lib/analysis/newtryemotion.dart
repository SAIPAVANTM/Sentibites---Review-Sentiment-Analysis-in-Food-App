import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Urls.dart';

class SentimentChartPage extends StatefulWidget {
  final String name;
  final String image;

  const SentimentChartPage({super.key, required this.name, required this.image});

  @override
  _SentimentChartPageState createState() => _SentimentChartPageState();
}

class _SentimentChartPageState extends State<SentimentChartPage> {
  int positive = 0;
  int neutral = 0;
  int negative = 0;
  double positivePercentage = 0.0;
  double neutralPercentage = 0.0;
  double negativePercentage = 0.0;

  @override
  void initState() {
    super.initState();
    fetchSentimentData();
  }

  Future<void> fetchSentimentData() async {
    final response = await http.post(
      Uri.parse('${Url.Urls}/get_reviews_item_sentiment'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"item": widget.name}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        positive = data['positive'];
        neutral = data['neutral'];
        negative = data['negative'];

        int totalReviews = positive + neutral + negative;

        if (totalReviews > 0) {
          positivePercentage = (positive / totalReviews) * 100;
          neutralPercentage = (neutral / totalReviews) * 100;
          negativePercentage = (negative / totalReviews) * 100;
        }
      });
    } else {
      throw Exception('Failed to load sentiment data');
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
                    'Sentiment Analysis',
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

          // Main content with image and sentiment data
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.14),
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(height: 50),
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),

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

                // Sentiment Analysis Bar Chart Section
                Text(
                  'Sentiment Analysis Results',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      // Bar chart with sentiment data
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sentiment Bar Chart',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                height: 20,
                                color: Colors.green[300],
                                width: positivePercentage,
                                child: Center(
                                  child: Text(
                                    'Positive ${positivePercentage.toStringAsFixed(1)}%',
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '${positivePercentage.toStringAsFixed(1)}%',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                height: 20,
                                color: Colors.yellow[300],
                                width: neutralPercentage,
                                child: Center(
                                  child: Text(
                                    'Neutral ${neutralPercentage.toStringAsFixed(1)}%',
                                    style: TextStyle(color: Colors.black, fontSize: 12),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '${neutralPercentage.toStringAsFixed(1)}%',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                height: 20,
                                color: Colors.red[300],
                                width: negativePercentage,
                                child: Center(
                                  child: Text(
                                    'Negative ${negativePercentage.toStringAsFixed(1)}%',
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '${negativePercentage.toStringAsFixed(1)}%',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
