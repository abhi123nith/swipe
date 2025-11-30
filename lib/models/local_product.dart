import 'package:hive/hive.dart';

part 'local_product.g.dart';

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

  LocalProduct({
    this.image,
    required this.price,
    required this.productName,
    required this.productType,
    required this.tax,
    this.isSynced = false,
    this.imagePath,
  });
}
