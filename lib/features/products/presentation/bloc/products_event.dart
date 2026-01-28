import 'package:equatable/equatable.dart';

/// Base event class for all product events
abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

/// Event to load all products
class LoadAllProductsEvent extends ProductsEvent {
  const LoadAllProductsEvent();
}

/// Event to refresh products (pull-to-refresh)
class RefreshProductsEvent extends ProductsEvent {
  const RefreshProductsEvent();
}
