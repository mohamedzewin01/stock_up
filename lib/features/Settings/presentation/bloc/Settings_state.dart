part of 'Settings_cubit.dart';

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}
final class SettingsLoading extends SettingsState {}
final class SettingsSuccess extends SettingsState {}
final class SettingsFailure extends SettingsState {
  final Exception exception;

  SettingsFailure(this.exception);
}
