import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final Map product; // The product details passed from previous page
  final Function(Map) addToCart; // Function to add product to the cart
  final List cart; // The list of products in the cart

  const ProductDetailPage({
    super.key,
    required this.product,
    required this.addToCart,
    required this.cart,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 0; // Tracks the quantity of the product in the cart

  @override
  void initState() {
    super.initState();
    // Check if the product is already in the cart, and set the quantity if found
    final cartItem = widget.cart.firstWhere(
      (item) => item['id'] == widget.product['id'], // Check if product exists in cart by comparing IDs
      orElse: () => null, // Return null if the product is not found in cart
    );
    setState(() {
      _quantity = cartItem?['quantity'] ?? 0; // Set quantity to the value in the cart or 0 if not found
    });
  }

  void _addToCart() {
    widget.addToCart(widget.product); // Add product to the cart
    setState(() {
      _quantity++; // Increase the quantity of the product in the cart
    });
  }

  // Method to build the product's rating using star icons
  Widget _buildRating(double rating) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          Icons.star, // Star icon
          color: index < rating ? Colors.amber : Colors.grey, // Color the stars based on rating
          size: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product; // Extract product details passed from previous page

    return Scaffold(
      appBar: AppBar(
        title: Text(product['title']), // Set the title of the page to the product title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the body
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align elements to the start
          children: [
            Center(child: Image.network(product['image'], height: 200)), // Display product image
            const SizedBox(height: 20), // Add space between elements
            Text(
              product['title'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // Product title style
            ),
            Text(
              '\$${product['price']}',
              style: const TextStyle(fontSize: 18, color: Colors.green), // Price style with green color
            ),
            const SizedBox(height: 10), // Add space between text and description
            Text(product['description']), // Display product description
            const SizedBox(height: 20), // Add space before showing ratings
            _buildRating(product['rating']['rate'].toDouble()), // Display ratings as stars
            Text(
              '(${product['rating']['count']} reviews)', // Show the number of reviews
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 20), // Add space between rating and the buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space elements on the row evenly
              children: [
                // Button to add the product to the cart
                ElevatedButton(
                  onPressed: _addToCart, // Call _addToCart when button is pressed
                  child: Text(_quantity > 0
                      ? 'Add More to Cart ($_quantity)' // If the product is in cart, show quantity
                      : 'Add to Cart'), // Otherwise, show "Add to Cart"
                ),
                if (_quantity > 0) // Display the quantity in the cart if greater than 0
                  Text(
                    'In Cart: $_quantity', // Show the number of items in the cart
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

