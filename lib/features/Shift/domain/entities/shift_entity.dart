import 'package:stock_up/features/Shift/data/models/response/add_shift_model.dart';
import 'package:stock_up/features/Shift/data/models/response/get_closed_shift_model.dart';
import 'package:stock_up/features/Shift/data/models/response/get_open_shift_model.dart';

class AddShiftEntity {
  final String? status;

  final Shift? shift;

  AddShiftEntity({this.status, this.shift});
}

class GetOpenShiftEntity {
  final String? status;

  final UserShift? user;

  final ShiftInfo? shift;

  GetOpenShiftEntity({this.status, this.user, this.shift});
}

class GetClosedShiftEntity {
  final String? status;

  final List<ShiftsClosed>? shifts;

  GetClosedShiftEntity({this.status, this.shifts});
}
