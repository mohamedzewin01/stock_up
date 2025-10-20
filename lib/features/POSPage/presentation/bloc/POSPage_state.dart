part of 'POSPage_cubit.dart';

@immutable
sealed class POSPageState {}

final class POSPageInitial extends POSPageState {}
final class POSPageLoading extends POSPageState {}
final class POSPageSuccess extends POSPageState {}
final class POSPageFailure extends POSPageState {
  final Exception exception;

  POSPageFailure(this.exception);
}
