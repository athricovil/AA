import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'chatbot_widget.dart';
import 'providers/cart_provider.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
                child: Text('Home'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/about');
                },
                child: Text('About'),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Ayurveda'),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Doctors'),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Courses'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/products');
                },
                child: Text('Products'),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Services'),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Contact'),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.search),
              ),
              Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                    icon: Icon(Icons.shopping_cart),
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
                                    // ignore: deprecated_member_use
                                    Color(0xFFF5E6F5).withOpacity(1.0),
                                  ],
                                  stops: [0.85, 1.0],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 0, bottom: 10),
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
                              Text(
                                'About us',
                                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Ayur Ayush',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Welcome to Ayur-Ayush, your gateway to the profound wisdom of Authentic and Traditional Ayurveda. Nestled in the heart of Kerala, Ayurayush invites you to embark on a journey towards holistic health and wellness through time-honored Ayurvedic practices.',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Embracing modern technology, Ayurayush extends its services beyond physical boundaries, offering Online Ayurvedic consultations and follow-up health checkups to ensure continued well-being. Our comprehensive range of offerings includes authentic Ayurvedic treatments, enriching Ayurveda courses, and a curated selection of genuine Ayurvedic products, all tailored to meet your individual needs.',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'ESSENCE OF AYURVEDA',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Ayurveda, a 5,000-year-old system of natural healing emphasizes a balanced lifestyle. The term Ayurveda is derived from two Sanskrit words ayur (life) and veda (science or knowledge). Thus, Ayurveda means "knowledge of life". Ayurveda encourages certain lifestyle, Diet habits, natural therapies and Herbal medication to regain a balance between the body, mind, spirit, and the environment. The concepts of universal interconnectedness (Panchamahabhoothas), the body\'s constitution (prakriti), and life forces (doshas) are the primary basis of Ayurvedic medicine. Goal of Ayurvedic treatment is eliminating impurities from the body, reducing symptoms, increasing resistance to disease, reducing worry, and increasing harmony in life. Herbs and animal products are used extensively in Ayurvedic medicines.',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Get unique experience!',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green),
                                      SizedBox(width: 10),
                                      Text('With our treatment you have access to world-class practitioners'),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green),
                                      SizedBox(width: 10),
                                      Text('Personalized online consultations'),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green),
                                      SizedBox(width: 10),
                                      Text('Convenient Access - Easily access online and offline consultation'),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green),
                                      SizedBox(width: 10),
                                      Text('Natural herbal remedies'),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green),
                                      SizedBox(width: 10),
                                      Text('Experienced Ayurveda practitioners'),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green),
                                      SizedBox(width: 10),
                                      Text('Holistic Approach - Holistic treatment'),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.check_circle, color: Colors.green),
                                      SizedBox(width: 10),
                                      Text('Side-effect free'),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Text(
                                'www.ayurayush.com',
                                style: TextStyle(fontSize: 16, decoration: TextDecoration.underline),
                              ),
                              Text(
                                '+1(650) 695-7707',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                'info@ayurayush.com',
                                style: TextStyle(fontSize: 16, decoration: TextDecoration.underline),
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
              ChatbotWidget(), // Add the chatbot widget here
            ],
          ),
          backgroundColor: Color(0xFFF5E6F5),
        );
      },
    );
  }
}