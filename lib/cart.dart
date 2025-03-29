import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Urls.dart';
import 'payment.dart';
import 'cartcompleted.dart';
import 'HomePage/home.dart';
import 'analysis/analysispage.dart';
import 'items/itemspage.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<dynamic> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      final response = await http.get(Uri.parse('${Url.Urls}/cart/fetch'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          cartItems = data['cart_items'];
        });
      } else {
        throw Exception('Failed to load cart items');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void updateQuantity(int index, int newQuantity) {
    setState(() {
      cartItems[index]['quantity'] = newQuantity;
    });
  }

  // Function to send total price to the server
  Future<void> sendTotalPriceToServer(double totalPrice) async {
    try {
      final response = await http.post(
        Uri.parse('${Url.Urls}/cart/total_price/post'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'total_price': totalPrice}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Total price sent successfully: $data');
      } else {
        throw Exception('Failed to send total price');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  double calculateTotalPrice() {
    double sum = 0.0;
    for (var item in cartItems) {
      sum += (item['price'].toDouble() * item['quantity']);
    }
    return sum;
  }

  void showAddItemsPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cart is Empty'),
          content: Text('Please add items to your cart before proceeding to payment.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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

          // Scrollable content section
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                child: Column(
                  children: [
                    // Active and Completed buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: Text('Active'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => cartcom()),
                            );
                          },
                          child: Text('Completed'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Fetch and display CartItems
                    cartItems.isEmpty
                        ? Center(
                      child: Text(
                        'Cart is Empty, Add Items!',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        return Column(
                          children: [
                            CartItem(
                              title: item['name'],
                              description: item['description'],
                              price: item['price'].toDouble(),
                              quantity: item['quantity'],
                              onQuantityChanged: (newQuantity) {
                                updateQuantity(index, newQuantity);
                              },
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),

                    // Total and Pay Now button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₹${calculateTotalPrice()}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        double totalPrice = calculateTotalPrice();
                        if (totalPrice > 0) {
                          sendTotalPriceToServer(totalPrice);

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PaymentPage()),
                          );
                        } else {
                          showAddItemsPopup();
                        }
                      },
                      child: Text('Pay Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
}

class CartItem extends StatelessWidget {
  final String title;
  final String description;
  final double price;
  final int quantity;
  final Function(int) onQuantityChanged;

  const CartItem({
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹$price', // Use rupee symbol here
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[400],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, size: 20, color: Colors.red),
                          onPressed: () {
                            if (quantity > 1) {
                              onQuantityChanged(quantity - 1);
                            }
                          },
                        ),
                        Text(
                          '$quantity',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, size: 20, color: Colors.green),
                          onPressed: () {
                            onQuantityChanged(quantity + 1);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
