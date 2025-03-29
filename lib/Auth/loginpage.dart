import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sentibites/Auth/User_Loginpage.dart';
import 'package:sentibites/Auth/signuppage.dart';
import 'package:sentibites/Auth/forgotpswdpage.dart';
import 'package:sentibites/Auth/tools.dart';
import '../HomePage/home.dart';
import '../Owner/ownertools.dart';
import '../Urls.dart';

class userlogin extends StatefulWidget {
  const userlogin({super.key});

  @override
  State<userlogin> createState() => _userloginState();
}

class _userloginState extends State<userlogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    // Hardcoded email check for direct navigation
    if (emailController.text == "saipavan@gmail.com") {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Icon(
                        Icons.admin_panel_settings,
                        size: 50,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Welcome Admin',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Logging you in...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      );

      await Future.delayed(Duration(seconds: 5));
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminToolPage()),
      );
      return;
    } else if (emailController.text == "bhanu@gmail.com") {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Icon(
                        Icons.verified_user,
                        size: 50,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Welcome Owner',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Logging you in...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      );

      await Future.delayed(Duration(seconds: 5));
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => owntool()),
      );
      return;
    }

    // Continue with the original login flow if not a hardcoded email
    final String statusUrl = "${Url.Urls}/get/admin/users/status";
    final String loginUrl = "${Url.Urls}/login";
    final String addEmailUrl = "${Url.Urls}/add_email";
    final String checkOwnerUrl = "${Url.Urls}/check_credentials";
    final String adminLoginUrl = "${Url.Urls}/admin/login";

    try {
      final statusResponse = await http.get(
        Uri.parse(statusUrl),
        headers: {"Content-Type": "application/json"},
      );

      if (statusResponse.statusCode == 200) {
        final statusData = jsonDecode(statusResponse.body);
        final userStatus = (statusData['users_status'] as List).firstWhere(
              (user) => user['email'] == emailController.text,
          orElse: () => null,
        );

        if (userStatus != null) {
          if ((userStatus['status'] as String).toLowerCase() == 'active') {
            final loginResponse = await http.post(
              Uri.parse(loginUrl),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode({
                "email": emailController.text,
                "password": passwordController.text,
              }),
            );

            if (loginResponse.statusCode == 200) {
              await http.post(
                Uri.parse(addEmailUrl),
                headers: {"Content-Type": "application/json"},
                body: jsonEncode({"email": emailController.text}),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              return;
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Your account is not active. Please contact support.')),
            );
            return;
          }
        }

        final ownerResponse = await http.post(
          Uri.parse(checkOwnerUrl),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": emailController.text,
            "password": passwordController.text,
          }),
        );

        if (ownerResponse.statusCode == 200) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Icon(
                            Icons.verified_user,
                            size: 50,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Welcome Owner',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Logging you in...',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );

          await Future.delayed(Duration(seconds: 5));
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => owntool()),
          );
          return;
        }

        if (ownerResponse.statusCode == 404) {
          final adminResponse = await http.post(
            Uri.parse(adminLoginUrl),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "email": emailController.text,
              "password": passwordController.text,
            }),
          );

          if (adminResponse.statusCode == 200 || adminResponse.statusCode == 201) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: const Offset(0.0, 10.0),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Icon(
                              Icons.admin_panel_settings,
                              size: 50,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Welcome Admin',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Logging you in...',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );

            await Future.delayed(Duration(seconds: 5));
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminToolPage()),
            );
            return;
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account not active')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => signuppage()),
                      );
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.79,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 0),
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Log in to explore, review, and understand the sentiments behind every dish you try.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 50),
                    Text(
                      'Email or Mobile Number',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: loginUser,
                        child: Center(child: Text('Login')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                          minimumSize: Size(100, 40),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => signup()),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
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