import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Urls.dart';
import 'newtry.dart';

// Main Page with Item Fetching
class analy1 extends StatefulWidget {
  const analy1({super.key});

  @override
  _analy1State createState() => _analy1State();
}

class _analy1State extends State<analy1> {
  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  // Fetch items from the backend
  Future<void> fetchItems() async {
    final response = await http.get(Uri.parse('${Url.Urls}/get_items_image'));

    if (response.statusCode == 200) {
      setState(() {
        items = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load items');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header section with a fixed height
          Container(
            height: MediaQuery.of(context).size.height * 0.14,
            color: Colors.blueGrey[900],
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
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
                    'Analysis',
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
          // Content section with SingleChildScrollView
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Select Dish',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 1),
                  // Create grid of items
                  GridView.builder(
                    shrinkWrap: true, // Ensures GridView doesn't take full screen
                    physics: NeverScrollableScrollPhysics(), // Disable internal scroll
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to the Item Detail Page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItemDetailPages(
                                name: item['name'],  // Pass name
                                image: item['image'], // Pass image URL
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                item['image'],
                                width: 150,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(item['name']),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: analy1()));
}
