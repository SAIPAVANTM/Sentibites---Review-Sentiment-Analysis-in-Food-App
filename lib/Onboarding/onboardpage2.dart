import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'onboardpage3.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

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
                image: AssetImage('assets/p2.png'), // Replace with your image asset
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Bottom White Section (wrapped in SingleChildScrollView for scrollability)
          Expanded(
            child: SingleChildScrollView(
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: Image.asset('assets/on2.jpeg', height: 40), // Replace with your logo asset
                    ),

                    // Heading Text
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Give Review', // Your heading text
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
                        'See what others are saying! Browse authentic feedback from fellow food enthusiasts, and share your own experiences.', // Description
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
                              builder: (context) => OnboardingPage3(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black, // Button color
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
          ),
        ],
      ),
    );
  }
}
