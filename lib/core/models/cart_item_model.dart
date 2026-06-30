import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;
  // User ne jo addOns select kiye: [{name:'Extra Cheese', price:30}]
  final List<Map<String, dynamic>> selectedAddOns;

  CartItemModel({
    required this.product,
    this.quantity = 1,
    this.selectedAddOns = const [],
  });

  double get addOnsTotal =>
      selectedAddOns.fold(0.0, (sum, a) => sum + ((a['price'] as num?)?.toDouble() ?? 0.0));

  double get unitPrice   => product.price + addOnsTotal;
  double get totalPrice  => unitPrice * quantity;

  // Cart key: same product + same addOns = same cart slot
  String get cartKey {
    if (selectedAddOns.isEmpty) return product.id;
    final addOnNames = selectedAddOns.map((a) => a['name']).join('+');
    return '${product.id}__$addOnNames';
  }

  String get displayName {
    if (selectedAddOns.isEmpty) return product.name;
    final addOnNames = selectedAddOns.map((a) => a['name']).join(', ');
    return '${product.name} (+$addOnNames)';
  }

  Map<String, dynamic> toJson() => {
    'id'          : product.id,
    'name'        : displayName,
    'price'       : unitPrice,
    'qty'         : quantity,
    'isGrocery'   : product.isGrocery,
    'image'       : product.image,
    'selectedAddOns': selectedAddOns,
  };
}