import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import 'package:stock_up/core/common/api_result.dart';
import 'package:stock_up/features/barcode_screen/domain/entities/entities.dart';
import '../../domain/useCases/BarcodeScreen_useCase_repo.dart';

part 'Barcode_state.dart';

@injectable
class BarcodeCubit extends Cubit<BarcodeState> {
  BarcodeCubit(this._barcode_screenUseCaseRepo)
    : super(BarcodeInitial());
  final BarcodeScreenUseCaseRepo _barcode_screenUseCaseRepo;

  Future<void> smartSearch({required String storeId,required String query}) async {
    emit(BarcodeLoading());
    final result = await _barcode_screenUseCaseRepo.smartSearch(storeId, query);

    switch (result) {
      case Success<SmartSearchEntity?>():
        if (!isClosed) {
          emit(BarcodeSuccess(result.data!));
        }

      case Fail<SmartSearchEntity?>():
        if (!isClosed) {
          emit(BarcodeFailure(result.exception));
        }
        break;
    }
  }
}
