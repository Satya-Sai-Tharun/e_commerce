import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cart_page.dart';
import 'product_detail_page.dart';
import 'login_page.dart';
import 'searchPage.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _products = [];
  final List _cart = [];
  int _page = 1;
  bool _isLoading = false;
  String _sortCriteria = 'Price: Low to High';
  String _selectedCategory = 'All';
  String _selectedPriceRange = 'All';

  final Map<String, RangeValues> _priceRanges = {
    'All': const RangeValues(0, 10000),
    '0-100': const RangeValues(0, 100),
    '100-500': const RangeValues(100, 500),
    '500-1000': const RangeValues(500, 1000),
  };

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://fakestoreapi.com/products?limit=${_page * 10}'),
    );

    if (response.statusCode == 200) {
      final List newProducts = json.decode(response.body);
      setState(() {
        _products = newProducts;
        _page++;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _addToCart(Map product) {
    setState(() {
      // Check if the product already exists in the cart
      int index = _cart.indexWhere((item) => item['id'] == product['id']);
      if (index == -1) {
        // If product is not in the cart, add it with quantity 1
        _cart.add({...product, 'quantity': 1});
      } else {
        // If product is already in the cart, increment the quantity
        _cart[index]['quantity']++;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product['title']} added to cart')),
    );
  }

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

  Widget _buildRating(double rating) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          Icons.star,
          color: index < rating ? Colors.amber : Colors.grey,
          size: 16,
        ),
      ),
    );
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        backgroundColor: const Color.fromARGB(255, 6, 71, 128),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Change the color of back button and other icons
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(
                    products: _products,
                    addToCart: _addToCart, // Pass the _addToCart function
                    cart: _cart, // Pass the cart list
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 238, 246, 252),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: _sortCriteria,
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
                        _sortCriteria = value!;
                        _sortProducts();
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: _selectedCategory,
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
                        _filterProducts();
                      });
                    },
                  ),
                  DropdownButton<String>(
                    value: _selectedPriceRange,
                    items: _priceRanges.keys.map((String key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text(key),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPriceRange = value!;
                        _filterProducts();
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
                    _fetchProducts();
                  }
                  return true;
                },
                child: ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return ListTile(
                      leading: Image.network(product['image'], width: 50, height: 50),
                      title: Text(product['title']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('\$${product['price']}'),
                          _buildRating(product['rating']['rate'].toDouble()), // Rating displayed here
                          Text(
                            '(${product['rating']['count']} reviews)',
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(
                              product: product,
                              addToCart: _addToCart,
                              cart: _cart,
                            ),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () => _addToCart(product),
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
        currentIndex: _currentIndex,
        backgroundColor: const Color.fromARGB(255, 6, 71, 128),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartPage(cart: _cart),
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ),
            );
          } else {
            setState(() {
              _currentIndex = index;
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
