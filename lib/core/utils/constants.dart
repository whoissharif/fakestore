/// API Configuration
class ApiConstants {
  static const String baseUrl = 'https://fakestoreapi.com';

  // Endpoints
  static const String productsEndpoint = '/products';
  static const String categoriesEndpoint = '/products/categories';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

/// App Constants
class AppConstants {
  static const String appName = 'FakeStore';
}
