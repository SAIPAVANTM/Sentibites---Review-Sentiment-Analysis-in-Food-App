import 'package:flutter/material.dart';
import 'package:sentibites/HomePage/home.dart';
import 'complaint2.dart';

class comp1 extends StatelessWidget {
  const comp1({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> buttonTextList = [
      {'email': 'tmsaipavan@gmail.com', 'status': 'Resolved'},
      {'email': 'bhanusreev@gmail.com', 'status': 'Resolved'},
      {'email': 'reenasrigb@gmail.com', 'status': 'In Progress'},
      {'email': 'komaldaris@gmail.com', 'status': 'Pending'},
      {'email': 'akhilanand@gmail.com', 'status': 'Resolved'},
      {'email': 'vyshnavimc@gmail.com', 'status': 'In Progress'},
      {'email': 'monishkuma@gmail.com', 'status': 'Pending'},
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Yellow background at the top with back button
          Container(
            height: MediaQuery.of(context).size.height * 0.20, // Adjust top height
            color: Colors.blueGrey[900], // Background color for the top section
            child: Stack(
              children: [
                // Back button at the top left corner
                Positioned(
                  left: 5,
                  top: 65,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous screen
                    },
                  ),
                ),
                // "Complaint Analysis" text moved down
                Positioned(
                  top: 70, // Move the text further down
                  left: 8,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Complaint Analysis',
                      style: TextStyle(
                        fontSize: 24, // H2 size
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
              height: MediaQuery.of(context).size.height * 0.80, // Remaining part
              decoration: BoxDecoration(
                color: Colors.white, // White background color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), // Curved top-left corner
                  topRight: Radius.circular(50), // Curved top-right corner
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Complaints',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: buttonTextList.length, // Total number of buttons
                      itemBuilder: (context, index) {
                        String status = buttonTextList[index]['status']!;
                        Color buttonColor;

                        // Set the color based on the complaint status
                        if (status == 'Resolved') {
                          buttonColor = Colors.green;
                        } else if (status == 'In Progress') {
                          buttonColor = Colors.yellow[600]!;
                        } else { // Pending status
                          buttonColor = Colors.red;
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              if (index == 0) {
                                // If the first button is clicked, navigate to the next page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => comp2(), // Navigate to the second page
                                  ),
                                );
                              } else {
                                // Handle other button presses here (if needed)
                                print('${buttonTextList[index]} button pressed');
                              }
                            },
                            child: Text(
                              '${buttonTextList[index]['email']} - $status', // Display the corresponding text for each button
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: buttonColor, // Dynamic color based on status
                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40), // Padding
                              minimumSize: Size(250, 50), // Set width and height for the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30), // Curved button corners
                              ),
                              textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
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
