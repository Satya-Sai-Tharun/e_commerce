import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // Import HTTP package for network requests
import 'home_page.dart'; // Import HomePage to navigate after successful login

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController(); // Controller for username input
  final TextEditingController _passwordController = TextEditingController(); // Controller for password input
  bool _isLoading = false; // A boolean to control loading state during network requests

  // Method to handle login
  Future<void> _login() async {
    setState(() {
      _isLoading = true; // Set loading state to true while waiting for login
    });

    // Send POST request for login
    final response = await http.post(
      Uri.parse('https://fakestoreapi.com/auth/login'),
      body: json.encode({
        'username': _usernameController.text, // Send username entered by the user
        'password': _passwordController.text, // Send password entered by the user
      }),
      headers: {'Content-Type': 'application/json'}, // Specify content type
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body); // Decode the JSON response
      if (data['token'] != null) { // Check if login is successful (token received)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid login credentials')), // Show error if invalid credentials
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to log in')), // Show error if the request fails
      );
    }

    setState(() {
      _isLoading = false; // Reset loading state once the response is received
    });
  }

  // Method to handle registration
  Future<void> _register() async {
    setState(() {
      _isLoading = true; // Set loading state to true while waiting for registration
    });

    // Send POST request for registration
    final response = await http.post(
      Uri.parse('https://fakestoreapi.com/users'),
      body: json.encode({
        'email': 'John@gmail.com', // Sample email
        'username': 'johnd', // Sample username
        'password': 'm38rmF', // Sample password (escaped $ character)
        'name': {
          'firstname': 'John', // First name for registration
          'lastname': 'Doe', // Last name for registration
        },
        'address': {
          'city': 'kilcoole', // Sample address fields
          'street': '7835 new road',
          'number': 3,
          'zipcode': '12926-3874',
          'geolocation': {
            'lat': '-37.3159', // Latitude of the address
            'long': '81.1496', // Longitude of the address
          },
        },
        'phone': '1-570-236-7033', // Sample phone number
      }),
      headers: {'Content-Type': 'application/json'}, // Specify content type
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully registered!')), // Show success message after registration
      );
      await Future.delayed(const Duration(seconds: 3)); // Wait before redirecting to login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), // Navigate back to LoginPage
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to register')), // Show error if registration fails
      );
    }

    setState(() {
      _isLoading = false; // Reset loading state once the response is received
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login or Register'), // App bar title
        backgroundColor: const Color.fromARGB(255, 6, 71, 128), // App bar background color
        titleTextStyle: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white), // Style for title
        iconTheme: const IconThemeData(
          color: Colors.white, // Icon color in the app bar
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 227, 236, 242), // Background color for the page
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the main body
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
          children: [
            // Username input field
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0), // Add padding below the TextField
              child: TextField(
                controller: _usernameController, // Controller for username input
                decoration: InputDecoration(
                  labelText: 'Username', // Label for the username field
                  labelStyle: const TextStyle(
                      color: Colors.blueAccent, fontWeight: FontWeight.bold),
                  hintText: 'Enter your username', // Placeholder text
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white, // Fill the text field with white color
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners for the input field
                    borderSide: BorderSide.none, // Removes border for a cleaner look
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.blueAccent, width: 3),
                  ),
                ),
                style: const TextStyle(fontSize: 16, color: Colors.black), // Style for input text
              ),
            ),
            // Password input field
            TextField(
              controller: _passwordController, // Controller for password input
              decoration: InputDecoration(
                labelText: 'Password', // Label for the password field
                labelStyle: const TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.bold),
                hintText: 'Enter your password', // Placeholder text
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white, // Fill the text field with white color
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Rounded corners for the input field
                  borderSide: BorderSide.none, // Removes border for a cleaner look
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.blueAccent, width: 3),
                ),
              ),
              style: const TextStyle(fontSize: 16, color: Colors.black), // Style for input text
            ),
            const SizedBox(height: 20), // Add spacing between elements
            _isLoading
                ? const CircularProgressIndicator() // Show loading spinner while logging in or registering
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Login button
                      ElevatedButton(
                        onPressed: _login, // Trigger login function
                        child: const Text('Login', style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 6, 71, 127))),
                      ),
                      const SizedBox(height: 10), // Add spacing between buttons
                      // Register button
                      ElevatedButton(
                        onPressed: _register, // Trigger register function
                        child: const Text('Register', style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 6, 71, 127))),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
