import 'package:flutter/material.dart';

class comp2 extends StatelessWidget {
  const comp2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Yellow background at the top with back button
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
                      Navigator.pop(context); // Go back to the previous screen
                    },
                  ),
                ),
                // "Complaint Analysis" text moved down
                Positioned(
                  top: 70, // Increase this value to move the text further down
                  left: 14,
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
              height: MediaQuery.of(context).size.height * 0.78, // Remaining part
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Green box with complaint details title
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(bottom: 60), // Space below this box
                      decoration: BoxDecoration(
                        color: Colors.green, // Green color for the box
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        'tmsaipavan@gmail.com',
                        style: TextStyle(
                          fontSize: 16,

                          color: Colors.white,
                        ),
                      ),
                    ),
                    // Rectangle with name, email, contact, dob
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(bottom: 80), // Space below this box
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Light grey background
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: Sai Pavan',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Email: tmsaipavan@gmail.com',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Contact: 91 9876543212',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'DOB: 21/09/2000',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    // Yellow curved rectangle with complaints inside
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[300], // Yellow color for the rectangle
                        borderRadius: BorderRadius.circular(30), // Curved rectangle
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Complaints:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Complaint 1: Not able to add food. Limit Reached!',
                            style: TextStyle(fontSize: 16, color: Colors.blue[900]),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Complaint 2: Slow in accepting order',
                            style: TextStyle(fontSize: 16, color: Colors.blue[900]),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Complaint 3: Incorrect billing.',
                            style: TextStyle(fontSize: 16, color: Colors.blue[900]),
                          ),
                        ],
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
