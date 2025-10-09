class UserModel {
  final String id;
  final String email;
  final String? name; // optional

  UserModel({
    required this.id,
    required this.email,
    this.name,
  });

  // Optional: from Firestore
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      email: map['email'] ?? '',
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
    };
  }
}
