import 'package:flutter/material.dart';
import 'package:sentibites/Owner/ownerana1.dart';

class ownerana extends StatelessWidget {
  const ownerana({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> buttonLabels = [
      'Mexican Appetizer',
      'Fresh Prawn Ceviche',
      'Mushroom Risotto',
      'Chocolate Brownie',
      'Mojito',
      'Chicken Burger',
      'Broccoli Lasagna',
    ];

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
                // Move the "Analysis" text down with padding
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 27.0, left:4), // Add padding to move the text down
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    for (String label in buttonLabels)
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (label == 'Mexican Appetizer') {
                                // Navigate to Mexican Appetizer Page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const OwnerAnalysis()),
                                );
                              }
                              // Add additional navigation logic for other buttons if needed
                            },
                            child: Text(
                              label,
                              style: TextStyle(
                                color: Colors.white, // Ensure the text color is white
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                              minimumSize: Size(350, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              textStyle: TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
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
