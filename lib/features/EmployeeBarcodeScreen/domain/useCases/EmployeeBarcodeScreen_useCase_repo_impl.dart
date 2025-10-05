import '../repositories/EmployeeBarcodeScreen_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/EmployeeBarcodeScreen_useCase_repo.dart';

@Injectable(as: EmployeeBarcodeScreenUseCaseRepo)
class EmployeeBarcodeScreenUseCase implements EmployeeBarcodeScreenUseCaseRepo {
  final EmployeeBarcodeScreenRepository repository;

  EmployeeBarcodeScreenUseCase(this.repository);

  // Future<Result<T>> call(...) async {
  //   return await repository.get...();
  // }
}
