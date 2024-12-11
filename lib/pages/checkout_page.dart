import 'package:flutter/material.dart'; 
import 'home_page.dart'; 
// import 'cart_page.dart';

// StatelessWidget used because this page doesn't have dynamic data (checkout is assumed complete)
class CheckoutPage extends StatelessWidget {
  final List cart; // Cart passed from the CartPage, containing items for checkout

  const CheckoutPage({super.key, required this.cart}); // Constructor to initialize cart

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'), // Title for the checkout page
        backgroundColor: const Color.fromARGB(255, 6, 71, 128), // Custom color for the app bar
        titleTextStyle: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white), // App bar title style
        iconTheme: const IconThemeData(
          color: Colors.white, // Icon color in the app bar (white)
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 238, 246, 252), // Light background color for the page
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the content inside the body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children widgets to fill the available width
          children: [
            const Text(
              'Assume checkout is complete. Reset the cart.', // Text to indicate that the checkout process is completed
              style: TextStyle(fontSize: 16), // Style for the message text
            ),
            ElevatedButton(
              onPressed: () {
                // Reset the cart and navigate back to HomePage when the button is pressed
                cart.clear(); // Clears the cart, indicating the checkout has been completed
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage
                  (route) => false, // Removes all previous routes from the stack (so back button doesn't return to CheckoutPage)
                );
              },
              child: const Text('Reset', style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 6, 71, 127))), // Text for the reset button
            ),
            const SizedBox(height: 16), // Adds space between the buttons
            const Text(
              'Assume checkout is incomplete.', // Text to indicate that checkout was not completed
              style: TextStyle(fontSize: 16), // Style for the message text
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the CartPage with the existing cart contents when the button is pressed
                Navigator.pop(context); // Pops the current CheckoutPage from the navigation stack, returning to the previous page (CartPage)
              },
              child: const Text('Back', style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 6, 71, 127))), // Text for the back button
            ),
          ],
        ),
      ),
    );
  }
}
