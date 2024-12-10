// import 'package:flutter/material.dart';

// class ProductDetailPage extends StatelessWidget {
//   final Map product;
//   final Function(Map) addToCart;

//   ProductDetailPage({required this.product, required this.addToCart});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(product['title']),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(product['image'], height: 200),
//             SizedBox(height: 20),
//             Text(
//               product['title'],
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               '\$${product['price']}',
//               style: TextStyle(fontSize: 18, color: Colors.green),
//             ),
//             SizedBox(height: 10),
//             Text(product['description']),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => addToCart(product),
//               child: Text('Add to Cart'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final Map product;
  final Function(Map) addToCart;
  final List cart;

  const ProductDetailPage({super.key, required this.product, required this.addToCart, required this.cart});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _quantity = 0;

  @override
  void initState() {
    super.initState();
    // Check if the product is already in the cart and set the quantity
    final cartItem = widget.cart.firstWhere(
      (item) => item['id'] == widget.product['id'],
      orElse: () => null,
    );
    setState(() {
      _quantity = cartItem?['quantity'] ?? 0;
    });
  }

  void _addToCart() {
    widget.addToCart(widget.product);
    setState(() {
      _quantity++;
    });
  }

  Widget _buildRating(double rating) {
    return Row(
      children: List.generate(
        5,
        (index) => Icon(
          Icons.star,
          color: index < rating ? Colors.amber : Colors.grey,
          size: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(product['image'], height: 200)),
            const SizedBox(height: 20),
            Text(
              product['title'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              '\$${product['price']}',
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
            const SizedBox(height: 10),
            Text(product['description']),
            const SizedBox(height: 20),
            _buildRating(product['rating']['rate'].toDouble()), // Display ratings
            Text(
              '(${product['rating']['count']} reviews)',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _addToCart,
                  child: Text(_quantity > 0 ? 'Add More to Cart ($_quantity)' : 'Add to Cart'),
                ),
                if (_quantity > 0)
                  Text(
                    'In Cart: $_quantity',
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
