class UserModel {
  int? id;
  int? rolId;
  String? email;
  String? telefono;
  String firebaseUid;

  UserModel({
    this.id,
    required this.rolId,
    required this.email,
    required this.telefono,
    required this.firebaseUid,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      rolId: json['rol_id'],
      email: json['email'],
      telefono: json['telefono'],
      firebaseUid: json['firebase_uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rol_id': rolId,
      'email': email,
      'telefono': telefono,
      'firebase_uid': firebaseUid,
    };
  }
}
