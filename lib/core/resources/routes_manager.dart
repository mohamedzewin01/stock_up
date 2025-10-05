import 'package:flutter/material.dart';




class RoutesManager {

  static const String loginPage = '/LoginPage';
  // static const String homePage = '/HomePage';


}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {

        // case RoutesManager.homePage:
        // return FadeScaleAnimation(const HomePage());
      //   case RoutesManager.homePage:
      //   return FadeScaleAnimation(const HomePage());
      //   case RoutesManager.groupsPage:
      //   return FadeScaleAnimation(const GroupsPage());
      //   case RoutesManager.createGroupScreen:
      //   return FadeScaleAnimation(const CreateGroupScreen());


      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return ScaleRotateAnimation(
      Scaffold(
        appBar: AppBar(
          title: const Text('صفحة غير موجودة'),
          backgroundColor: Colors.red.shade400,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.red.shade50,
                Colors.white,
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TweenAnimationBuilder<double>(
                  duration: const Duration(seconds: 2),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.rotate(
                      angle: value * 0.1,
                      child: Icon(
                        Icons.error_outline_rounded,
                        size: 80,
                        color: Colors.red.shade300,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'المسار غير موجود',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'الصفحة المطلوبة غير متوفرة',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('العودة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade400,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
}

/// التأثير الأساسي: Fade + Slide محسن
class NavigateAnimation extends PageRouteBuilder {
  final Widget page;

  NavigateAnimation(this.page)
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 500),
    reverseTransitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // منحنى متطور للتأثير
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubic,
      );

      // تأثير مركب: Slide + Fade + Scale خفيف
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: FadeTransition(
          opacity: curvedAnimation,
          child: Transform.scale(
            scale: Tween<double>(
              begin: 0.95,
              end: 1.0,
            ).animate(curvedAnimation).value,
            child: child,
          ),
        ),
      );
    },
  );
}

/// تأثير Fade + Scale للصفحات الرئيسية
class FadeScaleAnimation extends PageRouteBuilder {
  final Widget page;

  FadeScaleAnimation(this.page)
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 600),
    reverseTransitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutQuart,
      );

      return FadeTransition(
        opacity: curvedAnimation,
        child: ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}

/// تأثير Slide من الأسفل للمودال والصفحات الثانوية
class SlideFromBottomAnimation extends PageRouteBuilder {
  final Widget page;

  SlideFromBottomAnimation(this.page)
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 450),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );

      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: FadeTransition(
          opacity: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}

/// تأثير Scale + Rotate للصفحات الخاصة
class ScaleRotateAnimation extends PageRouteBuilder {
  final Widget page;

  ScaleRotateAnimation(this.page)
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 700),
    reverseTransitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.elasticOut,
      );

      return Transform.scale(
        scale: Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(curvedAnimation).value,
        child: Transform.rotate(
          angle: Tween<double>(
            begin: 0.5,
            end: 0.0,
          ).animate(curvedAnimation).value,
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        ),
      );
    },
  );
}

/// تأثير 3D Flip للانتقالات المميزة


/// تأثير Slide متعدد الاتجاهات
class MultiDirectionSlideAnimation extends PageRouteBuilder {
  final Widget page;
  final SlideDirection direction;

  MultiDirectionSlideAnimation(
      this.page, {
        this.direction = SlideDirection.fromRight,
      }) : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubic,
      );

      Offset begin;
      switch (direction) {
        case SlideDirection.fromLeft:
          begin = const Offset(-1.0, 0.0);
          break;
        case SlideDirection.fromRight:
          begin = const Offset(1.0, 0.0);
          break;
        case SlideDirection.fromTop:
          begin = const Offset(0.0, -1.0);
          break;
        case SlideDirection.fromBottom:
          begin = const Offset(0.0, 1.0);
          break;
      }

      return SlideTransition(
        position: Tween<Offset>(
          begin: begin,
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: FadeTransition(
          opacity: curvedAnimation,
          child: child,
        ),
      );
    },
  );
}

enum SlideDirection {
  fromLeft,
  fromRight,
  fromTop,
  fromBottom,
}

/// تأثير متقدم مع Blur
class BlurFadeAnimation extends PageRouteBuilder {
  final Widget page;

  BlurFadeAnimation(this.page)
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 600),
    reverseTransitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutQuart,
      );

      return AnimatedBuilder(
        animation: curvedAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: curvedAnimation,
            child: Transform.scale(
              scale: 0.8 + (0.2 * curvedAnimation.value),
              child: child,
            ),
          );
        },
        child: child,
      );
    },
  );
}

/// تأثير موجي متقدم
class WaveAnimation extends PageRouteBuilder {
  final Widget page;

  WaveAnimation(this.page)
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: const Duration(milliseconds: 800),
    reverseTransitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return ClipPath(
            clipper: WaveClipper(animation.value),
            child: child,
          );
        },
        child: child,
      );
    },
  );
}

class WaveClipper extends CustomClipper<Path> {
  final double animationValue;

  WaveClipper(this.animationValue);

  @override
  Path getClip(Size size) {
    final path = Path();
    final waveHeight = 50.0 * (1 - animationValue);

    if (animationValue == 1.0) {
      path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
      return path;
    }

    path.moveTo(0, waveHeight);

    for (double i = 0; i <= size.width; i++) {
      final y = waveHeight *
          (1 + 0.5 *
              (1 - animationValue) *
              (1 + (i / size.width) * 2 - 1).abs()) +
          waveHeight * animationValue;
      path.lineTo(i, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) {
    return oldClipper.animationValue != animationValue;
  }
}