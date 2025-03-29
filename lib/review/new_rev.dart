import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Urls.dart';

class NewReview extends StatefulWidget {
  final String itemName;

  const NewReview({Key? key, required this.itemName}) : super(key: key);

  @override
  _ItemReviewPageState createState() => _ItemReviewPageState();
}

class _ItemReviewPageState extends State<NewReview> {
  TextEditingController _reviewController = TextEditingController();
  int _starRating = 0;
  String? _imageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchItemImage();
  }

  Future<void> _fetchItemImage() async {
    try {
      final response = await http.post(
        Uri.parse('${Url.Urls}/get_item_image'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': widget.itemName}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _imageUrl = data['image'];
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load image')),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error fetching image: $e");
    }
  }

  Future<void> _submitReview() async {
    if (_starRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a star rating')),
      );
      return;
    }

    try {
      final data = {
        'review': _reviewController.text.isEmpty ? 'No comments' : _reviewController.text,
        'item': widget.itemName,
      };

      final response = await http.post(
        Uri.parse('${Url.Urls}/post_review'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Your review has been submitted.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Go back to previous page
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit review. Please try again.')),
        );
      }
    } catch (e) {
      print("Error submitting review: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top header
          Container(
            height: MediaQuery.of(context).size.height * 0.14,
            color: Colors.blueGrey[900],
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    '${widget.itemName} Review',
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
          // Main content
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _imageUrl != null
                        ? Image.network(
                      _imageUrl!,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.error),
                    )
                        : Icon(Icons.image_not_supported, size: 200),
                    SizedBox(height: 20),
                    Text(
                      widget.itemName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            setState(() => _starRating = index + 1);
                          },
                          icon: Icon(
                            index < _starRating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 40,
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _reviewController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Write your review here...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[400],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _submitReview,
                          child: Text('Submit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
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