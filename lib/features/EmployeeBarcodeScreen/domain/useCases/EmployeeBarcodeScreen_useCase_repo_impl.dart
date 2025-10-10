import 'package:stock_up/core/common/api_result.dart';

import 'package:stock_up/features/EmployeeBarcodeScreen/domain/entities/entities.dart';

import '../repositories/EmployeeBarcodeScreen_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/EmployeeBarcodeScreen_useCase_repo.dart';

@Injectable(as: EmployeeBarcodeScreenUseCaseRepo)
class EmployeeBarcodeScreenUseCase implements EmployeeBarcodeScreenUseCaseRepo {
  final EmployeeBarcodeScreenRepository repository;

  EmployeeBarcodeScreenUseCase(this.repository);

  @override
  Future<Result<SmartSearchEntity?>> smartSearch(String query) {
return repository.smartSearch(query);
  }


}
