import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/local_product.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../utils/hive_helper.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  List<LocalProduct> _localProducts = [];
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isAddingProduct = false;

  List<Product> get products => _products;
  List<LocalProduct> get localProducts => _localProducts;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isAddingProduct => _isAddingProduct;

  // Load products from API
  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final List<Product> fetchedProducts = await _apiService.getProducts();
      _products = fetchedProducts;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new product
  Future<bool> addProduct({
    required String productName,
    required String productType,
    required String price,
    required String tax,
    File? image,
  }) async {
    _isAddingProduct = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Save to local storage first
      final localProduct = LocalProduct(
        productName: productName,
        productType: productType,
        price: double.parse(price),
        tax: double.parse(tax),
        imagePath: image?.path,
        isSynced: false,
      );

      await HiveHelper.productsBox.add(localProduct);
      _localProducts.add(localProduct);

      // Try to sync with API
      final response = await _apiService.addProduct(
        productName: productName,
        productType: productType,
        price: price,
        tax: tax,
        image: image,
      );

      if (response['success'] == true) {
        // Mark as synced
        localProduct.isSynced = true;
        await localProduct.save();

        // Also add to the main products list at the beginning
        _products.insert(
          0,
          Product(
            productName: productName,
            productType: productType,
            price: double.parse(price),
            tax: double.parse(tax),
            image: response['product_details']['image'] ?? '',
          ),
        );

        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to add product';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isAddingProduct = false;
      notifyListeners();
    }
  }

  // Filter products based on search query
  List<Product> filterProducts(String query) {
    if (query.isEmpty) {
      return List.from(_products);
    }

    return _products.where((product) {
      return product.productName.toLowerCase().contains(query.toLowerCase()) ||
          product.productType.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Sort products by price
  List<Product> sortProductsByPrice(List<Product> products, bool ascending) {
    final sortedProducts = List<Product>.from(products);
    sortedProducts.sort(
      (a, b) =>
          ascending ? a.price.compareTo(b.price) : b.price.compareTo(a.price),
    );
    return sortedProducts;
  }

  // Load local products
  Future<void> loadLocalProducts() async {
    _localProducts = HiveHelper.productsBox.values.toList();
    notifyListeners();
  }
}
