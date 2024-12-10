import 'package:flutter/material.dart';
import 'home_page.dart';
// import 'cart_page.dart';

class CheckoutPage extends StatelessWidget {
  final List cart;

  const CheckoutPage({super.key, required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: const Color.fromARGB(255, 6, 71, 128),
        titleTextStyle: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 238, 246, 252), 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Assume checkout is complete. Reset the cart.',
              style: TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () {
                // Reset the cart and navigate back to HomePage
                cart.clear();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false,
                );
              },
              child: const Text('Reset', style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 6, 71, 127))),
            ),
            const SizedBox(height: 16),
            const Text(
              'Assume checkout is incomplete.',
              style: TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate back to CartPage with the existing cart contents
                Navigator.pop(context);
              },
              child: const Text('Back', style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 6, 71, 127))),
            ),
          ],
        ),
      ),
    );
  }
}
