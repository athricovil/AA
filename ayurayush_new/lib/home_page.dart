import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'chatbot_widget.dart';
import 'providers/cart_provider.dart';
import 'styles.dart'; // <-- Import your styles file

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
               Image.asset('assets/images/logo.png', height: 40),
                SizedBox(width: 10),
                
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                child: Text('Home', style: kNavbarButtonTextStyle),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/about');
                },
                child: Text('About', style: kNavbarButtonTextStyle),
              ),
              // TextButton(onPressed: () {}, child: Text('Ayurveda', style: kNavbarButtonTextStyle)),
              // TextButton(onPressed: () {}, child: Text('Doctors', style: kNavbarButtonTextStyle)),
              // TextButton(onPressed: () {}, child: Text('Courses', style: kNavbarButtonTextStyle)),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/products');
                },
                child: Text('Products', style: kNavbarButtonTextStyle),
              ),
              // TextButton(onPressed: () {}, child: Text('Services', style: kNavbarButtonTextStyle)),
              // TextButton(onPressed: () {}, child: Text('Contact', style: kNavbarButtonTextStyle)),
              IconButton(onPressed: () {}, icon: Icon(Icons.search, color: const Color.fromARGB(255, 0, 0, 0))),
              IconButton(onPressed: () { Navigator.pushNamed(context, '/my-account');}, icon: Icon(Icons.account_circle, color: const Color.fromARGB(255, 0, 0, 0))),
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                    icon: Icon(Icons.shopping_cart, color: const Color.fromARGB(255, 0, 0, 0)),
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
                          style: kCartBadgeTextStyle,
                        ),
                      ),
                    ),
                ],
              ),
            ],
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                        // Stack(
                        //   children: [
                        //     Container(
                        //       width: screenWidth,
                        //       height: videoHeight,
                        //       child: _controller.value.isInitialized
                        //           ? VideoPlayer(_controller)
                        //           : Center(child: CircularProgressIndicator()),
                        //     ),
                        //     Container(
                        //       width: screenWidth,
                        //       height: videoHeight,
                        //       decoration: BoxDecoration(
                        //         gradient: LinearGradient(
                        //           begin: Alignment.topCenter,
                        //           end: Alignment.bottomCenter,
                        //           colors: [
                        //             Colors.transparent,
                        //             const Color.fromARGB(255, 196, 186, 186),
                        //           ],
                        //           stops: [0.7, 1.0],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Padding(
                          padding: EdgeInsets.only(top: 5, bottom: 10),
                          child: Column(
                            children: [
                              Text(
                                'Relax, Revive & Rejuvenate',
                                style: kSectionTitleStyle,
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(backgroundColor: kPrimaryButtonColor),
                                child: Text('Book a Plan', style: kButtonTextStyle),
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  'Products',
                                  style: kSectionTitleStyle,
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
                                                  style: kProductTitleStyle,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  product['desc'],
                                                  style: kProductDescStyle,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  '₹${product['price'].toStringAsFixed(2)}',
                                                  style: kProductPriceStyle,
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
                                                      style: kProductRatingStyle,
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
                                                    backgroundColor: kAddToCartButtonColor,
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
                                                        style: kButtonTextStyle,
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
                                color: const Color.fromARGB(255, 255, 255, 255),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.question_answer, color: kSupportIconColor, size: 30),
                                        SizedBox(width: 10),
                                        Icon(Icons.person, color: kSupportIconColor, size: 30),
                                        SizedBox(width: 10),
                                        Icon(Icons.video_call, color: kSupportIconColor, size: 30),
                                        SizedBox(width: 10),
                                        Icon(Icons.book, color: kSupportIconColor, size: 30),
                                        SizedBox(width: 10),
                                        Icon(Icons.library_books, color: kSupportIconColor, size: 30),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Online support 24/7    Experienced doctors    Face to face interaction    Initial consultation    Free online library',
                                      textAlign: TextAlign.center,
                                      style: kSupportTextStyle,
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
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        );
      },
    );
  }
}