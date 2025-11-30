class Product {
  final String? image;
  final double price;
  final String productName;
  final String productType;
  final double tax;

  Product({
    this.image,
    required this.price,
    required this.productName,
    required this.productType,
    required this.tax,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      image: json['image'] as String?,
      price: (json['price'] as num).toDouble(),
      productName: json['product_name'] as String,
      productType: json['product_type'] as String,
      tax: (json['tax'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'price': price,
      'product_name': productName,
      'product_type': productType,
      'tax': tax,
    };
  }

  Product copyWith({
    String? image,
    double? price,
    String? productName,
    String? productType,
    double? tax,
  }) {
    return Product(
      image: image ?? this.image,
      price: price ?? this.price,
      productName: productName ?? this.productName,
      productType: productType ?? this.productType,
      tax: tax ?? this.tax,
    );
  }
}
