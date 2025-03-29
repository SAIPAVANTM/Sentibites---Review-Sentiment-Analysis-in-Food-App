import 'package:flutter/material.dart';
import 'package:sentibites/Admin/ownerana1.dart';
import '../Admin/userana1.dart'; // Adjust this import as needed
import 'User_Loginpage.dart';
import 'add_owners.dart';
import 'signuppage.dart'; // Import the SignUpPage

class AdminToolPage extends StatelessWidget {
  const AdminToolPage({super.key});

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
                  top: 65,
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
                // Admin Tool text moved down
                Positioned(
                  top: 70, // Adjusted top position to move the text down
                  left: 10,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Admin Tools',
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
              height: MediaQuery.of(context).size.height * 0.75, // Remaining part
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

                    // Users button
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to Users page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => useranalysis1()), // Replace with Users page
                        );
                      },
                      child: Text(
                        'Users',
                        style: TextStyle(
                          color: Colors.white, // Ensure text color is white
                          fontWeight: FontWeight.normal, // Ensure no bold text
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Button color
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40), // Padding
                        minimumSize: Size(350, 50), // Set width and height for the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded corners
                        ),
                      ),
                    ),
                    SizedBox(height: 40), // Space between buttons

                    // Owners button
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to Owners page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => owneranalysis1()), // Replace with Owners page
                        );
                      },
                      child: Text(
                        'Owners',
                        style: TextStyle(
                          color: Colors.white, // Ensure text color is white
                          fontWeight: FontWeight.normal, // Ensure no bold text
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Button color
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40), // Padding
                        minimumSize: Size(350, 50), // Set width and height for the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded corners
                        ),
                      ),
                    ),
                    SizedBox(height: 40), // Space between Owners and Add Owners button

                    // Add Owners button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddOwnersPage()), // Replace with Add Owners page
                        );
                      },
                      child: Text(
                        'Add Owners',
                        style: TextStyle(
                          color: Colors.white, // Ensure text color is white
                          fontWeight: FontWeight.normal, // Ensure no bold text
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Button color
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40), // Padding
                        minimumSize: Size(350, 50), // Set width and height for the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded corners
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
}
