class AddressModel {
  final String type;      // 'home' | 'work' | 'other'
  final String name;
  final String phone;
  final String flat;
  final String area;
  final String landmark;
  final double? lat;
  final double? lng;

  const AddressModel({
    this.type     = 'home',
    this.name     = '',
    this.phone    = '',
    this.flat     = '',
    required this.area,
    this.landmark = '',
    this.lat,
    this.lng,
  });

  String get displayString {
    final parts = [
      if (flat.isNotEmpty) flat,
      area,
      if (landmark.isNotEmpty) landmark,
    ];
    return parts.join(', ');
  }

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      type    : json['type']     ?? 'home',
      name    : json['name']     ?? '',
      phone   : json['phone']    ?? '',
      flat    : json['flat']     ?? '',
      area    : json['area']     ?? '',
      landmark: json['landmark'] ?? '',
      lat     : (json['lat'] as num?)?.toDouble(),
      lng     : (json['lng'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'type'    : type,
    'name'    : name,
    'phone'   : phone,
    'flat'    : flat,
    'area'    : area,
    'landmark': landmark,
    if (lat != null) 'lat': lat,
    if (lng != null) 'lng': lng,
  };
}
