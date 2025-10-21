part of 'search_audit_user_cubit.dart';

@immutable
sealed class SearchAuditUserState {}

final class SearchAuditUserInitial extends SearchAuditUserState {}

final class SearchAuditUserLoading extends SearchAuditUserState {}

final class SearchAuditUserSuccess extends SearchAuditUserState {
  final SearchAuditUserEntity? searchAuditUserEntity;

  SearchAuditUserSuccess(this.searchAuditUserEntity);
}

final class SearchAuditUserFailure extends SearchAuditUserState {
  final Exception exception;

  SearchAuditUserFailure(this.exception);
}
