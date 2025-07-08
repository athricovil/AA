import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'chatbot_widget.dart';
import 'providers/cart_provider.dart';
import 'product.dart';
import 'app_config.dart';
import 'user_session.dart';
import 'home_page.dart'; // for loggedInUsername

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Razorpay _razorpay;
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _razorpay = Razorpay();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    }
    _loadProductsAndFetchCart();
  }

  Future<void> _loadProductsAndFetchCart() async {
    try {
      final response = await http.get(Uri.parse(AppConfig.apiBaseUrl + '/api/products'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _products = data.map((json) => Product.fromJson(json)).toList();
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        await cartProvider.fetchCart(_products);
        setState(() {});
      }
    } catch (e) {
      // Optionally handle error
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Successful: ${response.paymentId}')),
    );
    Provider.of<CartProvider>(context, listen: false).clearCart();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment Failed: ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External Wallet: ${response.walletName}')),
    );
  }

  void _openCheckout(double amount) {
    if (kIsWeb) {
      // Show a message for web users
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payments are currently supported only on mobile devices.')),
      );
      return;
    }

    var options = {
      'key': 'YOUR_RAZORPAY_KEY', // Replace with your Razorpay API key
      'amount': (amount * 100).toInt(),
      'name': 'Ayurayush',
      'description': 'Payment for Ayurvedic Products',
      'prefill': {
        'contact': '1234567890',
        'email': 'customer@ayurayush.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget _buildUserDropdown(BuildContext context) {
    // You can refactor this to a shared widget if needed
    // For now, copy the logic from home_page.dart
    return ValueListenableBuilder<String?>(
      valueListenable: loggedInUsername,
      builder: (context, username, _) {
        if (username != null && username.isNotEmpty) {
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
                  break;
                case 3:
                  break;
                case 4:
                  loggedInUsername.value = null;
                  UserSession.clearUserSession();
                  break;
              }
            },
          );
        } else {
          return PopupMenuButton<int>(
            icon: Icon(Icons.person_outline, color: Colors.black87),
            onSelected: (value) {
              switch (value) {
                case 0:
                  // Implement sign in overlay if needed
                  break;
                case 1:
                  // Implement register overlay if needed
                  break;
                case 2:
                  Navigator.pushNamed(context, '/cart');
                  break;
                case 3:
                  Navigator.pushNamed(context, '/my-account');
                  break;
                case 4:
                  break;
                case 5:
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 0, child: Row(children: [Icon(Icons.login, size: 18), SizedBox(width: 8), Text('Sign In')])),
              PopupMenuItem(value: 1, child: Row(children: [Icon(Icons.person_add, size: 18), SizedBox(width: 8), Text('Register')])),
              PopupMenuDivider(),
              PopupMenuItem(value: 2, child: Row(children: [Icon(Icons.shopping_cart, size: 18), SizedBox(width: 8), Text('My Cart')])),
              PopupMenuItem(value: 3, child: Row(children: [Icon(Icons.account_circle, size: 18), SizedBox(width: 8), Text('My Account')])),
              PopupMenuItem(value: 4, child: Row(children: [Icon(Icons.favorite_border, size: 18), SizedBox(width: 8), Text('My Wishlist')])),
              PopupMenuItem(value: 5, child: Row(children: [Icon(Icons.local_shipping, size: 18), SizedBox(width: 8), Text('Track Order')])),
              PopupMenuDivider(),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Stack(
            children: [
              Column(
                children: [
                  // Navbar (copied from homepage)
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Builder(
                              builder: (context) => IconButton(
                                icon: Icon(Icons.menu, color: Colors.black87, size: 28),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                              ),
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
                        Image.asset('assets/images/logo.png', height: 48),
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
                  // Notification bar
                  Container(
                    width: double.infinity,
                    color: Color(0xFF5A5A5A),
                    padding: EdgeInsets.symmetric(vertical: 6),
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
                    height: 54,
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
                  Expanded(
                    child: Stack(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Your Cart',
                                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                                      ),
                                      if (cartProvider.cartItems.isEmpty)
                                        Center(
                                          child: Text(
                                            'Your cart is empty.',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        )
                                      else
                                        Column(
                                          children: cartProvider.cartItems.map((item) {
                                            Widget imageWidget;
                                            if (item.image.startsWith('http')) {
                                              imageWidget = Image.network(item.image, width: 50, height: 50, fit: BoxFit.cover);
                                            } else {
                                              imageWidget = Image.asset(item.image, width: 50, height: 50, fit: BoxFit.cover);
                                            }
                                            return Card(
                                              elevation: 2,
                                              margin: EdgeInsets.symmetric(vertical: 8),
                                              child: ListTile(
                                                leading: imageWidget,
                                                title: Text(item.name),
                                                subtitle: Text(item.desc),
                                                trailing: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text('₹${item.price.toStringAsFixed(2)}',
                                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                                    IconButton(
                                                      icon: Icon(Icons.remove_circle, color: Colors.red, size: 24),
                                                      onPressed: () {
                                                        cartProvider.removeFromCart(item);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Card(
                                  elevation: 4,
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Order Summary',
                                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Subtotal'),
                                            Text('₹${cartProvider.totalPrice.toStringAsFixed(2)}'),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Delivery'),
                                            Text('FREE'),
                                          ],
                                        ),
                                        Divider(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Order Total',
                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '₹${cartProvider.totalPrice.toStringAsFixed(2)}',
                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (cartProvider.totalPrice > 0) {
                                              _openCheckout(cartProvider.totalPrice);
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orange[700],
                                            padding: EdgeInsets.symmetric(vertical: 12),
                                            minimumSize: Size(double.infinity, 50),
                                          ),
                                          child: Text(
                                            'Proceed to Buy',
                                            style: TextStyle(fontSize: 18, color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ChatbotWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            color: Color(0xFF4A2C2A),
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, size: 40, color: Colors.grey),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ValueListenableBuilder<String?>(
                            valueListenable: loggedInUsername,
                            builder: (context, username, _) {
                              return Text(
                                username != null && username.isNotEmpty ? username : 'Guest',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                          SizedBox(height: 4),
                          ValueListenableBuilder<String?>(
                            valueListenable: loggedInUsername,
                            builder: (context, username, _) {
                              return Text(
                                username != null && username.isNotEmpty ? 'Welcome back!' : 'Sign in to continue',
                                style: TextStyle(color: Colors.white, fontSize: 14),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Divider(color: Colors.white54),
                SizedBox(height: 16),
                _buildDrawerItem(Icons.home, 'Home', () {
                  Navigator.pushNamed(context, '/home');
                }),
                _buildDrawerItem(Icons.info, 'About Us', () {
                  Navigator.pushNamed(context, '/about');
                }),
                _buildDrawerItem(Icons.local_offer, 'Services', () {
                  Navigator.pushNamed(context, '/services');
                }),
                _buildDrawerItem(Icons.school, 'Courses', () {
                  Navigator.pushNamed(context, '/courses');
                }),
                _buildDrawerItem(Icons.person, 'Doctors', () {
                  Navigator.pushNamed(context, '/doctors');
                }),
                _buildDrawerItem(Icons.shopping_cart, 'Products', () {
                  Navigator.pushNamed(context, '/products');
                }),
                _buildDrawerItem(Icons.contact_mail, 'Contact Us', () {
                  Navigator.pushNamed(context, '/contact');
                }),
                _buildDrawerItem(Icons.help, 'FAQs', () {
                  Navigator.pushNamed(context, '/faqs');
                }),
                Spacer(),
                Divider(color: Colors.white54),
                SizedBox(height: 16),
                _buildDrawerItem(Icons.exit_to_app, 'Sign Out', () {
                  loggedInUsername.value = null;
                  UserSession.clearUserSession();
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                }),
                SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String text, VoidCallback onTap) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 24),
              SizedBox(width: 16),
              Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnderlineMenuItem(String title) {
    return InkWell(
      onTap: () {
        // Handle menu item tap
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
            Container(
              height: 2,
              color: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}