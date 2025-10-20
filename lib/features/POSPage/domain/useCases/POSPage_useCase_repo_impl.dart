import '../repositories/POSPage_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/POSPage_useCase_repo.dart';

@Injectable(as: POSPageUseCaseRepo)
class POSPageUseCase implements POSPageUseCaseRepo {
  final POSPageRepository repository;

  POSPageUseCase(this.repository);

  // Future<Result<T>> call(...) async {
  //   return await repository.get...();
  // }
}
