class AgentModel {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? photo;

  AgentModel({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.photo,
  });

  factory AgentModel.fromJson(Map<String, dynamic> json) {
    return AgentModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? 'Field Agent',
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      photo: json['photo']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'photo': photo,
    };
  }
}
