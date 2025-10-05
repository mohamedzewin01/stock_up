import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/EmployeeBarcodeScreen_useCase_repo.dart';

part 'EmployeeBarcodeScreen_state.dart';

@injectable
class EmployeeBarcodeScreenCubit extends Cubit<EmployeeBarcodeScreenState> {
  EmployeeBarcodeScreenCubit(this._employeebarcodescreenUseCaseRepo) : super(EmployeeBarcodeScreenInitial());
  final EmployeeBarcodeScreenUseCaseRepo _employeebarcodescreenUseCaseRepo;
}
