class UserModel {
  String? name;
  String? phone;
  String? id;
  String? childEmail;
  String? guardiantEmail;
  String? type;

  UserModel(
      {this.name,
      this.phone,
      this.id,
      this.childEmail,
      this.guardiantEmail,
      this.type});

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'id': id,
        'childEmail': childEmail,
        'guardiantEmail': guardiantEmail,
        'type': type,
      };
}
