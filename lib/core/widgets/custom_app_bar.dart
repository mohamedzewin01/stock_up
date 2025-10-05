import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom Sliver App Bar for the entire application
/// Provides a reusable, animated app bar with gradient background
class CustomSliverAppBar extends StatelessWidget {
  /// The title to display in the app bar
  final String title;

  /// Optional subtitle to display below the title
  final String? subtitle;

  /// Icon to display in the app bar
  final IconData icon;

  /// Background gradient colors
  final List<Color>? gradientColors;

  /// Actions to display on the right side of the app bar
  final List<Widget>? actions;

  /// Whether to show the back button
  final bool showBackButton;

  /// Custom leading widget (overrides showBackButton)
  final Widget? leading;

  /// Height of the expanded app bar
  final double expandedHeight;

  /// Whether the app bar should float
  final bool floating;

  /// Whether the app bar should pin when collapsed
  final bool pinned;

  /// Whether the app bar should snap
  final bool snap;

  /// Custom background widget (overrides gradient)
  final Widget? background;

  /// Text style for the title
  final TextStyle? titleStyle;

  /// Text style for the subtitle
  final TextStyle? subtitleStyle;

  /// Elevation of the app bar
  final double elevation;

  /// Custom shape for the app bar
  final ShapeBorder? shape;

  /// Callback when back button is pressed
  final VoidCallback? onBackPressed;

  const CustomSliverAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.apps_rounded,
    this.gradientColors,
    this.actions,
    this.showBackButton = false,
    this.leading,
    this.expandedHeight = 200.0,
    this.floating = false,
    this.pinned = true,
    this.snap = false,
    this.background,
    this.titleStyle,
    this.subtitleStyle,
    this.elevation = 0,
    this.shape,
    this.onBackPressed,
  });

  /// Factory constructor for the main app pages
  factory CustomSliverAppBar.main({
    required String title,
    String? subtitle,
    IconData icon = Icons.apps_rounded,
    List<Widget>? actions,
  }) {
    return CustomSliverAppBar(
      title: title,
      subtitle: subtitle,
      icon: icon,
      actions: actions,
      gradientColors: const [Color(0xFF667EEA), Color(0xFF764BA2)],
      expandedHeight: 180.0,
    );
  }

  /// Factory constructor for secondary pages with back button
  factory CustomSliverAppBar.secondary({
    required String title,
    String? subtitle,
    IconData icon = Icons.apps_rounded,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
  }) {
    return CustomSliverAppBar(
      title: title,
      subtitle: subtitle,
      icon: icon,
      actions: actions,
      showBackButton: true,
      onBackPressed: onBackPressed,
      gradientColors: const [Color(0xFF667EEA), Color(0xFF764BA2)],
      expandedHeight: 140.0,
    );
  }

  /// Factory constructor for minimal app bar
  factory CustomSliverAppBar.minimal({
    required String title,
    List<Widget>? actions,
    bool showBackButton = false,
    VoidCallback? onBackPressed,
  }) {
    return CustomSliverAppBar(
      title: title,
      icon: Icons.circle,
      actions: actions,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
      gradientColors: const [Color(0xFF667EEA), Color(0xFF764BA2)],
      expandedHeight: 100.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultGradientColors = gradientColors ??
        [const Color(0xFF667EEA), const Color(0xFF764BA2)];

    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: floating,
      pinned: pinned,
      snap: snap,
      elevation: elevation,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      automaticallyImplyLeading: false,
      shape: shape ?? _defaultShape(),
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: background ?? _buildBackground(defaultGradientColors, context),
        titlePadding: const EdgeInsetsDirectional.only(
          start: 16.0,
          bottom: 16.0,
          end: 16.0,
        ),
        collapseMode: CollapseMode.parallax,
      ),
      leading: _buildLeading(context),
      actions: actions,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (showBackButton) {
      return Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: IconButton(
          onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      );
    }

    return null;
  }

  Widget _buildBackground(List<Color> colors, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              showBackButton || leading != null ? 80 : 24,
              20,
              actions != null ? 80 : 24,
              24,
            ),
            child: Column(
              crossAxisAlignment: Directionality.of(context) == TextDirection.rtl
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Row(

      children: [
        _buildIcon(),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTextContent(),
        ),
      ],
    );
  }

  Widget _buildIcon() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Transform.rotate(
            angle: (1 - value) * 0.5,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextContent() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset((1 - value) * 50, 0),
          child: Opacity(
            opacity: value,
            child: Column(
              crossAxisAlignment: Directionality.of(context) == TextDirection.rtl
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: titleStyle ?? TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: subtitleStyle ?? TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  ShapeBorder _defaultShape() {
    return const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
    );
  }
}

/// Extension to easily create common app bar configurations
extension CustomSliverAppBarExtensions on CustomSliverAppBar {
  /// Create app bar for profile page
  static CustomSliverAppBar profile({
    String title = 'الملف الشخصي',
    String? subtitle = 'إدارة حسابك وإعداداتك',
    List<Widget>? actions,
    bool showBackButton = false,
  }) {
    return CustomSliverAppBar(
      title: title,
      subtitle: subtitle,
      icon: Icons.person_rounded,
      actions: actions,
      showBackButton: showBackButton,
      gradientColors: const [Color(0xFF11998E), Color(0xFF38EF7D)],
    );
  }

  /// Create app bar for settings page
  static CustomSliverAppBar settings({
    String title = 'الإعدادات',
    String? subtitle = 'تخصيص التطبيق حسب احتياجاتك',
    List<Widget>? actions,
    bool showBackButton = true,
  }) {
    return CustomSliverAppBar(
      title: title,
      subtitle: subtitle,
      icon: Icons.settings_rounded,
      actions: actions,
      showBackButton: showBackButton,
      gradientColors: const [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    );
  }

  /// Create app bar for groups page
  static CustomSliverAppBar groups({
    String title = 'مجموعاتي',
    String? subtitle = 'إدارة وتنظيم مجموعاتك بسهولة',
    List<Widget>? actions,
    bool showBackButton = false,
  }) {

    return CustomSliverAppBar(
      expandedHeight: 105,
      title: title,
      subtitle: subtitle,
      icon: Icons.groups_rounded,
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.notification_add_rounded))
      ],
      showBackButton: showBackButton,
      // gradientColors: const [Color(0xFF667EEA), Color(0xFF764BA2)],
    );
  }

  /// Create app bar for transactions page
  static CustomSliverAppBar transactions({
    String title = 'المعاملات',
    String? subtitle = 'تتبع جميع معاملاتك المالية',
    List<Widget>? actions,
    bool showBackButton = false,
  }) {
    return CustomSliverAppBar(
      title: title,
      subtitle: subtitle,
      icon: Icons.receipt_long_rounded,
      actions: actions,
      showBackButton: showBackButton,
      gradientColors: const [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
    );
  }

  /// Create app bar for analytics page
  static CustomSliverAppBar analytics({
    String title = 'التحليلات',
    String? subtitle = 'تحليل مفصل لأنشطتك المالية',
    List<Widget>? actions,
    bool showBackButton = false,
  }) {
    return CustomSliverAppBar(
      title: title,
      subtitle: subtitle,
      icon: Icons.analytics_rounded,
      actions: actions,
      showBackButton: showBackButton,
      gradientColors: const [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
    );
  }
}