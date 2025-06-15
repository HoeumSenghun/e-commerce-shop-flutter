class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int categoryId;
  final List<String> imageUrls;
  final int stockQuantity;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.imageUrls,
    required this.stockQuantity,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: double.parse(json['price'].toString()),
      categoryId: json['category_id'],
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      stockQuantity: json['stock_quantity'] ?? 0,
      rating: double.parse(json['rating'].toString()),
    );
  }
}