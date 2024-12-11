import 'package:flutter/material.dart'; 
import 'checkout_page.dart'; // Importing the CheckoutPage class for navigation

// StatefulWidget to manage dynamic data changes (cart items and quantities)
class CartPage extends StatefulWidget {
  final List cart; // Cart items passed from another page

  const CartPage({super.key, required this.cart}); // Constructor to initialize the cart

  @override
  _CartPageState createState() => _CartPageState(); // Creates the state object for this widget
}

class _CartPageState extends State<CartPage> {
  // Method to increment the quantity of an item in the cart
  void _incrementQuantity(int index) {
    setState(() {
      if (widget.cart[index]['quantity'] == null) {
        widget.cart[index]['quantity'] = 1; // Initialize quantity if null
      } else {
        widget.cart[index]['quantity']++; // Increment the quantity
      }
    });
  }

  // Method to decrement the quantity of an item in the cart
  void _decrementQuantity(int index) {
    setState(() {
      if (widget.cart[index]['quantity'] != null && widget.cart[index]['quantity'] > 1) {
        widget.cart[index]['quantity']--; // Decrease quantity if it's greater than 1
      } else {
        widget.cart.removeAt(index); // Remove the item from the cart if quantity reaches 0
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the total cost of all items in the cart
    double total = widget.cart.fold(0.0, (sum, item) {
      final price = item['price'] ?? 0.0; // Default price is 0 if null
      final quantity = item['quantity'] ?? 1; // Default quantity is 1 if null

      return sum + (price * quantity); // Add product price * quantity to the total
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'), // Displays the title of the page
        backgroundColor: const Color.fromARGB(255, 6, 71, 128), // Custom app bar color
        titleTextStyle: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white), // App bar text style
        iconTheme: const IconThemeData(
          color: Colors.white, // Icon color in the app bar
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 238, 246, 252), // Light background color for the page
      body: widget.cart.isEmpty
          ? const Center(child: Text('Your cart is empty')) // Message when cart is empty
          : ListView.builder(
              itemCount: widget.cart.length, // Number of items in the cart
              itemBuilder: (context, index) {
                final product = widget.cart[index]; // Get product details for the current item

                return ListTile(
                  leading: Image.network(product['image'], width: 50, height: 50), // Product image
                  title: Text(product['title']), // Product title
                  subtitle: Text('\$${product['price']} x ${product['quantity']}'), // Price and quantity
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min, // Align buttons tightly
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, color: Colors.red), // Decrease quantity button
                        onPressed: () => _decrementQuantity(index), // Decrease quantity handler
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.green), // Increase quantity button
                        onPressed: () => _incrementQuantity(index), // Increase quantity handler
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.black), // Remove item button
                        onPressed: () {
                          setState(() {
                            widget.cart.removeAt(index); // Remove item from cart
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the bottom navigation bar
        child: Column(
          mainAxisSize: MainAxisSize.min, // Wrap content height
          children: [
            Text(
              'Total: \$${total.toStringAsFixed(2)}', // Display the total cost
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                if (widget.cart.isEmpty) {
                  // Show a snackbar message if the cart is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cart is empty add items to checkout', style: TextStyle(color: Colors.red))),
                  );
                } else {
                  // Navigate to the checkout page with cart data if cart is not empty
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(cart: widget.cart),
                    ),
                  );
                }
              },
              child: const Text('Checkout', style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 6, 71, 127))), // Checkout button
            ),
          ],
        ),
      ),
    );
  }
}
