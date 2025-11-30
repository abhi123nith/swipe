# Implementation Details

This document provides detailed information about the implementation of the Swipe Products app.

## Architecture Overview

The app follows the MVVM (Model-View-ViewModel) architecture pattern with clean separation of concerns:

### Model Layer
- `Product`: Represents a product from the API
- `LocalProduct`: Represents a product stored locally with Hive

### View Layer
- `ProductListScreen`: Displays the list of products with search functionality
- `AddProductScreen`: Provides form for adding new products
- `ProductCard`: Reusable widget for displaying individual product items

### ViewModel Layer
- `ProductProvider`: Manages state and business logic using Provider package

### Service Layer
- `ApiService`: Handles all network requests to the backend API

### Utility Layer
- `HiveHelper`: Manages Hive initialization and provides access to storage boxes

## Key Features Implementation

### 1. Product Listing

The product listing screen implements:
- Pull-to-refresh functionality for updating the product list
- Search functionality with real-time filtering
- Loading indicators during API requests
- Error handling with retry mechanism
- Beautiful card-based UI for product display

### 2. Add Product

The add product screen includes:
- Form validation for all required fields
- Dropdown for product type selection
- Decimal input validation for price and tax
- Loading indicators during submission
- Success/error dialogs for user feedback
- Offline storage using Hive

### 3. Offline Functionality

Offline functionality is implemented using Hive local storage:
1. When a product is added, it's immediately saved to local storage
2. The app then attempts to sync with the server
3. If successful, the local record is marked as synced
4. If unsuccessful, the product remains in local storage for later sync

### 4. State Management

State management is handled using the Provider package:
- `ProductProvider` manages the list of products and loading states
- Consumers listen to changes and rebuild UI accordingly
- Business logic is separated from UI components

## Data Models

### Product Model

```dart
class Product {
  final String? image;
  final double price;
  final String productName;
  final String productType;
  final double tax;
}
```

### LocalProduct Model

```dart
@HiveType(typeId: 0)
class LocalProduct extends HiveObject {
  @HiveField(0)
  String? image;

  @HiveField(1)
  double price;

  @HiveField(2)
  String productName;

  @HiveField(3)
  String productType;

  @HiveField(4)
  double tax;

  @HiveField(5)
  bool isSynced;

  @HiveField(6)
  String? imagePath;
}
```

## API Integration

### Get Products Endpoint

- **URL**: `https://app.getswipe.in/api/public/get`
- **Method**: GET
- **Implementation**: `ApiService.getProducts()`
- **Error Handling**: Network errors are caught and displayed to the user

### Add Product Endpoint

- **URL**: `https://app.getswipe.in/api/public/add`
- **Method**: POST (multipart/form-data)
- **Implementation**: `ApiService.addProduct()`
- **Error Handling**: Server errors are parsed and shown to the user

## UI Components

### ProductCard Widget

A reusable widget that displays product information:
- Cached network images with placeholders
- Product name with ellipsis for long names
- Product type display
- Price formatting with currency symbol
- Tax percentage display

### Loading Indicators

Implemented using `flutter_spinkit` for smooth animations:
- Circle spinner during API requests
- Consistent styling throughout the app

## Validation

Form validation is implemented using `form_field_validator`:
- Required field validation
- Numeric validation for price and tax fields
- Product type selection validation

## Local Storage

Hive is used for local storage:
- Type-safe storage with annotations
- Automatic serialization/deserialization
- Efficient storage and retrieval operations

## Error Handling

Comprehensive error handling is implemented:
- Network error detection and user notification
- Server error parsing and display
- Retry mechanisms for failed operations
- Graceful degradation when offline

## Performance Considerations

- Cached network images to reduce bandwidth usage
- Efficient list rendering with ListView.builder
- Proper disposal of controllers and resources
- Asynchronous operations to prevent UI blocking

## Future Enhancements

Potential improvements that could be made:
- Image compression before upload
- Batch synchronization of offline products
- Pagination for large product lists
- Advanced search and filtering options
- Dark mode support