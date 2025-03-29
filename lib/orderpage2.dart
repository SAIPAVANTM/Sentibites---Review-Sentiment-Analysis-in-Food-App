import 'package:flutter/material.dart';

import 'HomePage/home.dart';
import 'analysis/analysispage.dart';
import 'items/itemspage.dart';

class orders2 extends StatelessWidget {
  const orders2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top yellow background with back button and title only
          Container(
            height: MediaQuery.of(context).size.height * 0.2, // Adjusted height for the yellow section
            color: Colors.blueGrey[900],
            child: Padding(
              padding: const EdgeInsets.only(top: 55, left: 16, right: 16),
              child: Column(
                children: [
                  // Back Button and Title
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context); // Navigate back to previous screen
                        },
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Fresh Prawn Ceviche',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0),
                ],
              ),
            ),
          ),

          // Bottom white section with product details
          DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Product Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/f3.png', // Replace with your product image
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Product Title
                    Text(
                      'Fresh Prawn Ceviche',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),

                    // Product Rating
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 20),
                        SizedBox(width: 5),
                        Text(
                          '4.7',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        Expanded(child: Container()), // Pushes the rating to the right
                      ],
                    ),
                    SizedBox(height: 20),

                    // Quantity Selector
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, color: Colors.red),
                          onPressed: () {
                            // Decrease quantity logic here
                          },
                        ),
                        Text(
                          '1', // Display quantity here
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.green),
                          onPressed: () {
                            // Increase quantity logic here
                          },
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Items',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Product Description
                    Text(
                      'Shrimp Ceviche',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Toppings Subheading
                    Text(
                      'Toppings:',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),

                    // Toppings Options
                    Column(
                      children: [
                        toppingOption('Shrimp', '\$2.99'),
                        toppingOption('Crisp Onion', '\$3.99'),
                        toppingOption('Sweet Corn', '\$3.99'),
                        toppingOption('Pico de Gallo', '\$2.99'),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Price Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0),

                    // Centered Add to Cart Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Show the success message as a popup
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Success'),
                                content: Text('Item successfully added to cart!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context); // Close the popup
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => Items()), // Navigate to the Items page
                                      );
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Add to Cart'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 30),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),

      // Bottom Navigation Bar
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
                  }
              ),
              SizedBox(width: 60),
              IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Items()),
                    );
                  }
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

  // Helper method to generate topping options
  Widget toppingOption(String toppingName, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          toppingName,
          style: TextStyle(fontSize: 18),
        ),
        Row(
          children: [
            Text(
              price,
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                // Select topping logic here
              },
              child: Text('Select'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
