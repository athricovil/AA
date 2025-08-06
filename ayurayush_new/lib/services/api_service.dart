import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import '../product.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // WooCommerce credentials (if still needed)
  final String baseUrl = "https://ayurayush.com/wp-json/wc/v3";
  final String consumerKey = "ck_c4c7b2972d01af62de8f88274bd194f0880498ac";
  final String consumerSecret = "cs_e1aa9a6bf9166785b52fdd0d42906084c24737af";

  // Cache for products to avoid repeated API calls
  List<Product>? _cachedProducts;
  DateTime? _lastFetchTime;
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  /// Fetch products from the main API endpoint
  Future<List<Product>> fetchProducts({bool forceRefresh = false}) async {
    // Return cached products if available and still valid
    if (!forceRefresh && 
        _cachedProducts != null && 
        _lastFetchTime != null &&
        DateTime.now().difference(_lastFetchTime!) < _cacheValidDuration) {
      return _cachedProducts!;
    }

    try {
      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/products'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _cachedProducts = data.map((json) => Product.fromJson(json)).toList();
        _lastFetchTime = DateTime.now();
        return _cachedProducts!;
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error while fetching products: $e');
    }
  }

  /// Fetch products from WooCommerce (legacy method if still needed)
  Future<List<dynamic>> fetchWooCommerceProducts() async {
    try {
      final String credentials = "$consumerKey:$consumerSecret";
      final String encodedCredentials = base64Encode(utf8.encode(credentials));

      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: {
          'Authorization': 'Basic $encodedCredentials',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load WooCommerce products: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching WooCommerce products: $e");
    }
  }

  /// Clear the product cache
  void clearCache() {
    _cachedProducts = null;
    _lastFetchTime = null;
  }

  /// Get a single product by ID from cache or API
  Future<Product?> getProductById(int id) async {
    final products = await fetchProducts();
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}
