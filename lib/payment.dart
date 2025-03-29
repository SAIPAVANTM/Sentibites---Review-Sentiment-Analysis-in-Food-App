import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Urls.dart';
import 'finalorder.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  double? totalPrice;
  List<String> cartNames = [];
  String selectedPaymentMethod = 'Credit/Debit Card'; // Default payment method

  @override
  void initState() {
    super.initState();
    _fetchTotalPrice();
    _fetchCartNames();
  }

  // Function to fetch total price from the backend
  Future<void> _fetchTotalPrice() async {
    try {
      final response = await http.get(Uri.parse('${Url.Urls}/cart/total_price/fetch'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          totalPrice = data['price'];
        });
      } else {
        setState(() {
          totalPrice = 0.0;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        totalPrice = 0.0;
      });
    }
  }

  // Function to fetch cart names from the backend
  Future<void> _fetchCartNames() async {
    try {
      final response = await http.get(Uri.parse('${Url.Urls}/cart/fetch2'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          cartNames = List<String>.from(data['cart_names']);
        });
      } else {
        setState(() {
          cartNames = [];
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        cartNames = [];
      });
    }
  }

  // Function to make the API call to update the cart status
  Future<void> _updateCartStatus(List<String> cartNames) async {
    try {
      final response = await http.post(
        Uri.parse('${Url.Urls}/cart/update_status'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'cart_names': cartNames}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Cart status updated successfully');
      } else {
        print('Failed to update cart status');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Centralized method for triggering payment processing
  void _processPayment(String method) {
    // First, update the cart status
    _updateCartStatus(cartNames);

    // Then, show the payment confirmation
    _showPaymentConfirmation(context, method);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                    'Payment',
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

          // Payment Section
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
                padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
                child: ListView(
                  controller: scrollController,
                  children: [
                    // Payment Details (Simplified)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Payment Method Section
                        Text(
                          'Payment Method',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.credit_card, color: Colors.grey),
                            SizedBox(width: 8),
                            Text('Credit/Debit Card'),
                          ],
                        ),
                        SizedBox(height: 20),

                        // UPI Apps Section
                        Text(
                          'OR Pay Using UPI',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _processPayment('Google Pay'); // Process payment with Google Pay
                              },
                              child: Column(
                                children: [
                                  Image.asset('assets/gpay.png', width: 50, height: 50),
                                  SizedBox(height: 8),
                                  Text('Google Pay'),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _processPayment('PhonePe'); // Process payment with PhonePe
                              },
                              child: Column(
                                children: [
                                  Image.asset('assets/phonepe.png', width: 50, height: 50),
                                  SizedBox(height: 8),
                                  Text('PhonePe'),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _processPayment('Paytm'); // Process payment with Paytm
                              },
                              child: Column(
                                children: [
                                  Image.asset('assets/paytm.png', width: 50, height: 50),
                                  SizedBox(height: 8),
                                  Text('Paytm'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),

                        // Total Price Section
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
                                totalPrice != null ? '\₹${totalPrice!.toStringAsFixed(2)}' : 'Loading...',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[400],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Centering Pay Now Button
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              // Trigger payment for the default selected method (Credit/Debit Card)
                              _processPayment('Credit/Debit Card');
                            },
                            child: Text('Pay Now'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(vertical: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Function to show payment confirmation dialog and navigate to FinOrderPage
  void _showPaymentConfirmation(BuildContext context, String method) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Successful'),
          content: Text('Your payment via $method has been processed successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => finorder()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
