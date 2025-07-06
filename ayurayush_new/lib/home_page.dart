import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'chatbot_widget.dart';
import 'providers/cart_provider.dart';
import 'styles.dart';
import 'login.dart';
import 'signup.dart';

ValueNotifier<String?> loggedInUsername = ValueNotifier<String?>(null);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  final double videoHeight = 300.0; // Define videoHeight with a suitable value

  bool _showAuthOverlay = false;
  bool _showLogin = true; // true: login, false: register
  bool _showDrawer = false;

  void _openAuthOverlay(bool login) async {
    setState(() {
      _showAuthOverlay = true;
      _showLogin = login;
    });

    final result = await showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 380,
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    login ? "Sign In" : "Register",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 12),
              login ? LoginPageContent() : SignupPageContent(),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(login ? "Don't have an account? " : "Already have an account? "),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _openAuthOverlay(!login);
                    },
                    child: Text(login ? "Register" : "Sign In"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (result == 'show_signin') {
      // Registration success, open sign in modal
      _openAuthOverlay(true);
    } else if (result != null && result.isNotEmpty) {
      loggedInUsername.value = result;
    }
    setState(() {
      _showAuthOverlay = false;
    });
  }

  void _closeAuthOverlay() {
    setState(() {
      _showAuthOverlay = false;
    });
  }

  void _openDrawer() {
    setState(() {
      _showDrawer = true;
    });
  }

  void _closeDrawer() {
    setState(() {
      _showDrawer = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/AAV_web.mp4');
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller.setVolume(0);
      _controller.setLooping(true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.play();
      });
      setState(() {});
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
        return Stack(
          children: [
            Column(
              children: [
                // Navbar (logo and icons row)
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 32), // more vertical space, wider padding
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Hamburger and search
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.menu, color: Colors.black87, size: 28),
                            onPressed: _openDrawer,
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                          SizedBox(width: 12),
                          IconButton(
                            icon: Icon(Icons.search, color: Colors.black87, size: 26),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ],
                      ),
                      // Centered logo
                      Image.asset('assets/images/logo.png', height: 48),
                      // User and cart icons with dropdown
                      Row(
                        children: [
                          _buildUserDropdown(context),
                          Stack(
                            children: [
                              IconButton(
                                icon: Icon(Icons.shopping_bag_outlined, color: Colors.black87, size: 28),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/cart');
                                },
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              ),
                              if (cartProvider.cartItems.isNotEmpty)
                                Positioned(
                                  right: 6,
                                  top: 6,
                                  child: CircleAvatar(
                                    radius: 8,
                                    backgroundColor: Colors.red,
                                    child: Text(
                                      cartProvider.cartItems.length.toString(),
                                      style: TextStyle(fontSize: 10, color: Colors.white),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Notification bar (announcement bar) below navbar
                Container(
                  width: double.infinity,
                  color: Color(0xFF5A5A5A),
                  padding: EdgeInsets.symmetric(vertical: 6), // slightly taller
                  child: Center(
                    child: Text(
                      'Flat Rs 200 cashback on first Mobikwik UPI transaction*',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, decoration: TextDecoration.underline, decorationColor: Color.fromARGB(255, 196, 196, 196), decorationThickness: 2),
                    ),
                  ),
                ),
                // Horizontal menu
                Container(
                  color: Colors.white,
                  height: 54, // taller menu bar
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildUnderlineMenuItem('Home'),
                        _buildUnderlineMenuItem('About Us'),
                        _buildUnderlineMenuItem('Services'),
                        _buildUnderlineMenuItem('Courses'),
                        _buildUnderlineMenuItem('Doctors'),
                        _buildUnderlineMenuItem('Products'),
                        _buildUnderlineMenuItem('Contact Us'),
                        _buildUnderlineMenuItem('FAQs'),
                      ],
                    ),
                  ),
                ),
                // Expanded body
                Expanded(
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    body: Stack(
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            double screenWidth = MediaQuery.of(context).size.width;
                            int crossAxisCount = 1;
                            if (screenWidth >= 1200) {
                              crossAxisCount = 4;
                            } else if (screenWidth >= 900) {
                              crossAxisCount = 3;
                            } else if (screenWidth >= 600) {
                              crossAxisCount = 2;
                            }
                            double cardAspectRatio = 0.75;
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
                                        child: FutureBuilder(
                                          future: _initializeVideoPlayerFuture,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState == ConnectionState.done) {
                                              return VideoPlayer(_controller);
                                            } else {
                                              return Center(child: CircularProgressIndicator());
                                            }
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: screenWidth,
                                        height: videoHeight,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              const Color.fromARGB(0, 255, 255, 255),
                                              Color.fromARGB(255, 255, 255, 255),
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
                                            crossAxisCount: crossAxisCount,
                                            crossAxisSpacing: 24,
                                            mainAxisSpacing: 24,
                                            childAspectRatio: cardAspectRatio,
                                          ),
                                          itemCount: products.length,
                                          itemBuilder: (context, index) {
                                            final product = products[index];
                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(context, '/products/${product['name'].toLowerCase()}');
                                              },
                                              child: Card(
                                                elevation: 4,
                                                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(16),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(16),
                                                            topRight: Radius.circular(16),
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
                                                      SizedBox(height: 8),
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
                                                            borderRadius: BorderRadius.circular(8),
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
                              ));
                          },
                        ),
                        ChatbotWidget(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Drawer overlay
            if (_showDrawer)
              Positioned.fill(
                child: Material(
                  color: Colors.black.withOpacity(0.3),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 350,
                      color: Colors.white,
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top row: logo and close button
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset('assets/images/logo.png', height: 40),
                                  IconButton(
                                    icon: Icon(Icons.close, size: 28),
                                    onPressed: _closeDrawer,
                                  ),
                                ],
                              ),
                            ),
                            // Sign in / Register
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      _closeDrawer();
                                      _openAuthOverlay(true);
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Sign in', style: TextStyle(fontSize: 18, color: Colors.black, decoration: TextDecoration.underline)),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      _closeDrawer();
                                      _openAuthOverlay(false);
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Register', style: TextStyle(fontSize: 18, color: Colors.black, decoration: TextDecoration.underline)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(),
                            // Menu items
                            Expanded(
                              child: ListView(
                                children: [
                                  _buildDrawerMenuItem('Home', Icons.home),
                                  _buildDrawerMenuItem('About Us', null),
                                  _buildDrawerMenuItem('Services', null),
                                  _buildDrawerMenuItem('Courses', null),
                                  _buildDrawerMenuItem('Doctors', null),
                                  _buildDrawerMenuItem('Products', null),
                                  _buildDrawerMenuItem('Contact Us', null),
                                  _buildDrawerMenuItem('FAQ', null),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            // Overlay for login/register
            if (_showAuthOverlay)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeAuthOverlay,
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {}, // Prevent tap from closing overlay
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            width: 380,
                            padding: EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _showLogin ? "Sign In" : "Register",
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: _closeAuthOverlay,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                _showLogin
                                    ? LoginPageContent()
                                    : SignupPageContent(),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(_showLogin
                                        ? "Don't have an account? "
                                        : "Already have an account? "),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _showLogin = !_showLogin;
                                        });
                                      },
                                      child: Text(_showLogin ? "Register" : "Sign In"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }



  Widget _buildUnderlineMenuItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: const Color.fromARGB(221, 0, 0, 0),
              fontWeight: FontWeight.w500,
              decorationColor: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ],
      ),
    );
  }

 

  Widget _buildUserDropdown(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: loggedInUsername,
      builder: (context, username, _) {
        if (username != null && username.isNotEmpty) {
          // Show username and custom menu
          return PopupMenuButton<int>(
            icon: Row(
              children: [
                Icon(Icons.person_outline, color: Colors.black87),
                SizedBox(width: 4),
                Text(username, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
              ],
            ),
            offset: Offset(0, 40),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Row(
                  children: [Icon(Icons.shopping_cart, color: Colors.black87), SizedBox(width: 12), Text('My Cart')],
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Row(
                  children: [Icon(Icons.account_circle, color: Colors.black87), SizedBox(width: 12), Text('My Account')],
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: Row(
                  children: [Icon(Icons.favorite_border, color: Colors.black87), SizedBox(width: 12), Text('My Wishlist')],
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: Row(
                  children: [Icon(Icons.local_shipping, color: Colors.black87), SizedBox(width: 12), Text('Track Order')],
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: 4,
                child: Row(
                  children: [Icon(Icons.logout, color: Colors.black87), SizedBox(width: 12), Text('Sign Out')],
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 0:
                  Navigator.pushNamed(context, '/cart');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/my-account');
                  break;
                case 2:
                  // TODO: Navigate to wishlist
                  break;
                case 3:
                  // TODO: Navigate to track order
                  break;
                case 4:
                  loggedInUsername.value = null; // Logout
                  break;
              }
            },
          );
        } else {
          // Show Sign In/Register only, no Sign Out
          return PopupMenuButton<int>(
            icon: Icon(Icons.person_outline, color: Colors.black87),
            onSelected: (value) {
              switch (value) {
                case 0:
                  _openAuthOverlay(true); // Sign In
                  break;
                case 1:
                  _openAuthOverlay(false); // Register
                  break;
                case 2:
                  Navigator.pushNamed(context, '/cart');
                  break;
                case 3:
                  Navigator.pushNamed(context, '/my-account');
                  break;
                case 4:
                  // TODO: Wishlist
                  break;
                case 5:
                  // TODO: Track order
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 0, child: Row(children: [Icon(Icons.login, size: 18), SizedBox(width: 8), Text('Sign In')])) ,
              PopupMenuItem(value: 1, child: Row(children: [Icon(Icons.person_add, size: 18), SizedBox(width: 8), Text('Register')])) ,
              PopupMenuDivider(),
              PopupMenuItem(value: 2, child: Row(children: [Icon(Icons.shopping_cart, size: 18), SizedBox(width: 8), Text('My Cart')])) ,
              PopupMenuItem(value: 3, child: Row(children: [Icon(Icons.account_circle, size: 18), SizedBox(width: 8), Text('My Account')])) ,
              PopupMenuItem(value: 4, child: Row(children: [Icon(Icons.favorite_border, size: 18), SizedBox(width: 8), Text('My Wishlist')])) ,
              PopupMenuItem(value: 5, child: Row(children: [Icon(Icons.local_shipping, size: 18), SizedBox(width: 8), Text('Track Order')])) ,
              PopupMenuDivider(),
              // No Sign Out here
            ],
          );
        }
      },
    );
  }

  Widget _buildDrawerMenuItem(String title, IconData? icon) {
    return ListTile(
      leading: icon != null ? Icon(icon, color: Colors.black87) : null,
      title: Text(
        title,
        style: TextStyle(fontSize: 22, color: Colors.black87, fontWeight: FontWeight.w400),
      ),
      onTap: () {
        // TODO: Add navigation logic for each menu item
        _closeDrawer();
      },
    );
  }
}