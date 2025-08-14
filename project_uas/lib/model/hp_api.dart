class HpApi {
  final int id;
  final String title;
  final String brand;
  final int price;
  final String description;
  final String thumbnail;

  HpApi({
    required this.id,
    required this.title,
    required this.brand,
    required this.price,
    required this.description,
    required this.thumbnail,
  });

  factory HpApi.fromJson(Map<String, dynamic> json) {
    return HpApi(
      id: (json['id'] as num).toInt(),
      title: json['title'] ?? '',
      brand: json['brand'] ?? '',
      price: (json['price'] as num).toInt(), 
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'] ?? '',
    );
  }
}
