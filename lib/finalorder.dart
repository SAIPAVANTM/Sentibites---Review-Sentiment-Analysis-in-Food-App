import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'HomePage/home.dart';
import 'Urls.dart';
import 'analysis/analysispage.dart';
import 'cart.dart';
import 'items/itemspage.dart';

class finorder extends StatefulWidget {
  const finorder({super.key});

  @override
  _FinOrderState createState() => _FinOrderState();
}

class _FinOrderState extends State<finorder> {
  double totalPrice = 0.0;
  bool isLoading = true;
  String orderNumber = (Random().nextInt(90000) + 10000).toString();
  String date = DateTime.now().toLocal().toString().split(' ')[0];
  String time = DateTime.now().toLocal().toString().split(' ')[1].split('.')[0];

  @override
  void initState() {
    super.initState();
    fetchTotalPrice();
    sendOrderToBackend(orderNumber);
  }

  Future<void> fetchTotalPrice() async {
    final url = Uri.parse('${Url.Urls}/cart/total_price/fetch');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          totalPrice = data['price'] != null ? double.parse(data['price'].toString()) : 0.0;
          isLoading = false;
        });
      } else {
        print('Failed to fetch price: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> sendOrderToBackend(String orderNumber) async {
    final url = Uri.parse('${Url.Urls}/add_order');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({'order_no': orderNumber});

    try {
      final response = await http.post(url, headers: headers, body: body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        print('Order added successfully');
      } else {
        print('Failed to add order: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedPrice = NumberFormat.currency(symbol: '₹').format(totalPrice);

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            height: MediaQuery.of(context).size.height * 0.14,
            color: Colors.blueGrey[900],
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Order Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Main Content
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text('Order No: $orderNumber'),
                    SizedBox(height: 5),
                    Text('Date: $date'),
                    SizedBox(height: 5),
                    Text('Time: $time'),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Subtotal', style: TextStyle(fontSize: 16)),
                          isLoading
                              ? CircularProgressIndicator()
                              : Text(formattedPrice, style: TextStyle(fontSize: 16, color: Colors.red[400])),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tax', style: TextStyle(fontSize: 16)),
                          Text('₹0.00', style: TextStyle(fontSize: 16, color: Colors.red[400])),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Fees', style: TextStyle(fontSize: 16)),
                          Text('₹0.00', style: TextStyle(fontSize: 16, color: Colors.red[400])),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delivery', style: TextStyle(fontSize: 16)),
                          Text('₹0.00', style: TextStyle(fontSize: 16, color: Colors.red[400])),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          isLoading
                              ? CircularProgressIndicator()
                              : Text(
                            formattedPrice,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red[400]),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    // New Finish Button
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CartPage()),
                          );
                        },
                        child: Text(
                          'Finish',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
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