import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;

import '../Urls.dart';

class OwnerAnalysisChart extends StatefulWidget {
  const OwnerAnalysisChart({Key? key}) : super(key: key);

  @override
  _OwnerAnalysisChartState createState() => _OwnerAnalysisChartState();
}

class _OwnerAnalysisChartState extends State<OwnerAnalysisChart> {
  // Variables to store sentiment data
  int positive = 0;
  int negative = 0;
  int neutral = 0;

  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchSentimentData();
  }

  // Fetch sentiment data from Flask API
  Future<void> fetchSentimentData() async {
    String apiUrl = '${Url.Urls}/owner/mexican';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          positive = data['positive'];
          negative = data['negative'];
          neutral = data['neutral'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate percentages
    int total = positive + negative + neutral;
    double positivePercentage = total > 0 ? (positive / total) * 100 : 0;
    double negativePercentage = total > 0 ? (negative / total) * 100 : 0;
    double neutralPercentage = total > 0 ? (neutral / total) * 100 : 0;

    return Scaffold(
      body: Stack(
        children: [
          // Top background with back button
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
                Padding(
                  padding: const EdgeInsets.only(top: 26.0, left: 5),
                  child: Center(
                    child: Text(
                      'Analysis',
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
          // Chart and analysis
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: isLoading
                  ? Center(child: CircularProgressIndicator()) // Loading spinner
                  : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Center(
                      child: Container(
                        width: 250,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            'Mexican Appetizer',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'Sentiment Analysis:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 350,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Positive Bar
                          Container(
                            width: 70,
                            height: positivePercentage * 2, // Scale height
                            color: Colors.green,
                            child: Center(
                              child: Text(
                                '${positivePercentage.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          // Negative Bar
                          Container(
                            width: 70,
                            height: negativePercentage * 2, // Scale height
                            color: Colors.red,
                            child: Center(
                              child: Text(
                                '${negativePercentage.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          // Neutral Bar
                          Container(
                            width: 70,
                            height: neutralPercentage * 2, // Scale height
                            color: Colors.yellow,
                            child: Center(
                              child: Text(
                                '${neutralPercentage.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Positive'),
                        SizedBox(width: 30),
                        Text('Negative'),
                        SizedBox(width: 30),
                        Text('Neutral'),
                      ],
                    ),
                    SizedBox(height: 20),
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
