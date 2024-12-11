import 'package:flutter/material.dart';
import 'product_detail_page.dart';

class SearchPage extends StatefulWidget {
  final List products; // List of products to display and search through
  final Function(Map) addToCart; // Function to add products to the cart
  final List cart; // List representing the current cart

  // Constructor to receive products, addToCart function, and cart
  const SearchPage({super.key, 
    required this.products,
    required this.addToCart,
    required this.cart,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List _filteredProducts = []; // List to store filtered products based on search query
  String _query = ""; // The search query entered by the user

  @override
  void initState() {
    super.initState();
    _filteredProducts = widget.products; // Initially, show all products
  }

  // Function to filter products based on the search query
  void _searchProducts(String query) {
    setState(() {
      _query = query.toLowerCase(); // Convert query to lowercase to make search case-insensitive
      // Filter the products list based on whether the product title contains the search query
      _filteredProducts = widget.products.where((product) {
        return product['title'].toLowerCase().contains(_query);
      }).toList();
    });
  }

  // Function to navigate to the ProductDetailPage when a product is tapped
  void _navigateToProductDetail(Map product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          product: product, // Pass the selected product to the ProductDetailPage
          addToCart: widget.addToCart, // Pass the addToCart function to allow adding products to the cart
          cart: widget.cart, // Pass the current cart to show the correct cart status
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with a search bar
      appBar: AppBar(
        title: TextField(
          autofocus: true, // Automatically focus on the search bar when the page loads
          decoration: const InputDecoration(
            hintText: 'Search products...', // Placeholder text in the search bar
            border: InputBorder.none, // Remove the border for a cleaner look
            hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 18, // Style for the placeholder text
            ),
          ),
          onChanged: _searchProducts, // Call _searchProducts every time the user types
        ),
        backgroundColor: const Color.fromARGB(255, 6, 71, 128), // Background color of the AppBar
        iconTheme: const IconThemeData(
          color: Colors.white, // White icons in the AppBar
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 238, 246, 252), // Background color of the page
      body: _filteredProducts.isEmpty
          ? const Center(child: Text('No products found.')) // Message displayed if no products match the search
          : ListView.builder(
              itemCount: _filteredProducts.length, // The number of products to display
              itemBuilder: (context, index) {
                final product = _filteredProducts[index]; // Get the current product from the filtered list
                return GestureDetector(
                  onTap: () => _navigateToProductDetail(product), // Navigate to the ProductDetailPage on tap
                  child: ListTile(
                    leading: Image.network(product['image'], width: 50, height: 50), // Display product image
                    title: Text(product['title']), // Display product title
                    subtitle: Text('\$${product['price']}'), // Display product price
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16), // Display a star icon for rating
                        Text('${product['rating']['rate']}'), // Display product rating
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
