import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/ManagerScreen_useCase_repo.dart';

part 'ManagerScreen_state.dart';

@injectable
class ManagerScreenCubit extends Cubit<ManagerScreenState> {
  ManagerScreenCubit(this._managerscreenUseCaseRepo) : super(ManagerScreenInitial());
  final ManagerScreenUseCaseRepo _managerscreenUseCaseRepo;
}
