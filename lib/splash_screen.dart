import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';

import 'features/Auth/presentation/pages/Auth_page.dart' show AuthPage;
import 'features/EmployeeScreen/presentation/pages/EmployeeScreen_page.dart';
import 'features/ManagerScreen/presentation/pages/ManagerScreen_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // جعل الـ Status Bar شفاف
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // إعداد الأنيميشن
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
          ),
        );

    // بدء الأنيميشن
    _controller.forward();

    // الانتقال للصفحة التالية بعد 3 ثواني
    Timer(const Duration(seconds: 3), _navigateToNextScreen);
  }

  Future<void> _navigateToNextScreen() async {
    // التحقق من تسجيل الدخول
    final isLoggedIn =
        await CacheService.getData(key: CacheKeys.rememberMe) ?? false;
    final role = await CacheService.getData(key: CacheKeys.userRole);

    Widget nextScreen;

    if (isLoggedIn && role == 'admin') {
      nextScreen = ManagerScreen();
    } else if (isLoggedIn && role == 'employee') {
      nextScreen = EmployeeScreenPage();
    } else {
      nextScreen = AuthPage();
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF667eea),
              const Color(0xFF764ba2),
              const Color(0xFFf093fb),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // خلفية متحركة
              _buildAnimatedBackground(),

              // المحتوى الرئيسي
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo مع أنيميشن
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: _buildLogo(isTablet),
                      ),
                    ),

                    SizedBox(height: isTablet ? 60 : 40),

                    // اسم التطبيق
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildAppName(isTablet),
                      ),
                    ),

                    SizedBox(height: isTablet ? 20 : 12),

                    // الوصف
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildDescription(isTablet),
                      ),
                    ),
                  ],
                ),
              ),

              // Loading indicator في الأسفل
              Positioned(
                bottom: isTablet ? 80 : 60,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildLoadingIndicator(isTablet),
                ),
              ),

              // Version في أسفل الشاشة
              Positioned(
                bottom: isTablet ? 30 : 20,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildVersion(isTablet),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            Positioned(
              top: -100 + (_controller.value * 50),
              right: -100 + (_controller.value * 30),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -150 + (_controller.value * 70),
              left: -150 + (_controller.value * 40),
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLogo(bool isTablet) {
    final logoSize = isTablet ? 180.0 : 120.0;

    return Container(
      width: logoSize,
      height: logoSize,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.inventory_2_rounded,
          size: logoSize * 0.5,
          color: const Color(0xFF667eea),
        ),
      ),
    );
  }

  Widget _buildAppName(bool isTablet) {
    return Text(
      'Stock Up',
      style: TextStyle(
        fontSize: isTablet ? 48 : 36,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 2,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(bool isTablet) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Text(
        'إدارة المخزون بذكاء',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: isTablet ? 20 : 16,
          color: Colors.white.withOpacity(0.9),
          fontWeight: FontWeight.w300,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(bool isTablet) {
    return Column(
      children: [
        SizedBox(
          width: isTablet ? 40 : 30,
          height: isTablet ? 40 : 30,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white.withOpacity(0.8),
            ),
          ),
        ),
        SizedBox(height: isTablet ? 20 : 16),
        Text(
          'جاري التحميل...',
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Widget _buildVersion(bool isTablet) {
    return Text(
      'الإصدار 1.0.0',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: isTablet ? 14 : 12,
        color: Colors.white.withOpacity(0.6),
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
