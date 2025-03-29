import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../Urls.dart';

class ItemDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;

  const ItemDetailPage({super.key, required this.product});

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  int quantity = 1;

  void _addToCart() {
    // Prepare the data to be sent to the server
    final productData = {
      'name': widget.product['name'],
      'category': widget.product['category'],
      'price': widget.product['price'],
      'quantity': quantity,
      'description': widget.product['description'] ?? '', // Send description if available
    };

    // Send data to the server (use your actual API URL)
    final String url = '${Url.Urls}/cart/add';

    // Send POST request
    http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(productData)).then((response) {
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Show confirmation dialog on success
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text("${widget.product['name']} added to cart successfully!"),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.pop(context); // Go back to the previous screen
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Show error message if the request fails
        Fluttertoast.showToast(msg: 'Failed to add to cart');
      }
    }).catchError((error) {
      // Handle error
      Fluttertoast.showToast(msg: 'Error: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product['name'])),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name section
              Text(
                'Name: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.product['name'],
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(height: 25),

              // Category section
              Text(
                'Category: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.product['category'],
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              SizedBox(height: 25),

              // Price section
              Text(
                'Price: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '₹${widget.product['price']}',
                style: TextStyle(fontSize: 22, color: Colors.red[400]),
              ),
              SizedBox(height: 25),

              // Description section
              Text(
                'Description: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.product['description'],
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 25),

              // Beautiful Quantity section with smaller box size
              Text(
                'Quantity: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.remove, color: Colors.blueGrey[900], size: 20),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$quantity',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        quantity++;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.add, color: Colors.blueGrey[900], size: 20),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),

              // Add to Cart button
              ElevatedButton(
                onPressed: _addToCart,
                child: Text('Add to Cart'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueGrey[900],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
