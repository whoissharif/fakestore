import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_product_by_id.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

/// BLoC for managing product detail state
/// Handles loading a single product by ID
class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductById getProductById;

  ProductDetailBloc({
    required this.getProductById,
  }) : super(const ProductDetailInitial()) {
    // Register event handlers
    on<LoadProductDetailEvent>(_onLoadProductDetail);
    on<RefreshProductDetailEvent>(_onRefreshProductDetail);
  }

  /// Handler for LoadProductDetailEvent
  Future<void> _onLoadProductDetail(
    LoadProductDetailEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    // Emit loading state
    emit(const ProductDetailLoading());

    // Call the use case with product ID
    final result = await getProductById(ProductParams(id: event.productId));

    // Handle the result (Either<Failure, Product>)
    result.fold(
      // Left = Failure (error case)
      (failure) => emit(ProductDetailError(failure.message)),
      // Right = Success (success case)
      (product) => emit(ProductDetailLoaded(product)),
    );
  }

  /// Handler for RefreshProductDetailEvent
  Future<void> _onRefreshProductDetail(
    RefreshProductDetailEvent event,
    Emitter<ProductDetailState> emit,
  ) async {
    // If we have a product, show refreshing state
    if (state is ProductDetailLoaded) {
      final currentProduct = (state as ProductDetailLoaded).product;
      emit(ProductDetailRefreshing(currentProduct));
    } else {
      emit(const ProductDetailLoading());
    }

    // Call the use case
    final result = await getProductById(ProductParams(id: event.productId));

    // Handle the result
    result.fold(
      (failure) => emit(ProductDetailError(failure.message)),
      (product) => emit(ProductDetailLoaded(product)),
    );
  }
}
