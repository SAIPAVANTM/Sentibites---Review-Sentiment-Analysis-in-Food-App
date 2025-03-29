import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sentibites/review/burgerrev.dart';
import 'package:sentibites/review/dosarev.dart';
import 'package:sentibites/review/new_rev.dart';
import 'package:sentibites/review/pizzarev.dart';
import 'package:sentibites/review/pongalrev.dart';
import 'package:sentibites/review/samosarev.dart';
import 'package:sentibites/review/vadarev.dart';
import 'HomePage/home.dart';
import 'Urls.dart';
import 'analysis/analysispage.dart';
import 'items/itemspage.dart';
import 'leavrev1.dart'; // Import the ReviewPage from the other file

void main() {
  runApp(MaterialApp(
    home: cartcom(),
  ));
}

class cartcom extends StatefulWidget {
  const cartcom({super.key});

  @override
  _cartcomState createState() => _cartcomState();
}

class _cartcomState extends State<cartcom> {
  late Future<List<CartItemModel>> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = fetchCartItems();
  }

  // Fetch cart items from the API
  Future<List<CartItemModel>> fetchCartItems() async {
    final response = await http.get(Uri.parse('${Url.Urls}/cart/fetch/completed'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['cart_items'];
      return data
          .where((item) => item['status'] == 'completed')
          .map((item) => CartItemModel.fromJson(item))
          .toList();
    } else {
      throw Exception('Failed to load cart items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top yellow background with text and back button
          Container(
            height: MediaQuery.of(context).size.height * 0.14,
            color: Colors.blueGrey[900],
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    'Cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 40),
                ],
              ),
            ),
          ),

          // FutureBuilder for fetching and displaying cart items
          Expanded(
            child: FutureBuilder<List<CartItemModel>>(
              future: cartItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No completed cart items'));
                }

                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: snapshot.data!.map((item) {
                    return CartItem(
                      title: item.name,
                      description: item.category,
                      price: item.price,
                      quantity: item.quantity,
                    );
                  }).toList(),
                );
              },
            ),
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
                    MaterialPageRoute(builder: (context) => HomePage()), // Home Page navigation
                  );
                },
              ),
              SizedBox(width: 60),
              IconButton(
                icon: Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Items()), // Items Page navigation
                  );
                },
              ),
              SizedBox(width: 60),
              IconButton(
                icon: Icon(Icons.favorite, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => analy1()), // Analysis Page navigation
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartItemModel {
  final String name;
  final String category;
  final String price;  // Keep this as String
  final String description;
  final int quantity;

  CartItemModel({
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      name: json['name'],
      category: json['category'],
      price: json['price'].toString(), // Convert price to String if it's a double
      description: json['description'],
      quantity: json['quantity'],
    );
  }
}

class CartItem extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final int quantity;

  const CartItem({
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
  });

  // Function to navigate to the appropriate review page based on the title
  void navigateToReviewPage(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewReview(itemName: title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(description),
                  SizedBox(height: 8),
                  Text(
                    '₹$price',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text('Quantity: $quantity'),

                  ElevatedButton(
                    onPressed: () {
                      navigateToReviewPage(context, title);
                    },
                    child: Text('Leave a Review'),
                  ),
                ],
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}

