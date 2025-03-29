import 'package:flutter/material.dart';

import 'HomePage/home.dart';
import 'analysis/analysispage.dart';
import 'items/itemspage.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  // To store the expanded state for each dropdown
  bool _isCustomerServiceExpanded = false;
  bool _isWebsiteExpanded = false;
  bool _isWhatsAppExpanded = false;
  bool _isFacebookExpanded = false;
  bool _isInstagramExpanded = false;

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
                // "Contact Us" title in the center
                Center(
                  child: Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Text below "Contact Us" in the yellow section
                Positioned(
                  bottom: 30,
                  left: 22,
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
              height: MediaQuery.of(context).size.height * 0.65, // Remaining part
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: const EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Customer service, website, and social media with dropdown
                    _buildDropdown(
                        'Customer Service',
                        '-> Kindly contact +91 9962355587',
                        _isCustomerServiceExpanded,
                            () {
                          setState(() {
                            _isCustomerServiceExpanded = !_isCustomerServiceExpanded;
                          });
                        }),
                    SizedBox(height: 15), // Add gap between items
                    _buildDropdown(
                        'Website',
                        '-> Visit www.sentibites.com',
                        _isWebsiteExpanded,
                            () {
                          setState(() {
                            _isWebsiteExpanded = !_isWebsiteExpanded;
                          });
                        }),
                    SizedBox(height: 15), // Add gap between items
                    _buildDropdown(
                        'WhatsApp',
                        '-> Kindly contact +91996234863',
                        _isWhatsAppExpanded,
                            () {
                          setState(() {
                            _isWhatsAppExpanded = !_isWhatsAppExpanded;
                          });
                        }),
                    SizedBox(height: 15), // Add gap between items
                    _buildDropdown(
                        'Facebook',
                        '-> https://facebook.com/sentibites',
                        _isFacebookExpanded,
                            () {
                          setState(() {
                            _isFacebookExpanded = !_isFacebookExpanded;
                          });
                        }),
                    SizedBox(height: 15), // Add gap between items
                    _buildDropdown(
                        'Instagram',
                        '-> https://instagram.com/sentibites',
                        _isInstagramExpanded,
                            () {
                          setState(() {
                            _isInstagramExpanded = !_isInstagramExpanded;
                          });
                        }),
                    SizedBox(height: 40), // Add space at the end
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

  // Helper function to build dropdown items with content
  Widget _buildDropdown(String label, String info, bool isExpanded, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 16),
                ),
                Spacer(),
                Icon(
                  isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.black,
                  size: 30,
                ),
              ],
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.only(left: 40.0, top: 8.0),
                child: Text(
                  info,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
