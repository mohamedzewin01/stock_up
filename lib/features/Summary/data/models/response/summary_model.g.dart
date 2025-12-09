// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SummaryModel _$SummaryModelFromJson(Map<String, dynamic> json) => SummaryModel(
  status: json['status'] as String?,
  summary: json['summary'] == null
      ? null
      : Summary.fromJson(json['summary'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SummaryModelToJson(SummaryModel instance) =>
    <String, dynamic>{'status': instance.status, 'summary': instance.summary};

Summary _$SummaryFromJson(Map<String, dynamic> json) => Summary(
  treasury: json['treasury'] == null
      ? null
      : Treasury.fromJson(json['treasury'] as Map<String, dynamic>),
  bank: json['bank'] == null
      ? null
      : Bank.fromJson(json['bank'] as Map<String, dynamic>),
  productsCount: (json['products_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$SummaryToJson(Summary instance) => <String, dynamic>{
  'treasury': instance.treasury,
  'bank': instance.bank,
  'products_count': instance.productsCount,
};

Treasury _$TreasuryFromJson(Map<String, dynamic> json) => Treasury(
  finalBalance: json['final_balance'] as String?,
  movements: (json['movements'] as List<dynamic>?)
      ?.map((e) => Movements.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TreasuryToJson(Treasury instance) => <String, dynamic>{
  'final_balance': instance.finalBalance,
  'movements': instance.movements,
};

Movements _$MovementsFromJson(Map<String, dynamic> json) => Movements(
  movementType: json['movement_type'] as String?,
  totalIncoming: json['total_incoming'] as String?,
  totalOutgoing: json['total_outgoing'] as String?,
);

Map<String, dynamic> _$MovementsToJson(Movements instance) => <String, dynamic>{
  'movement_type': instance.movementType,
  'total_incoming': instance.totalIncoming,
  'total_outgoing': instance.totalOutgoing,
};

Bank _$BankFromJson(Map<String, dynamic> json) => Bank(
  finalBalance: json['final_balance'] as String?,
  movements: (json['movements'] as List<dynamic>?)
      ?.map((e) => Movements.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BankToJson(Bank instance) => <String, dynamic>{
  'final_balance': instance.finalBalance,
  'movements': instance.movements,
};
