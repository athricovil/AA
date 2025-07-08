import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'chatbot_widget.dart';
import 'providers/cart_provider.dart';
import 'product.dart';
import 'app_config.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(AppConfig.apiBaseUrl + '/api/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

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
          body: FutureBuilder<List<Product>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: \\${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No products found.'));
              }
              final products = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Ayurvedic Products',
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () {
                            // Implement navigation to product detail if needed
                          },
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    ),
                                    child: product.imageUrl.isNotEmpty
                                        ? Image.network(
                                            product.imageUrl,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(color: Colors.grey[200]),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        product.description,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '₹ {product.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.star, color: Colors.orange, size: 16),
                                          SizedBox(width: 4),
                                          Text(
                                            '(${product.rating.toStringAsFixed(1)})',
                                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      ElevatedButton(
                                        onPressed: () {
                                          cartProvider.addToCart(CartItem(
                                            name: product.name,
                                            image: product.imageUrl,
                                            desc: product.description,
                                            price: product.price,
                                          ));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('${product.name} added to cart!')),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange[700],
                                          minimumSize: Size(double.infinity, 40),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          padding: EdgeInsets.symmetric(vertical: 8),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.shopping_bag, color: Colors.white, size: 18),
                                            SizedBox(width: 4),
                                            Text(
                                              'Add to Cart',
                                              style: TextStyle(fontSize: 14, color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
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
              );
            },
          ),
          backgroundColor: Color(0xFFF5E6F5),
        );
      },
    );
  }
}