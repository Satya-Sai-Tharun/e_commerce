import 'package:flutter/material.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  final List cart;

  const CartPage({super.key, required this.cart});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Increment quantity
  void _incrementQuantity(int index) {
    setState(() {
      if (widget.cart[index]['quantity'] == null) {
        widget.cart[index]['quantity'] = 1;
      } else {
        widget.cart[index]['quantity']++;
      }
    });
  }

  // Decrement quantity
  void _decrementQuantity(int index) {
    setState(() {
      if (widget.cart[index]['quantity'] != null && widget.cart[index]['quantity'] > 1) {
        widget.cart[index]['quantity']--;
      } else {
        widget.cart.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double total = widget.cart.fold(0.0, (sum, item) {
      final price = item['price'] ?? 0.0;
      final quantity = item['quantity'] ?? 1;

      return sum + (price * quantity);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: const Color.fromARGB(255, 6, 71, 128),
        titleTextStyle: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 238, 246, 252), 
      body: widget.cart.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : ListView.builder(
              itemCount: widget.cart.length,
              itemBuilder: (context, index) {
                final product = widget.cart[index];

                return ListTile(
                  leading: Image.network(product['image'], width: 50, height: 50),
                  title: Text(product['title']),
                  subtitle: Text('\$${product['price']} x ${product['quantity']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, color: Colors.red),
                        onPressed: () => _decrementQuantity(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.green),
                        onPressed: () => _incrementQuantity(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            widget.cart.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                if (widget.cart.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cart is empty')),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckoutPage(cart: widget.cart),
                    ),
                  );
                }
              },
              child: const Text('Checkout', style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 6, 71, 127))),
            ),
          ],
        ),
      ),
    );
  }
}
