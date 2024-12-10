import 'package:flutter/material.dart';
import 'product_detail_page.dart';

class SearchPage extends StatefulWidget {
  final List products;
  final Function(Map) addToCart; // Add this parameter
  final List cart; // Add this parameter

  const SearchPage({super.key, 
    required this.products,
    required this.addToCart,
    required this.cart,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List _filteredProducts = [];
  String _query = "";

  @override
  void initState() {
    super.initState();
    _filteredProducts = widget.products;
  }

  void _searchProducts(String query) {
    setState(() {
      _query = query.toLowerCase();
      _filteredProducts = widget.products.where((product) {
        return product['title'].toLowerCase().contains(_query);
      }).toList();
    });
  }

  void _navigateToProductDetail(Map product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(
          product: product,
          addToCart: widget.addToCart, // Pass addToCart
          cart: widget.cart, // Pass cart
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
            hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          onChanged: _searchProducts,
        ),
        backgroundColor: const Color.fromARGB(255, 6, 71, 128),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 238, 246, 252), 
      body: _filteredProducts.isEmpty
          ? const Center(child: Text('No products found.'))
          : ListView.builder(
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return GestureDetector(
                  onTap: () => _navigateToProductDetail(product),
                  child: ListTile(
                    leading: Image.network(product['image'], width: 50, height: 50),
                    title: Text(product['title']),
                    subtitle: Text('\$${product['price']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Text('${product['rating']['rate']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
