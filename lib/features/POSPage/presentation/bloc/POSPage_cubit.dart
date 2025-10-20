import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/POSPage_useCase_repo.dart';

part 'POSPage_state.dart';

@injectable
class POSPageCubit extends Cubit<POSPageState> {
  POSPageCubit(this._pospageUseCaseRepo) : super(POSPageInitial());
  final POSPageUseCaseRepo _pospageUseCaseRepo;
}
