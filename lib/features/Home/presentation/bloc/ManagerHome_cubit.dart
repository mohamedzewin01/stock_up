import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/ManagerHome_useCase_repo.dart';

part 'ManagerHome_state.dart';

@injectable
class ManagerHomeCubit extends Cubit<ManagerHomeState> {
  ManagerHomeCubit(this._managerhomeUseCaseRepo) : super(ManagerHomeInitial());
  final ManagerHomeUseCaseRepo _managerhomeUseCaseRepo;
}
