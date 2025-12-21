// classe per il form creazione partner, non usare freezed
class PartnerModel {
  final String name;
  final String email;
  final String password;

  PartnerModel({
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'password': password};
  }

  @override
  String toString() {
    return 'PartnerModel(name: $name, email: $email, password: [REDACTED])';
  }
}
