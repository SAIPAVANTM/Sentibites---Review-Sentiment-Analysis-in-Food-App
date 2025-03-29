import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../url.dart';

class addit extends StatefulWidget {
  const addit({Key? key}) : super(key: key);

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<addit> {
  XFile? _selectedImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = image;
    });
  }

  Future<void> _submitItem() async {
    if (_selectedImage == null) {
      _showErrorDialog('Please select an image');
      return;
    }

    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _categoryController.text.isEmpty) {
      _showErrorDialog('Name, Price, and Category are required');
      return;
    }

    final Uri url = Uri.parse('${Urll.Urls}/sentibites/add_foods.php'); // Updated URL
    print(url.toString()); // This will print the full URL in the logs.


    var request = http.MultipartRequest('POST', url)
      ..fields['name'] = _nameController.text
      ..fields['price'] = _priceController.text
      ..fields['category'] = _categoryController.text
      ..fields['description'] = _descriptionController.text;

    var imageFile = await http.MultipartFile.fromPath(
      'image',
      _selectedImage!.path,
      contentType: MediaType('image', 'jpeg'),
    );
    request.files.add(imageFile);

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        _showConfirmationDialog();
      } else {
        String responseBody = await response.stream.bytesToString();
        _showErrorDialog('Failed to add item: $responseBody');
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
    }

  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
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

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Item Added Successfully!'),
          content: Text('Your item has been added to the system.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context); // Go back to the previous screen
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
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.20,
            color: Colors.blueGrey[900],
            child: Stack(
              children: [
                Positioned(
                  left: 5,
                  top: 65,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  top: 70,
                  left: MediaQuery.of(context).size.width * 0.37,
                  child: Text(
                    'Add Item',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              ),
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Text('Enter the following details:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    _buildInputField('Name:', _nameController),
                    SizedBox(height: 20),
                    _buildInputField('Price:', _priceController),
                    SizedBox(height: 20),
                    _buildInputField('Category:', _categoryController),
                    SizedBox(height: 20),
                    _buildInputField('Description:', _descriptionController),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          width: 120,
                          child: Text('Image:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: _pickImage,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
                              child: _selectedImage == null
                                  ? Center(child: Text('Pick an image', style: TextStyle(color: Colors.white)))
                                  : Image.file(File(_selectedImage!.path), height: 100, width: 100, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submitItem,
                        child: Text('Submit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                          minimumSize: Size(350, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
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

  Widget _buildInputField(String label, TextEditingController controller) {
    return Row(
      children: [
        Container(
          width: 120,
          child: Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
            child: TextField(
              controller: controller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '',
                hintStyle: TextStyle(color: Colors.white54),
                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
