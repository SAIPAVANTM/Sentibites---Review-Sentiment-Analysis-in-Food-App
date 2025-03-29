import 'package:flutter/material.dart';

import 'HomePage/home.dart';
import 'analysis/analysispage.dart';
import 'items/itemspage.dart';

class HelpFaqPage extends StatefulWidget {
  const HelpFaqPage({Key? key}) : super(key: key);

  @override
  State<HelpFaqPage> createState() => _HelpFaqPageState();
}

class _HelpFaqPageState extends State<HelpFaqPage> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Yellow background with title and text
          Container(
            height: MediaQuery.of(context).size.height * 0.20, // Top 20% height
            color: Colors.blueGrey[900],
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
                // "Help & FAQs" title in the center
                Center(
                  child: Text(
                    'Help & FAQs',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Text below "Help & FAQs" in the yellow section
                Positioned(
                  bottom: 37,
                  left: 20,
                  right: 20,
                  child: Center(
                    child: Text(
                      'How can we help you?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // White background container with content
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75, // Remaining part
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: const EdgeInsets.all(30.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Search bar below the buttons
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search FAQs...',
                        prefixIcon: Icon(Icons.search, color: Colors.red),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    SizedBox(height: 60),

                    // Bold FAQ text
                    Text(
                      'Frequently Asked Questions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),

                    // FAQ with dropdown answer
                    _buildFaqWithDropdown(
                      question: 'How to reset my password?',
                      answer:
                      'To reset your password, go to the settings page and click on "Reset Password". Follow the on-screen instructions to complete the process.',
                    ),
                    SizedBox(height: 15),
                    _buildFaqWithDropdown(
                      question: 'How to contact support?',
                      answer:
                      'You can contact support by going to the "Contact Us" page and filling out the form. We will get back to you as soon as possible.',
                    ),
                    SizedBox(height: 15),
                    _buildFaqWithDropdown(
                      question: 'Where is my order?',
                      answer:
                      'You can track your order by going to your "Order History" in the app or website and checking the status there.',
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar (from ProfilePage)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[900],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.home, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
              SizedBox(width: 60),
              IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Items()),
                  );
                },
              ),
              SizedBox(width: 60),
              IconButton(
                icon: Icon(Icons.favorite, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => analy1()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build FAQ items with dropdown answer
  Widget _buildFaqWithDropdown({required String question, required String answer}) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(fontSize: 16),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            answer,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}
