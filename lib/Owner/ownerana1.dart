import 'package:flutter/material.dart';
import 'package:sentibites/Owner/chartpage.dart';
import 'acceptreject.dart';

class OwnerAnalysis extends StatelessWidget {
  const OwnerAnalysis({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top yellow background with back button
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
                // Move the "Analysis" text down with padding
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 26.0, left:10), // Add padding to move the text down
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
          // White background container with curved top edges
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),

                    // Yellow circular box with text
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
                    SizedBox(height: 20),

                    // Reviews title
                    Text(
                      'Reviews:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),

                    // 15 Review boxes with different texts (including positive and negative)
                    for (int i = 1; i <= 15; i++)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          getReviewText(i),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),

                    // Space before the button
                    SizedBox(height: 90),

                    // Submit button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to Accept/Reject Order page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => OwnerAnalysisChart()), // Replace with Accept/Reject Order page
                          );
                        },
                        child: Text('See Chart'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[400],
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
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

  String getReviewText(int reviewNumber) {
    // Different review text based on the review number
    switch (reviewNumber) {
      case 1:
        return 'Review 1: Amazing appetizer! The flavors were perfect, with just the right amount of spice and freshness.';
      case 2:
        return 'Review 2: This dish is too salty for my taste, but the presentation was great.';
      case 3:
        return 'Review 3: Loved the flavors, though it could have been spicier. Definitely a unique dish!';
      case 4:
        return 'Review 4: Disappointing. The texture was mushy, and the flavor was too bland for my liking.';
      case 5:
        return 'Review 5: A bit too sour for my taste, but the presentation was on point.';
      case 6:
        return 'Review 6: The appetizer was perfect – flavorful, well-balanced, and beautifully presented.';
      case 7:
        return 'Review 7: Not worth the price. The portion size was too small, and the flavors didn’t stand out.';
      case 8:
        return 'Review 8: Too spicy for my taste, but I loved the freshness of the ingredients!';
      case 9:
        return 'Review 9: The appetizer was a bit undercooked, and the flavor didn’t match my expectations.';
      case 10:
        return 'Review 10: Excellent! The flavors were bold and the dish was well-cooked. I’ll order again!';
      case 11:
        return 'Review 11: The presentation was beautiful, but the taste was not as great as I hoped.';
      case 12:
        return 'Review 12: The appetizer had an odd aftertaste that I didn’t enjoy. The texture was off as well.';
      case 13:
        return 'Review 13: Great flavor combination, but it could have been served warmer.';
      case 14:
        return 'Review 14: I didn’t like the combination of ingredients. It felt unbalanced and too heavy.';
      case 15:
        return 'Review 15: The appetizer was tasty and well-spiced, but it lacked the freshness I expected.';
      default:
        return 'Review not found';
    }
  }
}
