class UserModel {
  final String phone;
  String name;
  String email;
  int coins;
  String referCode;
  int avatarIndex;

  UserModel({
    required this.phone,
    required this.name,
    this.email = '',
    this.coins = 10,
    required this.referCode,
    this.avatarIndex = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phone      : json['phone']       ?? '',
      name       : json['name']        ?? '',
      email      : json['email']       ?? '',
      coins      : json['coins']       ?? 10,
      referCode  : json['referCode']   ?? 'TEZDROP',
      avatarIndex: json['avatarIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'phone'      : phone,
    'name'       : name,
    'email'      : email,
    'coins'      : coins,
    'referCode'  : referCode,
    'avatarIndex': avatarIndex,
  };

  UserModel copyWith({
    String? name,
    String? email,
    int? coins,
    String? referCode,
    int? avatarIndex,
  }) {
    return UserModel(
      phone      : phone,
      name       : name       ?? this.name,
      email      : email      ?? this.email,
      coins      : coins      ?? this.coins,
      referCode  : referCode  ?? this.referCode,
      avatarIndex: avatarIndex ?? this.avatarIndex,
    );
  }
}
