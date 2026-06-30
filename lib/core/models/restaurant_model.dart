class RestaurantModel {
  final String id;
  final String name;
  final String image;
  final double rating;
  final String time;
  final String category;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.image,
    this.rating   = 4.0,
    this.time     = '30 min',
    this.category = '',
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id      : json['id']?.toString()            ?? '',
      name    : json['name']                       ?? '',
      image   : json['image']                      ?? '🍔',
      rating  : (json['rating'] as num?)?.toDouble() ?? 4.0,
      time    : json['time']                       ?? '30 min',
      category: json['category']                   ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id'      : id,
    'name'    : name,
    'image'   : image,
    'rating'  : rating,
    'time'    : time,
    'category': category,
  };
}
