import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/products/presentation/bloc/products_bloc.dart';
import 'features/products/presentation/bloc/products_event.dart';
import 'features/products/presentation/pages/products_page.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide ThemeCubit at the root level
        BlocProvider<ThemeCubit>(
          create: (context) => sl<ThemeCubit>(),
        ),

        // Provide ProductsBloc at the root level
        BlocProvider<ProductsBloc>(
          create: (context) => sl<ProductsBloc>()
            ..add(const LoadAllProductsEvent()), // Load products on startup
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'FakeStore',
            debugShowCheckedModeBanner: false,

            // Theme configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode, // System, light, or dark

            // Home page
            home: const ProductsPage(),
          );
        },
      ),
    );
  }
}
