import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_all_products.dart';
import 'products_event.dart';
import 'products_state.dart';

/// BLoC for managing products state
/// This is the bridge between UI and business logic
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetAllProducts getAllProducts;

  ProductsBloc({
    required this.getAllProducts,
  }) : super(const ProductsInitial()) {
    // Register event handlers
    on<LoadAllProductsEvent>(_onLoadAllProducts);
    on<RefreshProductsEvent>(_onRefreshProducts);
  }

  /// Handler for LoadAllProductsEvent
  Future<void> _onLoadAllProducts(
    LoadAllProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    // Emit loading state
    emit(const ProductsLoading());

    // Call the use case
    final result = await getAllProducts(NoParams());

    // Handle the result (Either<Failure, List<Product>>)
    result.fold(
      // Left = Failure (error case)
      (failure) => emit(ProductsError(failure.message)),
      // Right = Success (success case)
      (products) => emit(ProductsLoaded(products)),
    );
  }

  /// Handler for RefreshProductsEvent
  /// This keeps the old products visible while refreshing
  Future<void> _onRefreshProducts(
    RefreshProductsEvent event,
    Emitter<ProductsState> emit,
  ) async {
    // If we have products, show refreshing state
    if (state is ProductsLoaded) {
      final currentProducts = (state as ProductsLoaded).products;
      emit(ProductsRefreshing(currentProducts));
    } else {
      emit(const ProductsLoading());
    }

    // Call the use case
    final result = await getAllProducts(NoParams());

    // Handle the result
    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (products) => emit(ProductsLoaded(products)),
    );
  }
}
