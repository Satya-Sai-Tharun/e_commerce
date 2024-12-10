import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final response = await http.get(Uri.parse('https://fakestoreapi.com/users/1'));
      if (response.statusCode == 200) {
        setState(() {
          _userData = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch user data')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color.fromARGB(255, 6, 71, 128),
        titleTextStyle: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 238, 246, 252), 
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
              ? const Center(child: Text('No user data available'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${_userData!['name']['firstname']} ${_userData!['name']['lastname']}',
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      Text('Email: ${_userData!['email']}', style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      Text('Phone: ${_userData!['phone']}', style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      const Text('Address:', style: TextStyle(fontSize: 18)),
                      Text('${_userData!['address']['street']}, ${_userData!['address']['city']},',
                          style: const TextStyle(fontSize: 16)),
                      Text('${_userData!['address']['zipcode']}', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
    );
  }
}
