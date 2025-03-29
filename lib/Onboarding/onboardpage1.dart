import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'onboardpage2.dart';

class BlackScreenPage extends StatelessWidget {
  const BlackScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Yellow Status Bar (keeping it at the top)
          Container(
            height: MediaQuery.of(context).padding.top, // Status bar height
            color: Colors.blueGrey[900], // Yellow background for the top bar
          ),

          // Top Image Section (occupying a larger portion of the screen)
          Container(
            height: MediaQuery.of(context).size.height * 0.6, // Adjust this value to extend the image
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/on1.png'), // Replace with your image asset
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Bottom White Section
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // White background for the bottom section
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Image.asset('assets/p1.jpg', height: 40), // Replace with your logo asset
                  ),

                  // Heading Text
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Explore Items', // Your heading text
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[400],
                      ),
                    ),
                  ),

                  // Description Text
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Discover popular dishes, hidden gems, and new flavors. Dive in and see what’s trending now!', // Description
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[900],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Next Button
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => OnboardingPage2(),),);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Button color
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
