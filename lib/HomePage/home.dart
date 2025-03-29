import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sentibites/Auth/User_Loginpage.dart';
import 'package:sentibites/Auth/signuppage.dart';
import 'package:sentibites/analysis/analysispage.dart';
import 'package:sentibites/items/itemspage.dart';
import '../Urls.dart';
import '../contactpage.dart';
import '../helppage.dart';
import '../profilepage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSidebarVisible = false;
  String? userName = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Fetch the name on initialization
  }

  void _fetchUserName() async {
    try {
      final response = await http.get(Uri.parse('${Url.Urls}/get_last_email'));

      if (response.statusCode == 200) {
        setState(() {
          userName = jsonDecode(response.body)['name'];
        });
      } else {
        setState(() {
          userName = "User not found"; // Fallback if no user is found
        });
      }
    } catch (e) {
      setState(() {
        userName = "Error fetching name"; // Fallback for network or server error
      });
    }
  }

  // Function to toggle sidebar visibility
  void _toggleSidebar() {
    setState(() {
      _isSidebarVisible = !_isSidebarVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search...',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 0.0, left: 0),
                        child: IconButton(
                          icon: Icon(Icons.notifications, color: Colors.black),
                          onPressed: () {
                            // Show a snackbar with "No Notifications" message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("No Notifications"),
                                duration: Duration(seconds: 2), // Duration for the snackbar
                              ),
                            );
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.person, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfilePage()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rise And Shine! It's Breakfast Time",
                      style: TextStyle(fontSize: 16, color: Colors.blue[900]),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Best Seller',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Items()),
                            );
                          },
                          child: Row(
                            children: [
                              Text('View All', style: TextStyle(color: Colors.red)),
                              Icon(Icons.arrow_forward, size: 16, color: Colors.red),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        bestSellerItem('assets/sa.jpg'),
                        bestSellerItem('assets/s.jpg'),
                        bestSellerItem('assets/ch.jpg'),
                        bestSellerItem('assets/cake.jpeg'),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage('assets/m.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Experience our delicious new dish\n30% OFF",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Recommend',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          recommendItem('assets/bur.jpg', 'Burger', 4.5),
                          SizedBox(width: 20),
                          recommendItem('assets/pasta.webp', 'Spring Roll', 4.0),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isSidebarVisible)
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: _toggleSidebar,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: MediaQuery.of(context).size.width * 0.6,
                    color: Colors.grey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  'assets/happy.jpg',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userName ?? 'Guest', // Display the fetched name
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Divider(color: Colors.black),
                        menuItem(Icons.person, 'My Profile', context),
                        Divider(color: Colors.white),
                        menuItem(Icons.contact_mail, 'Contact Us', context),
                        Divider(color: Colors.white),
                        menuItem(Icons.help_outline, 'Help & FAQ\'s', context),
                        Divider(color: Colors.white),
                        menuItem(Icons.logout, 'Log Out', context),
                      ],
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 300,
              right: 5,
              child: GestureDetector(
                onTap: _toggleSidebar,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    _isSidebarVisible ? Icons.arrow_forward : Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
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

  Widget bestSellerItem(String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Items()),
        );
      },
      child: Container(
        width: 70,
        height: 90,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }


  Widget recommendItem(String imagePath, String name, double rating) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Items()),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        width: 130,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Text(
                name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget menuItem(IconData icon, String label, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: TextStyle(color: Colors.white)),
      onTap: () {
        if (label == 'Log Out') {
          _showLogoutConfirmationDialog(context);
        } else if (label == 'My Profile') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        } else if (label == 'Contact Us') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContactPage()),
          );
        } else if (label == 'Help & FAQ\'s') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HelpFaqPage()),
          );
        }
      },
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => signuppage()),
                ); // Log out and go to the Sign Up page
              },
              child: Text('Log Out'),
            ),
          ],
        );
      },
    );
  }
}
