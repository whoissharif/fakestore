# FakeStore - Clean Architecture Guide

## Project Structure

```
lib/
├── core/                          # Shared utilities
│   ├── di/                        # Dependency Injection
│   │   └── injection_container.dart
│   ├── error/                     # Error handling
│   │   └── failures.dart
│   ├── network/                   # Network utilities
│   │   └── network_info.dart
│   ├── theme/                     # Theme system
│   │   ├── app_colors.dart
│   │   ├── app_theme.dart
│   │   └── theme_cubit.dart
│   ├── usecases/                  # Base usecase
│   │   └── usecase.dart
│   └── utils/                     # Constants
│       └── constants.dart
│
└── features/
    └── products/
        ├── data/                  # Data Layer
        │   ├── datasources/       # API calls
        │   │   └── product_remote_datasource.dart
        │   ├── models/            # Data models
        │   │   └── product_model.dart
        │   └── repositories/      # Repository implementation
        │       └── product_repository_impl.dart
        │
        ├── domain/                # Domain Layer (Pure Dart)
        │   ├── entities/          # Business objects
        │   │   └── product.dart
        │   ├── repositories/      # Repository contracts
        │   │   └── product_repository.dart
        │   └── usecases/          # Business logic
        │       └── get_all_products.dart
        │
        └── presentation/          # Presentation Layer (UI)
            ├── bloc/              # State management
            │   ├── products_bloc.dart
            │   ├── products_event.dart
            │   └── products_state.dart
            ├── pages/             # Screens
            │   └── products_page.dart
            └── widgets/           # Reusable widgets
                ├── product_card.dart
                ├── loading_widget.dart
                └── error_widget.dart
```

## Data Flow (How it works)

### 1. App Startup
```
main.dart
  ↓
initializeDependencies() - Register all dependencies
  ↓
MultiBlocProvider - Provide BLoCs to widget tree
  ↓
ProductsBloc receives LoadAllProductsEvent
```

### 2. Loading Products Flow
```
User opens app
  ↓
[UI] ProductsPage displays loading state
  ↓
[BLoC] ProductsBloc receives LoadAllProductsEvent
  ↓
[BLoC] Emits ProductsLoading state
  ↓
[UseCase] GetAllProducts.call(NoParams)
  ↓
[Repository] ProductRepository.getAllProducts()
  ↓
[Repository] Checks network connectivity (NetworkInfo)
  ↓
[DataSource] ProductRemoteDataSource makes API call
  ↓
[API] GET https://fakestoreapi.com/products
  ↓
[DataSource] Receives JSON → Converts to ProductModel
  ↓
[Repository] Returns Either<Failure, List<Product>>
  ↓
[BLoC] Receives result → Emits ProductsLoaded or ProductsError
  ↓
[UI] Updates based on new state (shows products or error)
```

### 3. Pull to Refresh Flow
```
User pulls down
  ↓
[UI] Triggers RefreshProductsEvent
  ↓
[BLoC] Emits ProductsRefreshing (keeps old products visible)
  ↓
[BLoC] Calls GetAllProducts usecase
  ↓
... (same flow as above)
  ↓
[UI] Shows new products when loaded
```

### 4. Theme Toggle Flow
```
User taps theme button
  ↓
[UI] Calls ThemeCubit.setDarkTheme() (or light/system)
  ↓
[Cubit] Emits new ThemeMode
  ↓
[UI] MaterialApp rebuilds with new theme
```

## Key Concepts

### 1. Clean Architecture Layers

**Domain Layer** (innermost - pure business logic)
- Contains entities, repository interfaces, and use cases
- Has NO dependencies on Flutter or external packages
- Only depends on pure Dart

**Data Layer** (outer layer - implementation details)
- Implements repository interfaces from domain
- Handles API calls, database operations
- Converts between models and entities

**Presentation Layer** (outermost - UI)
- Contains widgets, pages, and BLoCs
- Depends on domain layer (uses entities and use cases)
- Handles user interactions

### 2. Dependency Rule
Dependencies point INWARD:
- Presentation → Domain
- Data → Domain
- Domain → Nothing (pure Dart)

### 3. BLoC Pattern
**Event → BLoC → State**
- UI triggers events (LoadAllProductsEvent)
- BLoC handles events and emits states
- UI rebuilds based on states (Loading, Loaded, Error)

### 4. Dependency Injection
Using GetIt service locator:
- All dependencies registered in `injection_container.dart`
- BLoCs and services retrieved using `sl<Type>()`
- Makes testing easier (can inject mocks)

### 5. Error Handling
Using Either (from dartz):
- `Either<Failure, Success>`
- Left = Error case (Failure)
- Right = Success case (Data)

## Running the App

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run with specific device
flutter run -d chrome
flutter run -d macos
```

## Features Implemented

✅ Clean Architecture structure
✅ BLoC state management
✅ Dependency Injection (GetIt)
✅ Theme system (Light/Dark/System)
✅ Network connectivity check
✅ Error handling with retry
✅ Pull to refresh
✅ Loading shimmer effect
✅ Cached network images
✅ Material 3 design
✅ Modular, reusable widgets

## Next Steps (Future Features)

- [ ] Product detail page
- [ ] Categories filtering
- [ ] Search functionality
- [ ] Shopping cart
- [ ] Local caching (Hive/SharedPreferences)
- [ ] Unit and widget tests
- [ ] Integration tests
- [ ] Add to favorites
- [ ] Sort products

## Testing the Flow

1. **Test Network Error**: Turn off internet → See error message → Tap retry
2. **Test Theme**: Tap theme icon → Cycles through light/dark/system
3. **Test Pull to Refresh**: Pull down on product list → Shows refresh indicator
4. **Test Loading**: App shows shimmer effect while loading
5. **Test Product Tap**: Tap a product → Shows snackbar (placeholder)

## Why This Architecture?

**Maintainable**: Each layer has clear responsibilities
**Testable**: Easy to mock dependencies and test in isolation
**Scalable**: Add new features without breaking existing code
**Flexible**: Swap implementations (e.g., change API to GraphQL)
**Industry Standard**: Used in production apps at major companies
