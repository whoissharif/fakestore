import 'package:equatable/equatable.dart';

/// Base event class for product detail events
abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object> get props => [];
}

/// Event to load a product by ID
class LoadProductDetailEvent extends ProductDetailEvent {
  final int productId;

  const LoadProductDetailEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

/// Event to refresh product details
class RefreshProductDetailEvent extends ProductDetailEvent {
  final int productId;

  const RefreshProductDetailEvent(this.productId);

  @override
  List<Object> get props => [productId];
}
