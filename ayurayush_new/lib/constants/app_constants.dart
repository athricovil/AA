class AppConstants {
  // UI Constants
  static const double videoHeight = 300.0;
  static const double dialogWidth = 400.0;
  static const double dialogMaxHeightRatio = 0.8;
  static const int maxQuantityLimit = 10;
  
  // Colors
  static const int primaryColorValue = 0xFF4A2C2A;
  static const int appBarColorValue = 0xFF530B50;
  
  // Durations
  static const int cacheValidityMinutes = 5;
  
  // API Endpoints (relative paths)
  static const String productsEndpoint = '/products';
  static const String cartEndpoint = '/cart';
  
  // Asset Paths
  static const String logoPath = 'assets/images/logo.png';
  static const String logoAyurayushPath = 'assets/images/logo-ayurayush.jpg';
  static const String videoPath = 'assets/videos/AAV_web.mp4';
  
  // Text Constants
  static const String appName = 'Ayurayush';
  static const String signInTitle = 'Sign In';
  static const String registerTitle = 'Register';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String alreadyHaveAccount = "Already have an account? ";
  
  // Error Messages
  static const String networkError = 'Network error while fetching products';
  static const String loadProductsError = 'Failed to load products';
  static const String paymentFailedError = 'Payment Failed';
  static const String paymentSuccessMessage = 'Payment Successful';
  
  // Payment
  static const String razorpayKey = 'YOUR_RAZORPAY_KEY';
  static const String paymentDescription = 'Payment for Ayurvedic Products';
  static const String defaultContact = '1234567890';
  static const String defaultEmail = 'customer@ayurayush.com';
}