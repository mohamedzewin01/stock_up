import 'package:flutter/material.dart';
import 'package:stock_up/core/resources/style_manager.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/Home/presentation/widgets/profile_dialog.dart';

class DashboardHeaderSection extends StatelessWidget {
  const DashboardHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width < 600) {
          // Mobile: Compact vertical layout
          return _buildMobileHeader(context);
        } else {
          // Tablet & Desktop: Full horizontal layout
          return _buildDesktopHeader(context);
        }
      },
    );
  }

  // Mobile Header - Compact
  Widget _buildMobileHeader(BuildContext context) {
    final userName =
        CacheService.getData(key: CacheKeys.userName) ?? 'المستخدم';
    final storeName = CacheService.getData(key: CacheKeys.storeName);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row: User Info + Actions
          Row(
            children: [
              // User Avatar
              GestureDetector(
                onTap: () => _showProfileDialog(context),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 26,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // User Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'مرحباً،',
                        style: getRegularStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        userName,
                        style: getBoldStyle(color: Colors.white, fontSize: 18),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),

              // Notification Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: Stack(
                    children: [
                      const Icon(
                        Icons.notifications_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () => _showNotificationSnackBar(context),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Store Name Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.store_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    storeName,
                    style: getSemiBoldStyle(color: Colors.white, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Desktop/Tablet Header - Full
  Widget _buildDesktopHeader(BuildContext context) {
    final userName =
        CacheService.getData(key: CacheKeys.userName) ?? 'المستخدم';
    final storeName = CacheService.getData(key: CacheKeys.storeName);

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFA855F7)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row: Avatar + Actions
          Row(
            children: [
              // User Avatar
              GestureDetector(
                onTap: () => _showProfileDialog(context),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'مرحباً بعودتك،',
                      style: getRegularStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userName,
                      style: getBoldStyle(color: Colors.white, fontSize: 22),
                    ),
                  ],
                ),
              ),

              // Notification Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: Stack(
                    children: [
                      const Icon(
                        Icons.notifications_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEF4444),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () => _showNotificationSnackBar(context),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Store Name Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.store_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Text(
                  storeName,
                  style: getSemiBoldStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileDialog(BuildContext context) {
    final userName =
        CacheService.getData(key: CacheKeys.userName) ?? 'المستخدم';
    final userRole = CacheService.getData(key: CacheKeys.userRole) ?? 'موظف';

    showDialog(
      context: context,
      builder: (context) =>
          ProfileDialog(userName: userName, userRole: userRole),
    );
  }

  void _showNotificationSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 12),
            const Text('قيد التطوير'),
          ],
        ),
        backgroundColor: const Color(0xFF6366F1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
