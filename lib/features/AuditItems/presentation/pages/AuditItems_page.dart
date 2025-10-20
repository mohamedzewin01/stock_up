import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../bloc/AuditItems_cubit.dart';

class AuditItemsPage extends StatefulWidget {
  const AuditItemsPage({super.key});

  @override
  State<AuditItemsPage> createState() => _AuditItemsPageState();
}

class _AuditItemsPageState extends State<AuditItemsPage> {

  late AuditItemsCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<AuditItemsCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: Scaffold(
        appBar: AppBar(title: const Text('AuditItems')),
        body: const Center(child: Text('Hello AuditItems')),
      ),
    );
  }
}

