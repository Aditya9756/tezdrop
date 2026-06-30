class ProductModel {
  final String id;
  final String name;
  final String image;
  final double price;
  final double oldPrice;
  final String category;
  final String type;
  final String desc;
  final double rating;
  final int stock;
  final bool isGrocery;
  final String? unit;
  final String? restId;
  // Vendor app se set hoga — list of {name, price} maps
  final List<Map<String, dynamic>> addOns;

  const ProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.category,
    this.type      = 'veg',
    this.desc      = '',
    this.rating    = 4.5,
    this.stock     = 99,
    this.isGrocery = false,
    this.unit,
    this.restId,
    this.addOns    = const [],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // addOns: Firebase se list aayegi [{name:'Extra Cheese', price:30}, ...]
    List<Map<String, dynamic>> parsedAddOns = [];
    if (json['addOns'] != null && json['addOns'] is List) {
      parsedAddOns = (json['addOns'] as List)
          .whereType<Map>()
          .map((e) => {
                'name': e['name']?.toString() ?? '',
                'price': (e['price'] as num?)?.toDouble() ?? 0.0,
              })
          .where((e) => (e['name'] as String).isNotEmpty)
          .toList();
    }

    return ProductModel(
      id        : json['id']?.toString()            ?? '',
      name      : json['name']                       ?? '',
      image     : json['image']                      ?? '🍔',
      price     : (json['price'] as num?)?.toDouble()    ?? 0,
      oldPrice  : (json['oldPrice'] as num?)?.toDouble() ?? 0,
      category  : json['category']                   ?? '',
      type      : json['type']                       ?? 'veg',
      desc      : json['desc']                       ?? '',
      rating    : (json['rating'] as num?)?.toDouble()   ?? 4.5,
      stock     : (json['stock'] as num?)?.toInt()       ?? 99,
      isGrocery : json['isGrocery']                  ?? false,
      unit      : json['unit'],
      restId    : json['restId'],
      addOns    : parsedAddOns,
    );
  }

  Map<String, dynamic> toJson() => {
    'id'       : id,
    'name'     : name,
    'image'    : image,
    'price'    : price,
    'oldPrice' : oldPrice,
    'category' : category,
    'type'     : type,
    'desc'     : desc,
    'rating'   : rating,
    'stock'    : stock,
    'isGrocery': isGrocery,
    if (unit    != null) 'unit'  : unit,
    if (restId  != null) 'restId': restId,
    if (addOns.isNotEmpty) 'addOns': addOns,
  };

  int get discountPercent {
    if (oldPrice <= 0 || oldPrice <= price) return 0;
    return ((1 - price / oldPrice) * 100).round();
  }

  bool get isOutOfStock => stock == 0;
  bool get isLowStock   => stock > 0 && stock <= 5;
  bool get hasAddOns    => addOns.isNotEmpty;
}