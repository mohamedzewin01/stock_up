import '../repositories/ManagerScreen_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/ManagerScreen_useCase_repo.dart';

@Injectable(as: ManagerScreenUseCaseRepo)
class ManagerScreenUseCase implements ManagerScreenUseCaseRepo {
  final ManagerScreenRepository repository;

  ManagerScreenUseCase(this.repository);

  // Future<Result<T>> call(...) async {
  //   return await repository.get...();
  // }
}
