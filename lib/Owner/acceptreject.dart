import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Urls.dart'; // To handle the URL for the Flask backend

void main() {
  runApp(MaterialApp(home: AcceptOrder()));
}

class AcceptOrder extends StatefulWidget {
  const AcceptOrder({super.key});

  @override
  _AcceptOrderState createState() => _AcceptOrderState();
}

class _AcceptOrderState extends State<AcceptOrder> {
  List<String> orderNumbers = [];

  // Send GET request to fetch all orders from the Flask backend
  Future<void> fetchOrders() async {
    try {
      final url = Uri.parse('${Url.Urls}/fetch_all_orders'); // Replace with your Flask server URL

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> fetchedOrders = json.decode(response.body);

        // Print the fetched orders to verify the data
        print('Fetched Orders: $fetchedOrders');

        // Filter orders with 'pending' status and extract their order numbers
        setState(() {
          orderNumbers = fetchedOrders
              .where((order) {
            // Debugging print to see each order's status
            print('Order: ${order['order_no']}, Status: ${order['status']}');
            return order['status'] == 'pending'; // Only include orders with 'pending' status
          })
              .map((order) => 'Order no ${order['order_no']}') // Extract only the order numbers
              .toList();
        });

        // Print the filtered orders to debug
        print('Filtered Orders: $orderNumbers');
      } else {
        showResponseDialog(context, 'Failed to fetch orders. Try again.');
      }
    } catch (e) {
      showResponseDialog(context, 'Error occurred: $e');
    }
  }


  // Send POST request to update the order status
  Future<void> updateOrderStatus(String orderNo, String status) async {
    try {
      // Construct the URL for the Flask server's route
      final url = Uri.parse('${Url.Urls}/owner/accept-order'); // Replace with your Flask server URL

      // Prepare the payload data
      final Map<String, dynamic> data = {
        'order_no': int.parse(orderNo.split(' ')[2]), // Extract the order number from the string
        'status': status,
      };

      // Send POST request with headers and JSON body
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        // Successfully updated
        showResponseDialog(context, 'Order updated successfully', orderNo, status);
      } else {
        // Handle any errors returned from the server
        showResponseDialog(context, 'Failed to update order. Try again.', orderNo, status);
      }
    } catch (e) {
      // Handle any errors during the request
      showResponseDialog(context, 'Error occurred: $e', orderNo, status);
    }
  }

  // Show response dialog after an action
  void showResponseDialog(BuildContext context, String message, [String? orderNo, String? status]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert!'),
          content: Text('$message\nOrder ID: $orderNo'),
          actions: [
            TextButton(
              onPressed: () {
                if (orderNo != null) {
                  setState(() {
                    orderNumbers.remove(orderNo);
                  });
                }
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
  void initState() {
    super.initState();
    fetchOrders(); // Fetch orders when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Accept/Reject Order',
          style: TextStyle(color: Colors.white), // Set the text color to white
        ),
        backgroundColor: Colors.blueGrey[900],
          iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text('Orders:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    for (var orderNo in orderNumbers)
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    orderNo,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        updateOrderStatus(orderNo, 'Accepted');
                                      },
                                      child: Text('Accept'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        updateOrderStatus(orderNo, 'Rejected');
                                      },
                                      child: Text('Reject'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
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
