import 'package:flutter/material.dart'; 
import 'pages/login_page.dart'; // Importing the custom login page from the 'pages' directory

// The main function is the entry point of the Flutter application
void main() {
  runApp(EcommerceApp()); // Runs the EcommerceApp widget as the root of the application
}

// The main widget of the application, representing the whole app
class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key}); // Constructor for the EcommerceApp class with a super key

  @override
  Widget build(BuildContext context) {
    // The build method returns the UI structure of the app
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Disables the debug banner in the app
      title: 'E commerce', // The title of the application, used in app metadata
      theme: ThemeData(
        primarySwatch: Colors.blue, // Sets the primary theme color to blue
      ),
      home: LoginPage(), // Sets the initial page of the app to LoginPage
    );
  }
}
