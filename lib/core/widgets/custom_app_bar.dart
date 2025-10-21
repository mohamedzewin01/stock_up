import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? startColor;
  final Color? endColor;
  final IconData? leadingIcon;
  final bool showShadow;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
    this.startColor,
    this.endColor,
    this.leadingIcon,
    this.showShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            startColor ?? const Color(0xFF2196F3),
            endColor ?? const Color(0xFF1976D2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: (startColor ?? const Color(0xFF2196F3)).withOpacity(
                    0.4,
                  ),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) ...[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(leadingIcon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
            ],
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: showBackButton
            ? Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                ),
              )
            : null,
        actions: actions != null
            ? actions!
                  .map(
                    (action) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: action,
                      ),
                    ),
                  )
                  .toList()
            : null,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

// ============================================
// أمثلة على الاستخدام المبهج:
// ============================================

// مثال 1: الصفحة الرئيسية - مع أيقونة
class HomePageExample extends StatelessWidget {
  const HomePageExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: CustomAppBar(
        title: 'لوحة التحكم',
        leadingIcon: Icons.dashboard_rounded,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(child: Text('محتوى الصفحة')),
    );
  }
}

// مثال 2: صفحة الإعدادات - ألوان رمادية راقية
class SettingsPageExample extends StatelessWidget {
  const SettingsPageExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: const CustomAppBar(
        title: 'الإعدادات',
        leadingIcon: Icons.settings_rounded,
        showBackButton: true,
        startColor: Color(0xFF607D8B),
        endColor: Color(0xFF455A64),
      ),
      body: const Center(child: Text('محتوى الصفحة')),
    );
  }
}

// مثال 3: صفحة المنتجات - برتقالي نابض بالحياة
class ProductsPageExample extends StatelessWidget {
  const ProductsPageExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: CustomAppBar(
        title: 'المنتجات',
        leadingIcon: Icons.shopping_bag_rounded,
        showBackButton: true,
        startColor: const Color(0xFFFF9800),
        endColor: const Color(0xFFF57C00),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(child: Text('محتوى الصفحة')),
    );
  }
}

// مثال 4: صفحة المبيعات - أحمر جذاب
class SalesPageExample extends StatelessWidget {
  const SalesPageExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: CustomAppBar(
        title: 'المبيعات',
        leadingIcon: Icons.point_of_sale_rounded,
        showBackButton: true,
        startColor: const Color(0xFFF44336),
        endColor: const Color(0xFFD32F2F),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(child: Text('محتوى الصفحة')),
    );
  }
}

// مثال 5: صفحة الجرد - أخضر منعش
// class InventoryPageExample extends StatelessWidget {
//   const InventoryPageExample({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       appBar: CustomAppBar(
//         title: 'الجرد',
//         leadingIcon: Icons.inventory_2_rounded,
//         showBackButton: true,
//         startColor: const Color(0xFF4CAF50),
//         endColor: const Color(0xFF388E3C),
//         actions: [
//           IconButton(
//             icon: const Icon(
//               Icons.qr_code_scanner_rounded,
//               color: Colors.white,
//             ),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: const Center(child: Text('محتوى الصفحة')),
//     );
//   }
// }

// مثال 6: دفتر اليومية - بنفسجي أنيق
class JournalPageExample extends StatelessWidget {
  const JournalPageExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: CustomAppBar(
        title: 'دفتر اليومية',
        leadingIcon: Icons.book_rounded,
        showBackButton: true,
        startColor: const Color(0xFF9C27B0),
        endColor: const Color(0xFF7B1FA2),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_rounded, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.print_rounded, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(child: Text('محتوى الصفحة')),
    );
  }
}

// مثال 7: مع Animated AppBar (متحرك)
class AnimatedAppBarExample extends StatefulWidget {
  const AnimatedAppBarExample({Key? key}) : super(key: key);

  @override
  State<AnimatedAppBarExample> createState() => _AnimatedAppBarExampleState();
}

class _AnimatedAppBarExampleState extends State<AnimatedAppBarExample> {
  final ScrollController _scrollController = ScrollController();
  bool _showShadow = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 10 && !_showShadow) {
        setState(() => _showShadow = true);
      } else if (_scrollController.offset <= 10 && _showShadow) {
        setState(() => _showShadow = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: CustomAppBar(
        title: 'قائمة متحركة',
        leadingIcon: Icons.list_rounded,
        showBackButton: true,
        showShadow: _showShadow,
        startColor: const Color(0xFF00BCD4),
        endColor: const Color(0xFF0097A7),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: 50,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('عنصر $index'),
            leading: const Icon(Icons.star),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// ألوان مخصصة للتطبيق
class AppBarColors {
  static const List<Color> blue = [Color(0xFF2196F3), Color(0xFF1976D2)];
  static const List<Color> green = [Color(0xFF4CAF50), Color(0xFF388E3C)];
  static const List<Color> orange = [Color(0xFFFF9800), Color(0xFFF57C00)];
  static const List<Color> purple = [Color(0xFF9C27B0), Color(0xFF7B1FA2)];
  static const List<Color> red = [Color(0xFFF44336), Color(0xFFD32F2F)];
  static const List<Color> grey = [Color(0xFF607D8B), Color(0xFF455A64)];
  static const List<Color> teal = [Color(0xFF00BCD4), Color(0xFF0097A7)];
  static const List<Color> pink = [Color(0xFFE91E63), Color(0xFFC2185B)];
  static const List<Color> indigo = [Color(0xFF3F51B5), Color(0xFF303F9F)];
}
