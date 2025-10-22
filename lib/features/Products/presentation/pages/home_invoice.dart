import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../domain/useCases/Products_useCase_repo.dart';
import '../cubit/InvoiceCubit/invoice_cubit.dart';
import '../cubit/InvoiceListCubit/invoice_list_cubit.dart';
import '../cubit/products_cubit.dart';
import '../database_helper.dart';
import '../firebase_invoice_service.dart';
import 'create_invoice_page.dart';
import 'invoice_list_page.dart';

class HomeInvoice extends StatefulWidget {
  const HomeInvoice({super.key});

  @override
  State<HomeInvoice> createState() => _HomeInvoiceState();
}

class _HomeInvoiceState extends State<HomeInvoice> {
  int _currentIndex = 0;

  // إنشاء instances محلية
  late final FirebaseInvoiceService _firebaseService;
  late final ProductsCubit _productsCubit;
  late final InvoiceCubit _invoiceCubit;
  late final InvoiceListCubit _invoiceListCubit;

  @override
  void initState() {
    super.initState();

    // إنشاء الخدمات يدوياً
    _firebaseService = FirebaseInvoiceService(FirebaseFirestore.instance);
    _productsCubit = ProductsCubit(
      getIt<ProductsUseCaseRepo>(),
      getIt<DatabaseHelper>(),
    );
    _invoiceCubit = InvoiceCubit(_firebaseService);
    _invoiceListCubit = InvoiceListCubit(_firebaseService);

    _productsCubit.initializeProducts();
  }

  @override
  void dispose() {
    _productsCubit.close();
    _invoiceCubit.close();
    _invoiceListCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _productsCubit),
        BlocProvider.value(value: _invoiceCubit),
        BlocProvider.value(value: _invoiceListCubit),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: const [CreateInvoicePage(), InvoiceListPage()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart),
              label: 'إنشاء فاتورة',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: 'الفواتير',
            ),
          ],
        ),
      ),
    );
  }
}
