class OrderItemSnapshot {
  final String id;
  final String name;
  final double price;
  final int qty;
  final bool isGrocery;
  final String image;

  const OrderItemSnapshot({
    required this.id,
    required this.name,
    required this.price,
    required this.qty,
    this.isGrocery = false,
    this.image     = '🍔',
  });

  factory OrderItemSnapshot.fromJson(Map<String, dynamic> json) {
    return OrderItemSnapshot(
      id       : json['id']?.toString()            ?? '',
      name     : json['name']                       ?? '',
      price    : (json['price'] as num?)?.toDouble() ?? 0,
      qty      : (json['qty'] as num?)?.toInt()      ?? 1,
      isGrocery: json['isGrocery']                  ?? false,
      image    : json['image']                      ?? '🍔',
    );
  }

  Map<String, dynamic> toJson() => {
    'id'       : id,
    'name'     : name,
    'price'    : price,
    'qty'      : qty,
    'isGrocery': isGrocery,
    'image'    : image,
  };
}

class OrderModel {
  final String orderId;
  final String phone;
  final String address;
  final List<OrderItemSnapshot> items;
  final double total;
  String status;
  final String payment;
  String rider;
  String riderPhone;
  final int coinsUsed;
  final int coinsEarned;
  final String timestamp;
  String? firebaseKey; // Firebase mein jo key assign hoti hai

  OrderModel({
    required this.orderId,
    required this.phone,
    required this.address,
    required this.items,
    required this.total,
    this.status      = 'Confirmed',
    this.payment     = 'Cash on Delivery',
    this.rider       = '',
    this.riderPhone  = '',
    this.coinsUsed   = 0,
    this.coinsEarned = 0,
    required this.timestamp,
    this.firebaseKey,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json, {String? key}) {
    final rawItems = json['items'];
    List<OrderItemSnapshot> parsedItems = [];
    if (rawItems is List) {
      parsedItems = rawItems
          .whereType<Map>()
          .map((e) => OrderItemSnapshot.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return OrderModel(
      orderId     : json['orderId']     ?? '',
      phone       : json['phone']       ?? '',
      address     : json['address']     ?? '',
      items       : parsedItems,
      total       : (json['total'] as num?)?.toDouble() ?? 0,
      status      : json['status']      ?? 'Confirmed',
      payment     : json['payment']     ?? 'Cash on Delivery',
      rider       : json['rider']       ?? '',
      riderPhone  : json['riderPhone']  ?? '',
      coinsUsed   : (json['coinsUsed']   as num?)?.toInt() ?? 0,
      coinsEarned : (json['coinsEarned'] as num?)?.toInt() ?? 0,
      timestamp   : json['timestamp']   ?? '',
      firebaseKey : key,
    );
  }

  Map<String, dynamic> toJson() => {
    'orderId'    : orderId,
    'phone'      : phone,
    'address'    : address,
    'items'      : items.map((e) => e.toJson()).toList(),
    'total'      : total,
    'status'     : status,
    'payment'    : payment,
    'rider'      : rider,
    'riderPhone' : riderPhone,
    'coinsUsed'  : coinsUsed,
    'coinsEarned': coinsEarned,
    'timestamp'  : timestamp,
  };
}
