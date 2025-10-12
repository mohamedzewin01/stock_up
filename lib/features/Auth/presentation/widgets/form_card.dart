import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/core/widgets/custom_text_field_widget.dart';
import 'package:stock_up/features/Auth/presentation/bloc/Auth_cubit.dart';
import 'package:stock_up/features/Auth/presentation/widgets/custom_button.dart';
import 'package:stock_up/features/Auth/presentation/widgets/remember_me.dart';
import 'package:stock_up/features/Auth/presentation/widgets/store_dropdown.dart';
import 'package:stock_up/features/Stores/presentation/bloc/Stores_cubit.dart';

class FormCard extends StatefulWidget {
  const FormCard({super.key});

  @override
  State<FormCard> createState() => _FormCardState();
}

class _FormCardState extends State<FormCard> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 450),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // قائمة اختيار المتجر
          BlocBuilder<StoresCubit, StoresState>(
            builder: (context, state) {
              if (state is StoresLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is StoresSuccess) {
                return StoreDropdown(
                  stores: state.allStoresEntity.results ?? [],
                  selectedStore: _selectedStore,
                  onChanged: (store) {
                    setState(() {
                      _selectedStore = store;
                    });
                  },
                );
              } else if (state is StoresFailure) {
                return Text(
                  'خطأ في تحميل المتاجر: ${state.exception}',
                  style: const TextStyle(color: Colors.red),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 20),

          // حقل رقم الجوال
          CustomTextField(
            controller: _mobileController,
            label: 'رقم الجوال',
            hint: '05xxxxxxxx',
            prefixIcon: Icons.phone_android,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال رقم الجوال';
              }
              if (!RegExp(r'^05\d{8}$').hasMatch(value)) {
                return 'رقم الجوال غير صحيح';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // حقل كلمة المرور
          CustomTextField(
            controller: _passwordController,
            label: 'كلمة المرور',
            hint: '••••••••',
            prefixIcon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال كلمة المرور';
              }
              if (value.length < 6) {
                return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // خيار حفظ بيانات الدخول
          RememberMe(),
          const SizedBox(height: 24),

          // زر تسجيل الدخول
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم تسجيل الدخول بنجاح'),
                    backgroundColor: Colors.green,
                  ),
                );
                // الانتقال للصفحة الرئيسية
                // Navigator.pushReplacementNamed(context, '/home');
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.exception.toString()),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              return CustomButton(
                text: 'تسجيل الدخول',
                onPressed: isLoading ? null : _handleLogin,
                isLoading: isLoading,
              );
            },
          ),
        ],
      ),
    );
  }
}
