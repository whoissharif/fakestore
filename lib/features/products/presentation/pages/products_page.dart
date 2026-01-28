import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/product_card.dart';
import 'product_detail_page.dart';

/// Products List Page
/// This is the main page that displays all products
class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FakeStore'),
        actions: [
          // Theme toggle button
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return IconButton(
                icon: Icon(
                  themeMode == ThemeMode.light
                      ? Icons.dark_mode
                      : themeMode == ThemeMode.dark
                          ? Icons.light_mode
                          : Icons.brightness_auto,
                ),
                onPressed: () {
                  // Cycle through theme modes: light -> dark -> system
                  final themeCubit = context.read<ThemeCubit>();
                  if (themeMode == ThemeMode.light) {
                    themeCubit.setDarkTheme();
                  } else if (themeMode == ThemeMode.dark) {
                    themeCubit.setSystemTheme();
                  } else {
                    themeCubit.setLightTheme();
                  }
                },
                tooltip: 'Change theme',
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          // Loading state - show shimmer effect
          if (state is ProductsLoading) {
            return const ProductsLoadingWidget();
          }

          // Error state - show error message with retry button
          if (state is ProductsError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: () {
                // Trigger reload when retry is pressed
                context.read<ProductsBloc>().add(const LoadAllProductsEvent());
              },
            );
          }

          // Loaded state - show products in grid
          if (state is ProductsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                // Trigger refresh when user pulls down
                context.read<ProductsBloc>().add(const RefreshProductsEvent());

                // Wait for the refresh to complete
                await context.read<ProductsBloc>().stream.firstWhere(
                      (state) => state is! ProductsRefreshing,
                    );
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return Hero(
                    tag: 'product-${product.id}',
                    child: ProductCard(
                      product: product,
                      onTap: () {
                        // Navigate to product detail page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailPage(
                              productId: product.id,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }

          // Refreshing state - show products with loading indicator
          if (state is ProductsRefreshing) {
            return Stack(
              children: [
                // Show existing products
                GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: state.oldProducts.length,
                  itemBuilder: (context, index) {
                    final product = state.oldProducts[index];
                    return Hero(
                      tag: 'product-${product.id}',
                      child: ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                productId: product.id,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),

                // Loading indicator overlay
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            );
          }

          // Initial state - show empty container
          // This triggers the initial load
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
