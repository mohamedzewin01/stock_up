import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/di.dart';
import '../../domain/useCases/Products_useCase_repo.dart';
import '../cubit/InvoiceCubit/invoice_cubit.dart';
import '../cubit/InvoiceListCubit/invoice_list_cubit.dart';
import '../cubit/products_cubit.dart';
import '../cubit/products_state.dart';
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
        body: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: const [CreateInvoicePage(), InvoiceListPage()],
            ),
            // Dialog التقدم
            BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                if (state is ProductsFirstTimeLoading) {
                  return _buildProgressDialog(state);
                }
                return const SizedBox.shrink();
              },
            ),
          ],
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

  Widget _buildProgressDialog(ProductsFirstTimeLoading state) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // أيقونة
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.download_rounded,
                    size: 40,
                    color: Colors.blue.shade700,
                  ),
                ),

                const SizedBox(height: 24),

                // العنوان
                const Text(
                  'تحميل المنتجات لأول مرة',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // الوصف
                Text(
                  'يتم تحميل المنتجات وحفظها محلياً\nهذه العملية تحدث مرة واحدة فقط',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // شريط التقدم
                Column(
                  children: [
                    // النسبة المئوية
                    Text(
                      '${state.progress}%',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // شريط التقدم
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: state.progress / 100,
                        minHeight: 12,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue.shade600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // العداد
                    if (state.totalCount > 0)
                      Text(
                        '${state.currentCount} من ${state.totalCount} منتج',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 24),

                // رسالة الانتظار
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue.shade400,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'يرجى الانتظار...',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // رسالة معلوماتية
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.amber.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'لن تحتاج للانتظار في المرات القادمة',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
