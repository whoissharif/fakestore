import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';

/// Base state class for product detail states
abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object> get props => [];
}

/// Initial state - nothing has happened yet
class ProductDetailInitial extends ProductDetailState {
  const ProductDetailInitial();
}

/// Loading state - product is being fetched
class ProductDetailLoading extends ProductDetailState {
  const ProductDetailLoading();
}

/// Success state - product loaded successfully
class ProductDetailLoaded extends ProductDetailState {
  final Product product;

  const ProductDetailLoaded(this.product);

  @override
  List<Object> get props => [product];
}

/// Error state - something went wrong
class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError(this.message);

  @override
  List<Object> get props => [message];
}

/// Refreshing state - used for pull-to-refresh
class ProductDetailRefreshing extends ProductDetailState {
  final Product oldProduct;

  const ProductDetailRefreshing(this.oldProduct);

  @override
  List<Object> get props => [oldProduct];
}
