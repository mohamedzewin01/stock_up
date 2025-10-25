// lib/features/Auth/domain/entities/login_entity.dart

class LoginEntity {
  final String? status;
  final String? message;

  final UserEntity? user;
  final StoreEntity? store;

  LoginEntity({this.status, this.message, this.user, this.store});
}

class UserEntity {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final int? storeId;
  final String? role;
  final String? profileImage;

  UserEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.storeId,
    this.role,
    this.profileImage,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  bool get isAdmin => role?.toLowerCase() == 'admin';

  bool get isManager => role?.toLowerCase() == 'manager';

  bool get isEmployee => role?.toLowerCase() == 'employee';
}

class StoreEntity {
  final int? id;

  final String? storeName;

  StoreEntity({this.id, this.storeName});
}
