class UserModel {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final String? phone;
  final String? address;

  UserModel({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.phone,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
      phone: json['phone'],
      address: json['address'],
    );
  }
}