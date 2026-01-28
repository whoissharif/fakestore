import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

/// UseCase: Get Product By ID
/// Takes a product ID and returns a single product
class GetProductById implements UseCase<Product, ProductParams> {
  final ProductRepository repository;

  GetProductById(this.repository);

  @override
  Future<Either<Failure, Product>> call(ProductParams params) async {
    return await repository.getProductById(params.id);
  }
}

/// Parameters for GetProductById usecase
class ProductParams extends Equatable {
  final int id;

  const ProductParams({required this.id});

  @override
  List<Object> get props => [id];
}
