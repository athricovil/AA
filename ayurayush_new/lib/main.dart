import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'about_page.dart';
import 'products_page.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';
import 'chatbot_widget.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ayurayush',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: '/home',
      onGenerateRoute: (settings) {
        if (settings.name!.startsWith('/products/')) {
          final productName = settings.name!.split('/').last.toLowerCase();
          final products = [
            {'name': 'Pilopouse', 'image': 'assets/images/pilopouse.jpg', 'desc': 'Herbal supplement for health.', 'price': 2195.00},
            {'name': 'Prostostop', 'image': 'assets/images/prostostop.jpg', 'desc': 'Supports prostate health.', 'price': 875.00},
            {'name': 'Saffron Care', 'image': 'assets/images/saffron_care.jpg', 'desc': 'Skin-nourishing oil.', 'price': 3895.00},
            {'name': 'Stomacalm', 'image': 'assets/images/stomacalm.jpg', 'desc': 'Digestive health support.', 'price': 1599.00},
            {'name': 'Vaji Cap', 'image': 'assets/images/vaji_cap.jpg', 'desc': 'Herbal supplements to improve sexual capacity.', 'price': 2499.00},
          ];
          final product = products.firstWhere(
            (p) => (p['name'] as String?)?.toLowerCase() == productName,
            orElse: () => {},
          );
          if (product.isNotEmpty) {
            return MaterialPageRoute(
              builder: (context) => ProductDetailPage(product: product),
            );
          }
          return MaterialPageRoute(builder: (context) => HomePage());
        }
        return MaterialPageRoute(builder: (context) => HomePage());
      },
      routes: {
        '/home': (context) => HomePage(),
        '/about': (context) => AboutPage(),
        '/products': (context) => ProductsPage(),
        '/cart': (context) => CartPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/output.mp4')
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      }).catchError((error) {
        print('Video initialization error: $error');
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 40,
                  child: Image.asset('assets/images/logo.png', height: 40, fit: BoxFit.contain),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'AYUR AYUSH',
                    style: TextStyle(fontSize: 20),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
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
              LayoutBuilder(
                builder: (context, constraints) {
                  double screenWidth = constraints.maxWidth;
                  double videoHeight = screenWidth * 9 / 16;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: screenWidth,
                              height: videoHeight,
                              child: _controller.value.isInitialized
                                  ? VideoPlayer(_controller)
                                  : Center(child: CircularProgressIndicator()),
                            ),
                            Container(
                              width: screenWidth,
                              height: videoHeight,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Color(0xFFF5E6F5).withOpacity(0.8),
                                  ],
                                  stops: [0.7, 1.0],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 10),
                          child: Column(
                            children: [
                              Text(
                                'Relax, Revive & Rejuvenate',
                                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF6A1B9A)),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6A1B9A)),
                                child: Text('Book a Plan'),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  'Products',
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
                                        Icon(Icons.question_answer, color: Color(0xFF6A1B9A), size: 30),
                                        SizedBox(width: 10),
                                        Icon(Icons.person, color: Color(0xFF6A1B9A), size: 30),
                                        SizedBox(width: 10),
                                        Icon(Icons.video_call, color: Color(0xFF6A1B9A), size: 30),
                                        SizedBox(width: 10),
                                        Icon(Icons.book, color: Color(0xFF6A1B9A), size: 30),
                                        SizedBox(width: 10),
                                        Icon(Icons.library_books, color: Color(0xFF6A1B9A), size: 30),
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
                      ],
                    ),
                  );
                },
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