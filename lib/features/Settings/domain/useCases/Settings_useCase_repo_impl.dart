import '../repositories/Settings_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Settings_useCase_repo.dart';

@Injectable(as: SettingsUseCaseRepo)
class SettingsUseCase implements SettingsUseCaseRepo {
  final SettingsRepository repository;

  SettingsUseCase(this.repository);

  // Future<Result<T>> call(...) async {
  //   return await repository.get...();
  // }
}
