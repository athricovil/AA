import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../app_config.dart';
import '../user_session.dart';
import '../product.dart';

class CartItem {
  final String name;
  final String image;
  final String desc;
  final double price;

  CartItem({
    required this.name,
    required this.image,
    required this.desc,
    required this.price,
  });
}

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  double get totalPrice {
    return _cartItems.fold(0, (sum, item) => sum + item.price);
  }

  Future<void> addToCart(CartItem item, {int? productId, List<Product>? productsList}) async {
    int? userId = await UserSession.getUserId();
    if (userId == null || userId == 0) {
      // Guest: local cart
      _cartItems.add(item);
      notifyListeners();
    } else {
      // Logged in: send to backend
      final token = await UserSession.getToken();
      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      final response = await http.post(
        Uri.parse(AppConfig.apiBaseUrl + '/cart'),
        headers: headers,
        body: jsonEncode({
          'userId': userId,
          'productId': productId,
          'quantity': 1,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (productsList != null) {
          await fetchCart(productsList); // Fetch from backend after add for logged-in users
        }
      } else {
        throw Exception('Failed to add to cart in backend');
      }
    }
  }

  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  Future<void> fetchCart(List<Product> productsList) async {
    int? userId = await UserSession.getUserId();
    if (userId == null || userId == 0) {
      // Guest: use local cart
      notifyListeners();
      return;
    }
    final token = await UserSession.getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final response = await http.get(
      Uri.parse(AppConfig.apiBaseUrl + '/cart/$userId'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      _cartItems = data.map((json) {
        final product = productsList.firstWhere(
          (p) => p.id == json['productId'],
          orElse: () => Product(
            id: json['productId'],
            name: 'Unknown',
            description: '',
            price: 0.0,
            imageUrl: '',
            rating: 0.0,
          ),
        );
        return CartItem(
          name: product.name,
          image: product.imageUrl,
          desc: product.description,
          price: product.price,
        );
      }).toList();
      notifyListeners();
    }
  }
}