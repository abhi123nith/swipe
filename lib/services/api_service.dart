import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://app.getswipe.in/api/public';
  static const String getProductsEndpoint = '$baseUrl/get';
  static const String addProductEndpoint = '$baseUrl/add';

  /// Fetch all products from the API
  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse(getProductsEndpoint));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => Product.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  /// Add a new product to the API
  Future<Map<String, dynamic>> addProduct({
    required String productName,
    required String productType,
    required String price,
    required String tax,
    File? image,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(addProductEndpoint));
      
      // Add form fields
      request.fields['product_name'] = productName;
      request.fields['product_type'] = productType;
      request.fields['price'] = price;
      request.fields['tax'] = tax;
      
      // Add image if provided
      if (image != null) {
        var multipartFile = await http.MultipartFile.fromPath(
          'files[]',
          image.path,
        );
        request.files.add(multipartFile);
      }
      
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        return json.decode(responseBody);
      } else {
        throw Exception('Failed to add product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }
}