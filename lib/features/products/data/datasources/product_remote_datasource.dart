import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/failures.dart';
import '../../../../core/utils/constants.dart';
import '../models/product_model.dart';

/// Interface for remote data source
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductById(int id);
  Future<List<ProductModel>> getProductsByCategory(String category);
}

/// Implementation of remote data source using HTTP client
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    return await _getProductsFromUrl(
      '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}',
    );
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(json.decode(response.body));
    } else {
      throw ServerFailure('Failed to load product');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    return await _getProductsFromUrl(
      '${ApiConstants.baseUrl}${ApiConstants.productsEndpoint}/category/$category',
    );
  }

  /// Helper method to reduce code duplication
  Future<List<ProductModel>> _getProductsFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw ServerFailure('Failed to load products');
    }
  }
}
