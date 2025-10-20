import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/Settings_useCase_repo.dart';

part 'Settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._settingsUseCaseRepo) : super(SettingsInitial());
  final SettingsUseCaseRepo _settingsUseCaseRepo;
}
