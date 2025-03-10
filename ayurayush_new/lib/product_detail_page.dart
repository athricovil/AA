import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chatbot_widget.dart';
import 'providers/cart_provider.dart';

class ProductDetailPage extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductDetailPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Image.asset('assets/images/logo.png', height: 40),
                SizedBox(width: 10),
                Text('AYUR AYUSH'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                child: Text('Home', style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/about');
                },
                child: Text('About', style: TextStyle(color: Colors.white)),
              ),
              TextButton(onPressed: () {}, child: Text('Ayurveda', style: TextStyle(color: Colors.white))),
              TextButton(onPressed: () {}, child: Text('Doctors', style: TextStyle(color: Colors.white))),
              TextButton(onPressed: () {}, child: Text('Courses', style: TextStyle(color: Colors.white))),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/products');
                },
                child: Text('Products', style: TextStyle(color: Colors.white)),
              ),
              TextButton(onPressed: () {}, child: Text('Services', style: TextStyle(color: Colors.white))),
              TextButton(onPressed: () {}, child: Text('Contact', style: TextStyle(color: Colors.white))),
              IconButton(onPressed: () {}, icon: Icon(Icons.search, color: Colors.white)),
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                    icon: Icon(Icons.shopping_cart, color: Colors.white),
                  ),
                  if (cartProvider.cartItems.isNotEmpty)
                    Positioned(
                      right: 5,
                      top: 5,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          cartProvider.cartItems.length.toString(),
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ],
            backgroundColor: Color(0xFF4A2C2A),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      Center(
                        child: Image.asset(
                          product['image'],
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 20),
                      // Product Name
                      Text(
                        product['name'],
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      // Product Price
                      Text(
                        '₹${product['price'].toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      // Product Description
                      Text(
                        product['desc'],
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 20),
                      // Placeholder for Ratings
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.orange, size: 20),
                          Icon(Icons.star, color: Colors.orange, size: 20),
                          Icon(Icons.star, color: Colors.orange, size: 20),
                          Icon(Icons.star_half, color: Colors.orange, size: 20),
                          Icon(Icons.star_border, color: Colors.orange, size: 20),
                          SizedBox(width: 4),
                          Text(
                            '(4.2)',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // Add to Cart Button
                      ElevatedButton(
                        onPressed: () {
                          cartProvider.addToCart(CartItem(
                            name: product['name'],
                            image: product['image'],
                            desc: product['desc'],
                            price: product['price'],
                          ));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${product['name']} added to cart!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[700],
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_bag, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Add to Cart',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // Footer
                      Container(
                        padding: EdgeInsets.all(16),
                        color: Colors.grey[200],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.question_answer, color: Color(0xFF6A1B9A), size: 40),
                                SizedBox(width: 15),
                                Icon(Icons.person, color: Color(0xFF6A1B9A), size: 40),
                                SizedBox(width: 15),
                                Icon(Icons.video_call, color: Color(0xFF6A1B9A), size: 40),
                                SizedBox(width: 15),
                                Icon(Icons.book, color: Color(0xFF6A1B9A), size: 40),
                                SizedBox(width: 15),
                                Icon(Icons.library_books, color: Color(0xFF6A1B9A), size: 40),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Online support 24/7    Experienced doctors    Face to face interaction    Initial consultation    Free online library',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14, color: Color(0xFF6A1B9A)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ChatbotWidget(), // Include the chatbot on this page as well
            ],
          ),
          backgroundColor: Color(0xFFF5E6F5),
        );
      },
    );
  }
}