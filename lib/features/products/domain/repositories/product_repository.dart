import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';

/// Repository interface - defines what operations are available
/// The actual implementation will be in the data layer
/// This follows the Dependency Inversion Principle
abstract class ProductRepository {
  /// Get all products
  /// Returns Either<Failure, List<Product>>
  /// Left = Failure (error), Right = Success (list of products)
  Future<Either<Failure, List<Product>>> getAllProducts();

  /// Get a single product by ID
  Future<Either<Failure, Product>> getProductById(int id);

  /// Get products by category
  Future<Either<Failure, List<Product>>> getProductsByCategory(String category);
}
