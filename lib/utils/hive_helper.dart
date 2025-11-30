import 'package:hive_flutter/hive_flutter.dart';

import '../models/local_product.dart';

class HiveHelper {
  static Box<LocalProduct>? _productsBox;

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(LocalProductAdapter());

    _productsBox = await Hive.openBox<LocalProduct>('products');
  }

  static Box<LocalProduct> get productsBox {
    if (_productsBox == null) {
      throw Exception('Hive not initialized. Call init() first.');
    }
    return _productsBox!;
  }

  static Future<void> closeBoxes() async {
    await _productsBox?.close();
  }
}
