import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_detail/product_detail_bloc.dart';
import '../bloc/product_detail/product_detail_event.dart';
import '../bloc/product_detail/product_detail_state.dart';
import '../widgets/error_widget.dart';

/// Product Detail Page
/// Shows detailed information about a single product
class ProductDetailPage extends StatelessWidget {
  final int productId;

  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Create a new ProductDetailBloc for this page from service locator
      create: (context) => sl<ProductDetailBloc>()
        ..add(LoadProductDetailEvent(productId)),
      child: Scaffold(
        body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            // Loading state
            if (state is ProductDetailLoading) {
              return _buildLoadingState(context);
            }

            // Error state
            if (state is ProductDetailError) {
              return ErrorDisplayWidget(
                message: state.message,
                onRetry: () {
                  context
                      .read<ProductDetailBloc>()
                      .add(LoadProductDetailEvent(productId));
                },
              );
            }

            // Loaded state
            if (state is ProductDetailLoaded) {
              return _buildLoadedState(context, state.product);
            }

            // Refreshing state
            if (state is ProductDetailRefreshing) {
              return _buildRefreshingState(context, state.oldProduct);
            }

            // Initial state
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// Loading state UI with shimmer effect
  Widget _buildLoadingState(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // App bar
        SliverAppBar(
          pinned: true,
          expandedHeight: 400,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
        // Loading content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 100,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Loaded state UI with product details
  Widget _buildLoadedState(BuildContext context, Product product) {
    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<ProductDetailBloc>()
            .add(RefreshProductDetailEvent(productId));
        await context.read<ProductDetailBloc>().stream.firstWhere(
              (state) => state is! ProductDetailRefreshing,
            );
      },
      child: CustomScrollView(
        slivers: [
          // App bar with image
          SliverAppBar(
            pinned: true,
            expandedHeight: 400,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${product.id}',
                child: Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  padding: const EdgeInsets.all(32),
                  child: CachedNetworkImage(
                    imageUrl: product.image,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error_outline,
                      size: 64,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Product details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.category.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Product title
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 8),

                  // Rating row
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 20,
                        color: Colors.amber[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.rate.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${product.rating.count} reviews)',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Price
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 24),

                  // Divider
                  const Divider(),

                  const SizedBox(height: 16),

                  // Description section
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),

                  const SizedBox(height: 32),

                  // Product details card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Product Details',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            context,
                            'ID',
                            '#${product.id}',
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            context,
                            'Category',
                            product.category,
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            context,
                            'Rating',
                            '${product.rating.rate}/5.0',
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            context,
                            'Reviews',
                            '${product.rating.count} reviews',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 100), // Space for floating button
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Refreshing state UI
  Widget _buildRefreshingState(BuildContext context, Product product) {
    return Stack(
      children: [
        _buildLoadedState(context, product),
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

  /// Helper method to build detail rows
  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
