// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:stock_up/features/Auth/presentation/bloc/Auth_cubit.dart';
// import 'package:stock_up/features/Auth/presentation/widgets/form_card.dart';
// import 'package:stock_up/features/Stores/data/models/response/all_stores_model.dart';
// import 'package:stock_up/features/Stores/presentation/bloc/Stores_cubit.dart';
//
// import '../../../../core/di/di.dart';
//
// class AuthPage extends StatefulWidget {
//   const AuthPage({super.key});
//
//   @override
//   State<AuthPage> createState() => _AuthPageState();
// }
//
// class _AuthPageState extends State<AuthPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _mobileController = TextEditingController();
//   final _passwordController = TextEditingController();
//   late AuthCubit authViewModel;
//   late StoresCubit storesViewModel;
//   Results? _selectedStore;
//   bool _rememberMe = false;
//   bool _obscurePassword = true;
//
//   @override
//   void initState() {
//     super.initState();
//     authViewModel = getIt.get<AuthCubit>();
//     storesViewModel = getIt.get<StoresCubit>();
//     // جلب المتاجر المتاحة عند تحميل الصفحة
//   }
//
//   @override
//   void dispose() {
//     _mobileController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   void _handleLogin() {
//     if (_formKey.currentState!.validate()) {
//       if (_selectedStore == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('الرجاء اختيار المتجر'),
//             backgroundColor: Colors.red,
//           ),
//         );
//         return;
//       }
//
//       // تنفيذ عملية تسجيل الدخول
//       context.read<AuthCubit>().login(
//         _mobileController.toString(),
//         _passwordController.toString(),
//         _selectedStore!.id! + 1,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider.value(value: authViewModel),
//         BlocProvider.value(value: storesViewModel..getAllStores()),
//       ],
//
//       child: Scaffold(
//         backgroundColor: Colors.grey[50],
//         body: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // شعار التطبيق
//                     _buildLogo(),
//                     const SizedBox(height: 40),
//
//                     // عنوان الصفحة
//                     _buildTitle(),
//                     const SizedBox(height: 8),
//                     _buildSubtitle(),
//                     const SizedBox(height: 40),
//
//                     // بطاقة تحتوي على عناصر النموذج
//                     FormCard(),
//                     const SizedBox(height: 24),
//
//                     // // رابط نسيت كلمة المرور (اختياري)
//                     // _buildForgotPassword(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLogo() {
//     return Container(
//       width: 100,
//       height: 100,
//       decoration: BoxDecoration(
//         color: Colors.blue[700],
//         shape: BoxShape.circle,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blue.withOpacity(0.3),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: const Icon(Icons.store_rounded, size: 50, color: Colors.white),
//     );
//   }
//
//   Widget _buildTitle() {
//     return const Text(
//       'مرحباً بك',
//       style: TextStyle(
//         fontSize: 32,
//         fontWeight: FontWeight.bold,
//         color: Color(0xFF1E293B),
//       ),
//     );
//   }
//
//   Widget _buildSubtitle() {
//     return Text(
//       'سجل الدخول للمتابعة',
//       style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//     );
//   }
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_up/assets_manager.dart';
import 'package:stock_up/core/constants/app_constants.dart';
import 'package:stock_up/core/resources/style_manager.dart';
import 'package:stock_up/core/widgets/animated_background.dart';
import 'package:stock_up/features/Auth/presentation/bloc/Auth_cubit.dart';
import 'package:stock_up/features/Auth/presentation/widgets/form_card.dart';
import 'package:stock_up/features/Stores/presentation/bloc/Stores_cubit.dart';

import '../../../../core/di/di.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  late AuthCubit authViewModel;
  late StoresCubit storesViewModel;
  late AnimationController _backgroundController;
  late AnimationController _logoController;
  late AnimationController _formController;
  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _formFade;
  late Animation<Offset> _formSlide;

  @override
  void initState() {
    super.initState();
    authViewModel = getIt.get<AuthCubit>();
    storesViewModel = getIt.get<StoresCubit>();

    // Background animation
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    // Logo animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoRotation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );

    // Form animation
    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _formFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _formController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _formSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _formController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    // Start animations
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 500), () {
      _formController.forward();
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _logoController.dispose();
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authViewModel),
        BlocProvider.value(value: storesViewModel..getAllStores()),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            // Animated Background
            // _buildAnimatedBackground(),
            AnimatedGradientBackground(),
            // Floating Particles
            _buildFloatingParticles(),

            // Main Content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 60.0 : 28.0,
                    vertical: 32.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Logo with particles
                      _buildPremiumLogo(),
                      SizedBox(height: isTablet ? 26 : 16),

                      // Premium Title Section
                      FadeTransition(
                        opacity: _formFade,
                        child: _buildPremiumTitle(),
                      ),
                      SizedBox(height: isTablet ? 30 : 10),

                      // Form Card
                      SlideTransition(
                        position: _formSlide,
                        child: FadeTransition(
                          opacity: _formFade,
                          child: const FormCard(),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Premium Footer
                      FadeTransition(
                        opacity: _formFade,
                        child: _buildPremiumFooter(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildAnimatedBackground() {
  //   return AnimatedBuilder(
  //     animation: _backgroundController,
  //     builder: (context, child) {
  //       return Container(
  //         decoration: BoxDecoration(
  //           gradient: LinearGradient(
  //             begin: Alignment.topLeft,
  //             end: Alignment.bottomRight,
  //             colors: [
  //               Color.lerp(
  //                 const Color(0xFF1A1A2E),
  //                 const Color(0xFF16213E),
  //                 (_backgroundController.value * 2) % 1,
  //               )!,
  //               Color.lerp(
  //                 const Color(0xFF0F3460),
  //                 const Color(0xFF16213E),
  //                 (_backgroundController.value * 2 + 0.5) % 1,
  //               )!,
  //               Color.lerp(
  //                 const Color(0xFF533483),
  //                 const Color(0xFF7B2CBF),
  //                 (_backgroundController.value * 2 + 0.7) % 1,
  //               )!,
  //             ],
  //             stops: const [0.0, 0.5, 1.0],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildFloatingParticles() {
    return Stack(
      children: List.generate(20, (index) {
        return _FloatingParticle(
          key: ValueKey(index),
          size: (index % 3 + 1) * 3.0,
          duration: Duration(seconds: 10 + (index % 5) * 2),
          delay: Duration(milliseconds: index * 200),
        );
      }),
    );
  }

  Widget _buildPremiumLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScale.value,
          child: Transform.rotate(
            angle: _logoRotation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow ring
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF7B2CBF).withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Middle ring
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF7B2CBF).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                ),
                // Main logo container
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF9D4EDD),
                        Color(0xFF7B2CBF),
                        Color(0xFF5A189A),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7B2CBF).withOpacity(0.5),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                      BoxShadow(
                        color: const Color(0xFF9D4EDD).withOpacity(0.3),
                        blurRadius: 60,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Image.asset(Assets.logoPng, height: 25, width: 25),
                    // const Icon(
                    //   Icons.store_rounded,
                    //   size: 60,
                    //   color: Colors.white,
                    // ),
                  ),
                ),
                // Rotating ring
                AnimatedBuilder(
                  animation: _backgroundController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _backgroundController.value * 2 * 3.14159,
                      child: Container(
                        width: 135,
                        height: 135,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: CustomPaint(painter: _DottedCirclePainter()),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPremiumTitle() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFE0AAFF), Color(0xFFC77DFF)],
          ).createShader(bounds),
          child: Text(
            'مرحباً بك',
            style: getSemiBoldStyle(fontSize: 42, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumFooter() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.05),
                Colors.white.withOpacity(0.02),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.security_rounded,
                color: Colors.white.withOpacity(0.6),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'اتصال آمن ومشفر',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppConstants.copyright,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.5),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _FloatingParticle extends StatefulWidget {
  final double size;
  final Duration duration;
  final Duration delay;

  const _FloatingParticle({
    super.key,
    required this.size,
    required this.duration,
    required this.delay,
  });

  @override
  State<_FloatingParticle> createState() => _FloatingParticleState();
}

class _FloatingParticleState extends State<_FloatingParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late double _startX;
  late double _startY;

  @override
  void initState() {
    super.initState();
    _startX = (DateTime.now().millisecondsSinceEpoch % 100) / 100;
    _startY = (DateTime.now().microsecondsSinceEpoch % 100) / 100;

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = Tween<Offset>(
      begin: Offset(_startX, _startY + 1),
      end: Offset(_startX + 0.2, -0.5),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: _animation.value.dx * size.width,
          top: _animation.value.dy * size.height,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.6),
                  Colors.white.withOpacity(0.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DottedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dotCount = 12;
    const radius = 67.5;
    final center = Offset(size.width / 2, size.height / 2);

    for (var i = 0; i < dotCount; i++) {
      final angle = (i * 2 * 3.14159) / dotCount;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
