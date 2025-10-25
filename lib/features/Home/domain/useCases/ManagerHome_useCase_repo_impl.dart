import '../repositories/ManagerHome_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/ManagerHome_useCase_repo.dart';

@Injectable(as: ManagerHomeUseCaseRepo)
class ManagerHomeUseCase implements ManagerHomeUseCaseRepo {
  final ManagerHomeRepository repository;

  ManagerHomeUseCase(this.repository);

  // Future<Result<T>> call(...) async {
  //   return await repository.get...();
  // }
}
