import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'chatbot_widget.dart';
import 'providers/cart_provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) { // Initialize Razorpay only on non-web platforms
      _razorpay = Razorpay();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) { // Dispose Razorpay only on non-web platforms
      _razorpay.clear();
    }
    super.dispose();
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
                                  return Card(
                                    elevation: 2,
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    child: ListTile(
                                      leading: Image.asset(item.image, width: 50, height: 50, fit: BoxFit.cover),
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
          bottomNavigationBar: Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Row(
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
          ),
          backgroundColor: Color(0xFFF5E6F5),
        );
      },
    );
  }
}