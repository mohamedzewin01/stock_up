import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_up/core/widgets/custom_text_field_widget.dart';
import 'package:stock_up/features/Auth/data/models/request/login_request.dart';
import 'package:stock_up/features/Auth/presentation/bloc/Auth_cubit.dart';
import 'package:stock_up/features/Auth/presentation/widgets/custom_button.dart';
import 'package:stock_up/features/Auth/presentation/widgets/remember_me.dart';
import 'package:stock_up/features/Auth/presentation/widgets/store_dropdown.dart';
import 'package:stock_up/features/ManagerHome/presentation/pages/ManagerHome_page.dart';
import 'package:stock_up/features/Search/presentation/pages/Search_page.dart';
import 'package:stock_up/features/Stores/data/models/response/all_stores_model.dart';
import 'package:stock_up/features/Stores/presentation/bloc/Stores_cubit.dart';

class FormCard extends StatefulWidget {
  const FormCard({super.key});

  @override
  State<FormCard> createState() => _FormCardState();
}

class _FormCardState extends State<FormCard> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  Results? _selectedStore;
  bool _isLoadingPreferences = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  // تحميل البيانات المحفوظة
  Future<void> _loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberMe = prefs.getBool('remember_me') ?? false;

      if (rememberMe) {
        final savedMobile = prefs.getString('mobile_number') ?? '';
        final savedPassword = prefs.getString('password') ?? '';
        final savedStoreId = prefs.getInt('store_id');

        setState(() {
          _rememberMe = rememberMe;
          _mobileController.text = savedMobile;
          _passwordController.text = savedPassword;
          // يمكنك حفظ وتحميل المتجر المحدد أيضاً إذا كان لديك ID
        });
      }
    } catch (e) {
      debugPrint('Error loading credentials: $e');
    } finally {
      setState(() {
        _isLoadingPreferences = false;
      });
    }
  }

  // حفظ البيانات
  Future<void> _saveCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (_rememberMe) {
        await prefs.setBool('remember_me', true);
        await prefs.setString('mobile_number', _mobileController.text.trim());
        await prefs.setString('password', _passwordController.text);
        if (_selectedStore?.id != null) {
          await prefs.setInt('store_id', _selectedStore!.id!);
        }
      } else {
        // حذف البيانات المحفوظة
        await prefs.remove('remember_me');
        await prefs.remove('mobile_number');
        await prefs.remove('password');
        await prefs.remove('store_id');
      }
    } catch (e) {
      debugPrint('Error saving credentials: $e');
    }
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedStore == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء اختيار المتجر'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // حفظ البيانات قبل تسجيل الدخول
      await _saveCredentials();

      final loginRequest = LoginRequest(
        mobileNumber: _mobileController.text.trim(),
        password: _passwordController.text,
      );

      context.read<AuthCubit>().login(
        loginRequest.mobileNumber.toString(),
        loginRequest.password.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingPreferences) {
      return Container(
        constraints: const BoxConstraints(maxWidth: 450),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Form(
      key: _formKey,
      child: Container(
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
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  );
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
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'خطأ في تحميل المتاجر: ${state.exception}',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
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

            // تذكرني
            RememberMe(
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
            const SizedBox(height: 24),

            // زر تسجيل الدخول
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthSuccess) {
                  var data = state.loginEntity?.user;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تم تسجيل الدخول بنجاح'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  if (data?.role == 'admin') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ManagerHome()),
                    );
                  } else if (data?.role == 'employee') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SearchPage()),
                    );
                  }
                } else if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('تاكد من البيانات المدخلة'),
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
      ),
    );
  }
}
