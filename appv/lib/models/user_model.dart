import '../helpers/api_constants.dart';

class UserModel {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final String? photo;
  final String? aadharCard;
  final String? panCard;
  final String? idProof;
  final String? bankName;
  final String? bankAccountNumber;
  final String? bankIfsc;
  final String? bankAccountType;
  final List<dynamic>? roles;
  final String? createdAt;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.photo,
    this.aadharCard,
    this.panCard,
    this.idProof,
    this.bankName,
    this.bankAccountNumber,
    this.bankIfsc,
    this.bankAccountType,
    this.roles,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      photo: ApiConstants.resolveImageUrl(json['photo']),
      aadharCard: json['aadhar_card'],
      panCard: json['pan_card'],
      idProof: json['id_proof'],
      bankName: json['bank_name'],
      bankAccountNumber: json['bank_account_number'],
      bankIfsc: json['bank_ifsc'],
      bankAccountType: json['bank_account_type'],
      roles: json['roles'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'photo': photo,
      'bank_name': bankName,
      'bank_account_number': bankAccountNumber,
      'bank_ifsc': bankIfsc,
      'bank_account_type': bankAccountType,
    };
  }

  /// Get the user's first role name, or 'member' as default
  String get roleName {
    if (roles != null && roles!.isNotEmpty) {
      if (roles!.first is Map) {
        return roles!.first['name'] ?? 'member';
      }
      return roles!.first.toString();
    }
    return 'member';
  }
}
