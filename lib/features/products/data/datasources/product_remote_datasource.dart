import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/constants.dart';
import '../models/product_model.dart';

/// Interface for remote data source
abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductById(int id);
  Future<List<ProductModel>> getProductsByCategory(String category);
}

/// Implementation of remote data source using Dio
/// Dio provides better error handling, interceptors, and request cancellation
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient dioClient;

  ProductRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await dioClient.get(
        ApiConstants.productsEndpoint,
      );

      // Dio automatically decodes JSON
      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await dioClient.get(
        '${ApiConstants.productsEndpoint}/$id',
      );

      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await dioClient.get(
        '${ApiConstants.productsEndpoint}/category/$category',
      );

      final List<dynamic> jsonList = response.data;
      return jsonList.map((json) => ProductModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw ServerFailure('Unexpected error: ${e.toString()}');
    }
  }

  /// Handle Dio errors and convert to appropriate Failures
  /// This centralizes error handling logic
  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection timeout');

      case DioExceptionType.badResponse:
        // Server responded with an error
        final statusCode = error.response?.statusCode;
        switch (statusCode) {
          case 400:
            return const ServerFailure('Bad request');
          case 401:
            return const ServerFailure('Unauthorized');
          case 403:
            return const ServerFailure('Forbidden');
          case 404:
            return const ServerFailure('Not found');
          case 500:
            return const ServerFailure('Internal server error');
          default:
            return ServerFailure('Server error: $statusCode');
        }

      case DioExceptionType.connectionError:
        return const NetworkFailure('No internet connection');

      case DioExceptionType.cancel:
        return const ServerFailure('Request cancelled');

      case DioExceptionType.badCertificate:
        return const ServerFailure('Bad certificate');

      case DioExceptionType.unknown:
        return ServerFailure('Unknown error: ${error.message}');
    }
  }
}
