import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/features/Auth/presentation/bloc/Auth_cubit.dart';
import 'package:stock_up/features/Auth/presentation/widgets/form_card.dart';
import 'package:stock_up/features/Stores/data/models/response/all_stores_model.dart';
import 'package:stock_up/features/Stores/presentation/bloc/Stores_cubit.dart';

import '../../../../core/di/di.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  late AuthCubit authViewModel;
  late StoresCubit storesViewModel;
  Results? _selectedStore;
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    authViewModel = getIt.get<AuthCubit>();
    storesViewModel = getIt.get<StoresCubit>();
    // جلب المتاجر المتاحة عند تحميل الصفحة
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      if (_selectedStore == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء اختيار المتجر'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // تنفيذ عملية تسجيل الدخول
      context.read<AuthCubit>().login(
        _mobileController.toString(),
        _passwordController.toString(),
        _selectedStore!.id! + 1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authViewModel),
        BlocProvider.value(value: storesViewModel..getAllStores()),
      ],

      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // شعار التطبيق
                    _buildLogo(),
                    const SizedBox(height: 40),

                    // عنوان الصفحة
                    _buildTitle(),
                    const SizedBox(height: 8),
                    _buildSubtitle(),
                    const SizedBox(height: 40),

                    // بطاقة تحتوي على عناصر النموذج
                    FormCard(),
                    const SizedBox(height: 24),

                    // // رابط نسيت كلمة المرور (اختياري)
                    // _buildForgotPassword(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.blue[700],
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(Icons.store_rounded, size: 50, color: Colors.white),
    );
  }

  Widget _buildTitle() {
    return const Text(
      'مرحباً بك',
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E293B),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'سجل الدخول للمتابعة',
      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
    );
  }
}
