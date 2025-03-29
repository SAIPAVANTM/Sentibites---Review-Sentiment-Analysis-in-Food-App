import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Urls.dart';
import '../HomePage/home.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;
  String message = "";
  bool otpSent = false;
  bool otpVerified = false;

  Future<void> sendOTP() async {
    if (emailController.text.isEmpty) {
      setState(() => message = "Please enter your email");
      return;
    }

    setState(() {
      isLoading = true;
      message = "Sending OTP...";
    });

    try {
      final response = await http.post(
        Uri.parse('${Url.Urls}/send_otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': emailController.text}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          otpSent = true;
          message = "OTP sent successfully";
        });
      } else {
        setState(() => message = data['message'] ?? "Failed to send OTP");
      }
    } catch (e) {
      setState(() => message = "Failed to send OTP. Please try again.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> verifyOTP() async {
    if (otpController.text.isEmpty) {
      setState(() => message = "Please enter OTP");
      return;
    }

    setState(() {
      isLoading = true;
      message = "Verifying OTP...";
    });

    try {
      final response = await http.post(
        Uri.parse('${Url.Urls}/verify_otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text,
          'otp': otpController.text,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == 'success') {
        setState(() {
          otpVerified = true;
          message = "OTP verified successfully";
        });
      } else {
        setState(() => message = data['message'] ?? "Invalid OTP");
      }
    } catch (e) {
      setState(() => message = "Verification failed. Please try again.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> resetPassword() async {
    if (newPasswordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      setState(() => message = "Please enter both passwords");
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      setState(() => message = "Passwords do not match");
      return;
    }

    setState(() {
      isLoading = true;
      message = "Resetting password...";
    });

    try {
      // For debugging
      print('Attempting password reset for email: ${emailController.text}');

      final response = await http.post(
        Uri.parse('${Url.Urls}/reset_password'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': emailController.text.trim(),
          'new_password': newPasswordController.text,
        }),
      ).timeout(Duration(seconds: 10)); // Add timeout

      // For debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Password reset successful"),
            backgroundColor: Colors.green,
          ),
        );

        // Clear all stored OTP data if you're storing it
        setState(() {
          otpVerified = false;
          otpSent = false;
        });

        // Navigate to login page
        await Future.delayed(Duration(seconds: 1));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false,
        );
      } else {
        setState(() => message = data['message'] ?? "Failed to reset password. Status: ${response.statusCode}");
      }
    } on TimeoutException catch (_) {
      setState(() => message = "Connection timed out. Please try again.");
    } catch (e) {
      print('Error during password reset: $e'); // For debugging
      setState(() => message = "Unable to connect to server. Please check your internet connection.");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget buildEmailStep() {
    return Column(
      children: [
        Text(
          'Enter your email address to receive OTP',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'Email Address',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: isLoading ? null : sendOTP,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text("Send OTP"),
        ),
      ],
    );
  }

  Widget buildOTPStep() {
    return Column(
      children: [
        Text(
          'Enter the OTP sent to your email',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        TextField(
          controller: otpController,
          decoration: InputDecoration(
            labelText: 'Enter OTP',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          keyboardType: TextInputType.number,
          maxLength: 6,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: isLoading ? null : sendOTP,
              child: Text("Resend OTP"),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : verifyOTP,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text("Verify OTP"),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildPasswordStep() {
    return Column(
      children: [
        Text(
          'Enter your new password',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        TextField(
          controller: newPasswordController,
          decoration: InputDecoration(
            labelText: 'New Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          obscureText: true,
        ),
        SizedBox(height: 20),
        TextField(
          controller: confirmPasswordController,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          obscureText: true,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: isLoading ? null : resetPassword,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text("Reset Password"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20),
              if (isLoading)
                Center(child: CircularProgressIndicator())
              else if (!otpSent)
                buildEmailStep()
              else if (!otpVerified)
                  buildOTPStep()
                else
                  buildPasswordStep(),
              SizedBox(height: 20),
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
      ),
    );
  }
}