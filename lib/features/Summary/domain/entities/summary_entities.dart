import 'package:stock_up/features/Summary/data/models/response/summary_accounts_model.dart';
import 'package:stock_up/features/Summary/data/models/response/summary_model.dart';

class SummaryEntity {
  final String? status;

  final Summary? summary;

  SummaryEntity({this.status, this.summary});
}

class SummaryAccountsEntity {
  final String? status;

  final StoreAccounts? store;

  final int? page;

  final int? limit;

  final int? totalItems;

  final int? totalPages;

  final List<ResultsAccounts>? results;

  SummaryAccountsEntity({
    this.status,
    this.store,
    this.page,
    this.limit,
    this.totalItems,
    this.totalPages,
    this.results,
  });
}
