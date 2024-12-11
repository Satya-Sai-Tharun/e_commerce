import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _userData; // Stores the fetched user data
  bool _isLoading = true; // Tracks the loading state while fetching data

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data when the page is initialized
  }

  // Function to fetch user data from an API endpoint
  Future<void> _fetchUserData() async {
    try {
      // HTTP GET request to fetch user data from the API
      final response = await http.get(Uri.parse('https://fakestoreapi.com/users/1'));
      if (response.statusCode == 200) {
        // If the response is successful, parse the JSON and update the state
        setState(() {
          _userData = json.decode(response.body); // Decode JSON response into a map
          _isLoading = false; // Set loading to false once data is fetched
        });
      } else {
        // If the response is not successful, show a failure message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch user data')),
        );
        setState(() {
          _isLoading = false; // Stop loading even on failure
        });
      }
    } catch (error) {
      // If an error occurs during the fetch, display an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
      setState(() {
        _isLoading = false; // Stop loading on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'), // Title of the page
        backgroundColor: const Color.fromARGB(255, 6, 71, 128), // App bar color
        titleTextStyle: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        iconTheme: const IconThemeData(
          color: Colors.white, // Color of the app bar icons
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 238, 246, 252), // Page background color
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading spinner while data is being fetched
          : _userData == null
              ? const Center(child: Text('No user data available')) // Show message if no user data is found
              : Padding(
                padding: const EdgeInsets.all(16.0), // Add padding around the content
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start of the column
                    children: [
                      // Display user's first and last name
                      Text('Name: ${_userData!['name']['firstname']} ${_userData!['name']['lastname']}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 10), // Add space between elements
                      // Display user's email address
                      Text('Email: ${_userData!['email']}', style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 10), // Add space between elements
                      // Display user's phone number
                      Text('Phone: ${_userData!['phone']}', style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 10), // Add space between elements
                      const Text('Address:', style: TextStyle(fontSize: 18)), // Label for address section
                      // Display street address and city
                      Text('${_userData!['address']['street']}, ${_userData!['address']['city']},',
                          style: const TextStyle(fontSize: 16)),
                      // Display zipcode
                      Text('${_userData!['address']['zipcode']}', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
    );
  }
}
