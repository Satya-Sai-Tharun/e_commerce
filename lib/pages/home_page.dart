import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // For making HTTP requests to fetch products
import 'cart_page.dart'; // Import CartPage to navigate to the shopping cart
import 'product_detail_page.dart'; // Import ProductDetailPage to navigate to product details
import 'login_page.dart'; // Import LoginPage to navigate back to the login screen
import 'searchPage.dart'; // Import SearchPage for search functionality
import 'profile_page.dart'; // Import ProfilePage for user profile functionality

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _products = []; // List to store fetched products
  final List _cart = []; // List to store cart items
  int _page = 1; // Variable to manage pagination when fetching products
  bool _isLoading = false; // To prevent multiple simultaneous fetch requests
  String _sortCriteria = 'Price: Low to High'; // Default sorting option
  String _selectedCategory = 'All'; // Default selected category filter
  String _selectedPriceRange = 'All'; // Default selected price range filter

  // Define the price ranges for filtering products
  final Map<String, RangeValues> _priceRanges = {
    'All': const RangeValues(0, 10000),
    '0-100': const RangeValues(0, 100),
    '100-500': const RangeValues(100, 500),
    '500-1000': const RangeValues(500, 1000),
  };

  // Initialize and fetch products when the page loads
  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  // Fetch products from the API
  Future<void> _fetchProducts() async {
    if (_isLoading) return; // Prevent multiple fetch requests
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://fakestoreapi.com/products?limit=10&page=$_page'),
    );

    if (response.statusCode == 200) {
      final List newProducts = json.decode(response.body); // Decode the response body
      setState(() {
        _products.addAll(newProducts); // Add new products to the existing list
        _page++; // Increment the page number for the next fetch
      });
    }

    setState(() {
      _isLoading = false; // Reset loading status
    });
  }

  // Add a product to the cart
  void _addToCart(Map product) {
    setState(() {
      int index = _cart.indexWhere((item) => item['id'] == product['id']);
      if (index == -1) {
        _cart.add({...product, 'quantity': 1}); // Add new product with quantity
      } else {
        _cart[index]['quantity']++; // Increment quantity if the product already exists in the cart
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product['title']} added to cart')), // Show a snack bar notification
    );
  }

  // Sort products based on the selected criteria
  void _sortProducts() {
    setState(() {
      if (_sortCriteria == 'Price: Low to High') {
        _products.sort((a, b) => a['price'].compareTo(b['price']));
      } else if (_sortCriteria == 'Price: High to Low') {
        _products.sort((a, b) => b['price'].compareTo(a['price']));
      } else if (_sortCriteria == 'Rating') {
        _products.sort((a, b) => b['rating']['rate'].compareTo(a['rating']['rate']));
      }
    });
  }

  // Filter products based on selected category and price range
  void _filterProducts() {
    final selectedRange = _priceRanges[_selectedPriceRange]!;
    setState(() {
      _products = _products.where((product) {
        final matchesCategory = _selectedCategory == 'All' || product['category'] == _selectedCategory;
        final withinPriceRange = product['price'] >= selectedRange.start && product['price'] <= selectedRange.end;
        return matchesCategory && withinPriceRange;
      }).toList();
    });
  }

  // Build the rating stars for each product based on its rating
  Widget _buildRating(double rating) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          Icons.star,
          color: index < rating ? Colors.amber : Colors.grey, // Gold stars for the rating
          size: 16,
        ),
      ),
    );
  }

  int _currentIndex = 0; // To track the selected index in the bottom navigation bar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'), // Title of the HomePage
        backgroundColor: const Color.fromARGB(255, 6, 71, 128), // App bar background color
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Icon color in the app bar
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search), // Search icon in the app bar
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(
                    products: _products, // Pass products to SearchPage
                    addToCart: _addToCart, // Pass addToCart function to SearchPage
                    cart: _cart, // Pass cart to SearchPage
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout), // Logout icon in the app bar
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to the login page
              );
            },
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 238, 246, 252), // Background color for the body
        child: Column(
          children: [
            // Dropdowns for sorting, category, and price range filters
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: _sortCriteria, // Sort criteria selected
                    items: [
                      'Price: Low to High',
                      'Price: High to Low',
                      'Rating',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _sortCriteria = value!; // Update sort criteria
                        _sortProducts(); // Apply sorting
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: _selectedCategory, // Selected category for filtering
                    items: [
                      'All',
                      'electronics',
                      'jewelery',
                      'men\'s clothing',
                      'women\'s clothing',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                        _filterProducts(); // Apply category filter
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: _selectedPriceRange, // Selected price range for filtering
                    items: _priceRanges.keys.map((String key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text(key),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPriceRange = value!;
                        _filterProducts(); // Apply price range filter
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                      !_isLoading) {
                    _fetchProducts(); // Fetch more products when scrolled to the bottom
                  }
                  return true;
                },
                child: ListView.builder(
                  itemCount: _products.length + (_isLoading ? 1 : 0), // Add one for loading indicator
                  itemBuilder: (context, index) {
                    if (index == _products.length) {
                      return const Center(child: CircularProgressIndicator()); // Show loading indicator at the end
                    }
                    final product = _products[index];
                    return ListTile(
                      leading: Image.network(product['image'], width: 50, height: 50), // Display product image
                      title: Text(product['title']), // Display product title
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('\$${product['price']}'), // Display product price
                          _buildRating(product['rating']['rate'].toDouble()), // Display product rating
                          Text(
                            '(${product['rating']['count']} reviews)',
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      onTap: () {
                        // Navigate to the product details page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(
                              product: product,
                              addToCart: _addToCart, // Pass addToCart function to ProductDetailPage
                              cart: _cart, // Pass cart to ProductDetailPage
                            ),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.add_shopping_cart), // Add to cart icon
                        onPressed: () => _addToCart(product), // Add product to the cart
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Track selected index in the bottom navigation
        backgroundColor: const Color.fromARGB(255, 6, 71, 128),
        selectedItemColor: Colors.white, // Color for selected item
        unselectedItemColor: Colors.white70, // Color for unselected items
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartPage(cart: _cart), // Navigate to CartPage
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(), // Navigate to ProfilePage
              ),
            );
          } else {
            setState(() {
              _currentIndex = index; // Update selected index for home
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}
