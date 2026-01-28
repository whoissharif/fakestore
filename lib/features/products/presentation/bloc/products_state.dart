import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

/// Base state class for all product states
abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

/// Initial state - nothing has happened yet
class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

/// Loading state - data is being fetched
class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

/// Success state - data loaded successfully
class ProductsLoaded extends ProductsState {
  final List<Product> products;

  const ProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

/// Error state - something went wrong
class ProductsError extends ProductsState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object> get props => [message];
}

/// Refreshing state - used for pull-to-refresh
/// Keeps the old products visible while refreshing
class ProductsRefreshing extends ProductsState {
  final List<Product> oldProducts;

  const ProductsRefreshing(this.oldProducts);

  @override
  List<Object> get props => [oldProducts];
}
