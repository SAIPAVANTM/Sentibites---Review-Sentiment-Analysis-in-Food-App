import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Urls.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final Map<String, String> userData;

  OTPVerificationScreen({
    required this.email,
    required this.userData,
  });

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  String message = "";
  bool isLoading = false;

  Future<void> sendOTP() async {
    setState(() {
      isLoading = true;
      message = "Sending OTP...";
    });

    try {
      final response = await http.post(
        Uri.parse('${Url.Urls}/send_otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': widget.email}),
      );
      final data = jsonDecode(response.body);
      setState(() {
        message = data['message'];
      });
    } catch (e) {
      setState(() {
        message = "Failed to send OTP. Please try again.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> verifyOTP() async {
    setState(() {
      isLoading = true;
      message = "Verifying OTP...";
    });

    try {
      final response = await http.post(
        Uri.parse('${Url.Urls}/verify_otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'otp': otpController.text,
        }),
      );

      final data = jsonDecode(response.body);
      setState(() {
        message = data['message'];
      });

      if (response.statusCode == 200 && data['status'] == 'success') {
        // Return true to indicate successful verification
        Navigator.pop(context, true);
      } else {
        setState(() {
          message = data['message'] ?? "Invalid OTP. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        message = "Verification failed. Please try again.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    sendOTP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Verification"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please verify your email",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "OTP sent to: ${widget.email}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            TextField(
              controller: otpController,
              decoration: InputDecoration(
                labelText: "Enter OTP",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
            ),
            SizedBox(height: 24),
            if (isLoading)
              CircularProgressIndicator()
            else
              Column(
                children: [
                  ElevatedButton(
                    onPressed: verifyOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Verify OTP",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: sendOTP,
                    child: Text("Resend OTP"),
                  ),
                ],
              ),
            SizedBox(height: 16),
            if (message.isNotEmpty)
              Text(
                message,
                style: TextStyle(
                  color: message.contains("success") ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}