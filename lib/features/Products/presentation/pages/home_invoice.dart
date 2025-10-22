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

  @override
  void initState() {
    super.initState();
    // تهيئة المنتجات عند فتح التطبيق
    _initializeProducts();
  }

  Future<void> _initializeProducts() async {
    final productsCubit = ProductsCubit(
      getIt<ProductsUseCaseRepo>(),
      getIt<DatabaseHelper>(),
    );
    await productsCubit.initializeProducts();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductsCubit(
            getIt<ProductsUseCaseRepo>(),
            getIt<DatabaseHelper>(),
          )..initializeProducts(),
        ),
        BlocProvider(
          create: (context) => InvoiceCubit(getIt<FirebaseInvoiceService>()),
        ),
        BlocProvider(
          create: (context) =>
              InvoiceListCubit(getIt<FirebaseInvoiceService>()),
        ),
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
