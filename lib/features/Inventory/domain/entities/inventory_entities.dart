import 'package:stock_up/features/Inventory/data/models/response/get_inventory_by_user_model.dart';

import '../../data/models/response/create_inventory_audit_model.dart';
import '../../data/models/response/get_all_users_model.dart';

class GetAllUsersEntity {
  final String? status;

  final List<User>? users;

  GetAllUsersEntity({this.status, this.users});
}

class CreateInventoryAuditEntity {
  final String? status;

  final String? message;

  final Audit? audit;

  CreateInventoryAuditEntity({this.status, this.message, this.audit});
}

class AddInventoryAuditUsersEntity {
  final String? status;

  final String? message;

  final int? addedUsers;

  AddInventoryAuditUsersEntity({this.status, this.message, this.addedUsers});
}

class GetInventoryByUserEntity {
  final String? status;

  final String? message;

  final Data? data;

  GetInventoryByUserEntity({this.status, this.message, this.data});
}

class UpdateAuditStatusEntity {
  final String? status;

  final String? message;

  final int? auditId;

  final String? newStatus;

  final int? pendingItemsCount;

  UpdateAuditStatusEntity({
    this.status,
    this.message,
    this.auditId,
    this.newStatus,
    this.pendingItemsCount,
  });
}
