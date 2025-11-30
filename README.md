# Swipe Products App

A Flutter application for managing products with offline functionality.

## Features

- Product listing with search functionality
- Add new products with validation
- Offline storage using Hive
- Beautiful UI with smooth animations
- Loading indicators for network operations
- Product details screen with comprehensive information
- Sorting products by price (Low to High, High to Low)
- Refresh button to reload product list
- Smooth navigation between screens
- Image upload functionality for products

## Screenshots

![Product List](screenshots/product_list.png)
![Add Product](screenshots/add_product.png)

## Getting Started

### Prerequisites

- Flutter SDK (3.10.1 or higher)
- Dart SDK
- Android Studio or VS Code
- Android/iOS emulator or physical device

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```

2. Navigate to the project directory:
   ```bash
   cd swipe
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Generate Hive adapters:
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

### Running the App

#### On Android/iOS Emulator
```bash
flutter run
```

#### On Web
```bash
flutter run -d chrome
```

#### On Desktop (Windows, macOS, Linux)
```bash
flutter run -d windows
```

### Building for Production

#### Android
```bash
flutter build apk
```

#### iOS
```bash
flutter build ios
```

#### Web
```bash
flutter build web
```

## Project Structure

```
lib/
├── main.dart                   # Entry point
├── models/                     # Data models
│   ├── product.dart            # Product model
│   └── local_product.dart      # Local product model for Hive
├── screens/                    # UI screens
│   ├── product_list_screen.dart # Product listing screen
│   ├── add_product_screen.dart  # Add product screen
│   └── product_details_screen.dart # Product details screen
├── widgets/                    # Custom widgets
│   └── product_card.dart       # Product item widget
├── providers/                  # State management
│   └── product_provider.dart   # Product data provider
├── services/                   # API services
│   └── api_service.dart        # Network API calls
└── utils/                      # Utility classes
    ├── hive_helper.dart        # Hive initialization
    └── navigation_utils.dart   # Smooth navigation transitions
```

## Dependencies

- `http`: For making network requests
- `provider`: For state management
- `hive`: For local storage
- `hive_flutter`: Hive integration with Flutter
- `cached_network_image`: For efficient image loading
- `path_provider`: For accessing device storage paths
- `form_field_validator`: For form validation
- `flutter_spinkit`: For loading indicators
- `image_picker`: For selecting images from device

## Architecture

This app follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Model**: Data classes (`Product`, `LocalProduct`)
- **View**: UI screens and widgets (`ProductListScreen`, `AddProductScreen`, `ProductDetailsScreen`, `ProductCard`)
- **ViewModel**: Providers that manage state and business logic (`ProductProvider`)
- **Utils**: Utility classes for navigation and Hive initialization (`NavigationUtils`, `HiveHelper`)

## Offline Functionality

The app implements offline functionality using Hive local storage:

1. When adding a product, it's first saved locally
2. The app then attempts to sync with the server
3. If the sync fails due to network issues, the product remains in local storage
4. When connectivity is restored, products can be manually synced

## API Endpoints

### Get Products
- **URL**: `https://app.getswipe.in/api/public/get`
- **Method**: GET
- **Response**: Array of product objects

### Add Product
- **URL**: `https://app.getswipe.in/api/public/add`
- **Method**: POST
- **Body**: form-data
  - `product_name` (text)
  - `product_type` (text)
  - `price` (text)
  - `tax` (text)
  - `files[]` (file, optional)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a pull request

## License

This project is licensed under the MIT License.