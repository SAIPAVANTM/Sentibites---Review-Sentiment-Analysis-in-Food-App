import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../HomePage/home.dart';
import '../Urls.dart';
import '../analysis/analysispage.dart';
import '../cart.dart';
import '../orderpage.dart';
import '../orderpage2.dart';
import 'item_detail_page.dart'; // New page for item details

class Items extends StatefulWidget {
  const Items({super.key});

  @override
  _ItemsState createState() => _ItemsState();
}

class _ItemsState extends State<Items> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAdditionalItems();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> fetchAdditionalItems() async {
    try {
      final response = await http.get(Uri.parse('${Url.Urls}/get_add_details'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Map<String, dynamic>> fetchedItems =
        List<Map<String, dynamic>>.from(data['items']);

        for (var item in fetchedItems) {
          if (!products.any((existingItem) => existingItem['name'] == item['name'])) {
            products.add({
              'imagePath': item['image'],  // Add the image path or URL
              'name': item['name'],
              'price': item['price'].toString(),
              'description': item['description'],
              'category': item['category'],
            });
          }
        }

        setState(() {
          filteredProducts = List.from(products); // Initially, show all items
        });
      } else {
        print('Failed to load items: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching items: $e');
    }
  }


  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      filteredProducts = products
          .where((product) => product['name'].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top yellow background with search bar and cart icon
          Container(
            height: MediaQuery.of(context).size.height * 0.18,
            color: Colors.blueGrey[900],
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon: Icon(Icons.search, color: Colors.white),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // List of products displayed based on the filtered list
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: filteredProducts.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return Column(
                    children: [
                      ProductItem(
                        imagePath: product['imagePath'],
                        name: product['name'],
                        price: product['price'],
                        description: product['description'],
                        category: product['category'],
                        onBuyPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItemDetailPage(product: product),
                            ),
                          );
                        },
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
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

class ProductItem extends StatelessWidget {
  final String imagePath;
  final String name;
  final String price;
  final String description;
  final String category;
  final VoidCallback onBuyPressed;

  const ProductItem({
    required this.imagePath,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.onBuyPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        imagePath.isNotEmpty
            ? ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: imagePath.startsWith('http')
              ? Image.network(
            imagePath,
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.broken_image, size: 150);
            },
          )
              : Image.asset(
            imagePath,
            width: double.infinity,
            height: 150,
            fit: BoxFit.cover,
          ),
        )
            : Container(),

        SizedBox(height: 10),
        Text(
          name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          category,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          '₹$price',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red[400]),
        ),
        SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        SizedBox(height: 12),

        ElevatedButton(
          onPressed: onBuyPressed,
          child: Text('Buy'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blueGrey[900],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
