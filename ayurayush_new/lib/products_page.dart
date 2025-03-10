import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chatbot_widget.dart';
import 'providers/cart_provider.dart';

class ProductsPage extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {'name': 'Pilopouse', 'image': 'assets/images/pilopouse.jpg', 'desc': 'Herbal supplement for health.', 'price': 2195.00},
    {'name': 'Prostostop', 'image': 'assets/images/prostostop.jpg', 'desc': 'Supports prostate health.', 'price': 875.00},
    {'name': 'Saffron Care', 'image': 'assets/images/saffron_care.jpg', 'desc': 'Skin-nourishing oil.', 'price': 3895.00},
    {'name': 'Stomacalm', 'image': 'assets/images/stomacalm.jpg', 'desc': 'Digestive health support.', 'price': 1599.00},
    {'name': 'Vaji Cap', 'image': 'assets/images/vaji_cap.jpg', 'desc': 'Herbal supplements to improve sexual capacity.', 'price': 2499.00},
  ];

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
                            Navigator.pushNamed(context, '/products/${product['name'].toLowerCase()}');
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
                                    child: Container(
                                      color: Colors.white,
                                      child: Image.asset(
                                        product['image'],
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['name'],
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
                                        product['desc'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        '₹${product['price'].toStringAsFixed(2)}',
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
                                          Icon(Icons.star, color: Colors.orange, size: 16),
                                          Icon(Icons.star, color: Colors.orange, size: 16),
                                          Icon(Icons.star_half, color: Colors.orange, size: 16),
                                          Icon(Icons.star_border, color: Colors.orange, size: 16),
                                          SizedBox(width: 4),
                                          Text(
                                            '(4.2)',
                                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
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
              ),
              ChatbotWidget(),
            ],
          ),
          backgroundColor: Color(0xFFF5E6F5),
        );
      },
    );
  }
}