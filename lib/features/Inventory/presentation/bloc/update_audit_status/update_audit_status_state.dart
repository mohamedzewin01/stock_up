part of 'update_audit_status_cubit.dart';

@immutable
sealed class UpdateAuditStatusState {}

final class UpdateAuditStatusInitial extends UpdateAuditStatusState {}

final class UpdateAuditStatusLoading extends UpdateAuditStatusState {}

final class UpdateAuditStatusLoaded extends UpdateAuditStatusState {
  final UpdateAuditStatusEntity? updateAuditStatusEntity;

  UpdateAuditStatusLoaded(this.updateAuditStatusEntity);
}

final class UpdateAuditStatusError extends UpdateAuditStatusState {
  final Exception message;

  UpdateAuditStatusError(this.message);
}
