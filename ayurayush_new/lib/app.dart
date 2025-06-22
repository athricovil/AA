import 'package:flutter/material.dart';
import 'about_page.dart';
import 'products_page.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';
import 'my_account.dart';
import 'home_page.dart';
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
        '/my-account': (context) => MyAccountPage(),
      },
    );
  }
}
