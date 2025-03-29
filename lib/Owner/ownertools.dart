import 'package:flutter/material.dart';
import 'package:sentibites/Admin/complaint1.dart';
import 'package:sentibites/Admin/ownerana1.dart';
import 'package:sentibites/Auth/User_Loginpage.dart';
import 'package:sentibites/HomePage/home.dart';
import 'package:sentibites/Owner/acceptreject.dart';
import 'package:sentibites/Owner/owneranalysis.dart';
import '../Admin/userana1.dart';
import '../analysis/analysispage.dart';
import 'additems.dart';
import 'changeprice.dart'; // Adjust this import as needed
//import 'signuppage.dart';  // Import the SignUpPage

class owntool extends StatelessWidget {
  const owntool({super.key});

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
                  top: 65, // Adjust the top value to move the text lower
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      // Navigate to SignUpPage when back button is pressed
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => signuppage()), // Navigate to SignUpPage
                      );
                    },
                  ),
                ),
                // Owner Tool text in the center
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25.0, left: 10), // Add padding to move the text lower
                    child: Text(
                      'Owner Tools',
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 120), // Space between the title and buttons

                    // Add Items button
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to Add Items page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => addit()), // Replace with Add Items page
                        );
                      },
                      child: Text('Add Items', style: TextStyle(color: Colors.white)), // Set the text color to white
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Button color
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40), // Padding
                        minimumSize: Size(350, 50), // Set width and height for the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded corners
                        ),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 40), // Space between buttons

                    // Change Price button
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to Change Price page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => change()), // Replace with Change Price page
                        );
                      },
                      child: Text('Change Price', style: TextStyle(color: Colors.white)), // Set the text color to white
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Button color
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40), // Padding
                        minimumSize: Size(350, 50), // Set width and height for the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded corners
                        ),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 40), // Space between buttons

                    // Accept/Reject Order button
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to Accept/Reject Order page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AcceptOrder()), // Replace with Accept/Reject Order page
                        );
                      },
                      child: Text('Accept/Reject Order', style: TextStyle(color: Colors.white)), // Set the text color to white
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Button color
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40), // Padding
                        minimumSize: Size(350, 50), // Set width and height for the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded corners
                        ),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 40), // Space between buttons

                    // Review Analysis button
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to Review Analysis page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => analy1()), // Replace with Review Analysis page
                        );
                      },
                      child: Text('Review Analysis', style: TextStyle(color: Colors.white)), // Set the text color to white
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Button color
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40), // Padding
                        minimumSize: Size(350, 50), // Set width and height for the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded corners
                        ),
                        textStyle: TextStyle(fontSize: 16),
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
