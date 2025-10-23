import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_up/features/Auth/data/models/request/login_request.dart';
import 'package:stock_up/features/Auth/presentation/bloc/Auth_cubit.dart';
import 'package:stock_up/features/Auth/presentation/widgets/custom_button.dart';
import 'package:stock_up/features/Auth/presentation/widgets/remember_me.dart';
import 'package:stock_up/features/Auth/presentation/widgets/store_dropdown.dart';
import 'package:stock_up/features/ManagerHome/presentation/pages/ManagerHome_page.dart';
import 'package:stock_up/features/Stores/data/models/response/all_stores_model.dart';
import 'package:stock_up/features/Stores/presentation/bloc/Stores_cubit.dart';

class FormCard extends StatefulWidget {
  const FormCard({super.key});

  @override
  State<FormCard> createState() => _FormCardState();
}

class _FormCardState extends State<FormCard> with TickerProviderStateMixin {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  Results? _selectedStore;
  bool _isLoadingPreferences = true;

  late AnimationController _shakeController;
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _hoverAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberMe = prefs.getBool('remember_me') ?? false;

      if (rememberMe) {
        final savedMobile = prefs.getString('mobile_number') ?? '';
        final savedPassword = prefs.getString('password') ?? '';

        setState(() {
          _rememberMe = rememberMe;
          _mobileController.text = savedMobile;
          _passwordController.text = savedPassword;
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
        await prefs.remove('remember_me');
        await prefs.remove('mobile_number');
        await prefs.remove('password');
        await prefs.remove('store_id');
      }
    } catch (e) {
      debugPrint('Error saving credentials: $e');
    }
  }

  void _shakeForm() {
    _shakeController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    _shakeController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedStore == null) {
        _shakeForm();
        _showPremiumSnackBar(context, 'الرجاء اختيار المتجر', isError: true);
        return;
      }

      await _saveCredentials();

      final loginRequest = LoginRequest(
        mobileNumber: _mobileController.text.trim(),
        password: _passwordController.text,
      );

      context.read<AuthCubit>().login(
        loginRequest.mobileNumber.toString(),
        loginRequest.password.toString(),
        _selectedStore!.id!,
      );
    } else {
      _shakeForm();
    }
  }

  void _showPremiumSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isError
                      ? [
                          const Color(0xFFE63946).withOpacity(0.9),
                          const Color(0xFFD62828).withOpacity(0.9),
                        ]
                      : [
                          const Color(0xFF06FFA5).withOpacity(0.9),
                          const Color(0xFF00D9FF).withOpacity(0.9),
                        ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isError
                          ? Icons.error_outline_rounded
                          : Icons.check_circle_outline_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        padding: EdgeInsets.zero,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    if (_isLoadingPreferences) {
      return _buildLoadingCard(isTablet);
    }

    return MouseRegion(
      onEnter: (_) => _hoverController.forward(),
      onExit: (_) => _hoverController.reverse(),
      child: AnimatedBuilder(
        animation: Listenable.merge([_shakeController, _hoverAnimation]),
        builder: (context, child) {
          final shake = _shakeController.value;
          final offset = sin(shake * pi * 3) * 8;
          return Transform.translate(
            offset: Offset(offset, 0),
            child: Transform.scale(
              scale: 1.0 + (_hoverAnimation.value * 0.02),
              child: child,
            ),
          );
        },
        child: Form(
          key: _formKey,
          child: Container(
            constraints: BoxConstraints(maxWidth: isTablet ? 520 : 460),
            child: Stack(
              children: [
                // Outer glow
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF9D4EDD).withOpacity(0.3),
                          blurRadius: 60,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                // Main card
                ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: EdgeInsets.all(isTablet ? 36 : 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ة// // Premium header
                          // _buildPremiumHeader(),
                          // const SizedBox(height: 32),

                          // Store Dropdown
                          BlocBuilder<StoresCubit, StoresState>(
                            builder: (context, state) {
                              if (state is StoresLoading) {
                                return _buildStoreLoadingWidget();
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
                                return _buildStoreErrorWidget();
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          const SizedBox(height: 12),

                          // Mobile Number Field
                          _buildPremiumTextField(
                            controller: _mobileController,
                            label: 'رقم الجوال',
                            hint: '05xxxxxxxx',
                            prefixIcon: Icons.phone_iphone_rounded,
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
                          const SizedBox(height: 12),

                          // Password Field
                          _buildPasswordField(),
                          const SizedBox(height: 12),

                          // Remember Me
                          RememberMe(
                            value: _rememberMe,
                            onChanged: (value) {
                              setState(() {
                                _rememberMe = value;
                              });
                            },
                          ),
                          const SizedBox(height: 12),

                          // Login Button
                          BlocConsumer<AuthCubit, AuthState>(
                            listener: (context, state) {
                              if (state is AuthSuccess) {
                                _showPremiumSnackBar(
                                  context,
                                  'تم تسجيل الدخول بنجاح! 🎉',
                                  isError: false,
                                );
                                Future.delayed(
                                  const Duration(milliseconds: 800),
                                  () {
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (
                                              context,
                                              animation,
                                              secondaryAnimation,
                                            ) => const ManagerHome(),
                                        transitionsBuilder:
                                            (
                                              context,
                                              animation,
                                              secondaryAnimation,
                                              child,
                                            ) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: ScaleTransition(
                                                  scale:
                                                      Tween<double>(
                                                        begin: 0.8,
                                                        end: 1.0,
                                                      ).animate(
                                                        CurvedAnimation(
                                                          parent: animation,
                                                          curve: Curves
                                                              .easeOutCubic,
                                                        ),
                                                      ),
                                                  child: child,
                                                ),
                                              );
                                            },
                                        transitionDuration: const Duration(
                                          milliseconds: 600,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else if (state is AuthFailure) {
                                _shakeForm();
                                _showPremiumSnackBar(
                                  context,
                                  'تأكد من البيانات المدخلة',
                                  isError: true,
                                );
                              }
                            },
                            builder: (context, state) {
                              final isLoading = state is AuthLoading;
                              return CustomButton(
                                text: 'تسجيل الدخول',
                                onPressed: isLoading ? null : _handleLogin,
                                isLoading: isLoading,
                                icon: Icons.login_rounded,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildPremiumHeader() {
  //   return Column(
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //             decoration: BoxDecoration(
  //               gradient: LinearGradient(
  //                 colors: [
  //                   const Color(0xFF9D4EDD).withOpacity(0.3),
  //                   const Color(0xFF7B2CBF).withOpacity(0.3),
  //                 ],
  //               ),
  //               borderRadius: BorderRadius.circular(20),
  //               border: Border.all(
  //                 color: Colors.white.withOpacity(0.3),
  //                 width: 1,
  //               ),
  //             ),
  //             child: Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Icon(
  //                   Icons.lock_rounded,
  //                   color: Colors.white.withOpacity(0.9),
  //                   size: 16,
  //                 ),
  //                 const SizedBox(width: 8),
  //                 Text(
  //                   'تسجيل دخول آمن',
  //                   style: TextStyle(
  //                     fontSize: 13,
  //                     color: Colors.white.withOpacity(0.9),
  //                     fontWeight: FontWeight.w600,
  //                     letterSpacing: 0.5,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //       const SizedBox(height: 16),
  //       Text(
  //         'أدخل بياناتك',
  //         style: TextStyle(
  //           fontSize: 20,
  //           color: Colors.white.withOpacity(0.95),
  //           fontWeight: FontWeight.bold,
  //           letterSpacing: 0.5,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildLoadingCard(bool isTablet) {
    return Container(
      constraints: BoxConstraints(maxWidth: isTablet ? 520 : 460),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: EdgeInsets.all(isTablet ? 36 : 28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF9D4EDD),
                ),
                strokeWidth: 3,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreLoadingWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withOpacity(0.8),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'جاري تحميل المتاجر...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFE63946).withOpacity(0.2),
            const Color(0xFFD62828).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE63946).withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: Colors.white.withOpacity(0.9),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'خطأ في تحميل المتاجر',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 10),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
              letterSpacing: 0.3,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.95),
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 14,
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.only(left: 12, right: 16),
                child: Icon(
                  prefixIcon,
                  color: const Color(0xFF9D4EDD),
                  size: 22,
                ),
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF9D4EDD),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: const Color(0xFFE63946).withOpacity(0.8),
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFFE63946),
                  width: 2,
                ),
              ),
              errorStyle: TextStyle(
                fontSize: 12,
                color: const Color(0xFFE63946).withOpacity(0.9),
                height: 0.8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 10),
          child: Text(
            'كلمة المرور',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
              letterSpacing: 0.3,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.95),
              fontWeight: FontWeight.w500,
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
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 14,
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.only(left: 12, right: 16),
                child: const Icon(
                  Icons.lock_rounded,
                  color: Color(0xFF9D4EDD),
                  size: 22,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: Colors.white.withOpacity(0.6),
                  size: 22,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFF9D4EDD),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: const Color(0xFFE63946).withOpacity(0.8),
                  width: 1.5,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFFE63946),
                  width: 2,
                ),
              ),
              errorStyle: TextStyle(
                fontSize: 12,
                color: const Color(0xFFE63946).withOpacity(0.9),
                height: 0.8,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
