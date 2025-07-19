class UserModel {
  final String uid;
  final String name;
  final String email;
  final String profilePic;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profilePic,
  });

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'name': name, 'email': email, 'profilePic': profilePic};
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profilePic: map['profilePic'] ?? '',
    );
  }
}
