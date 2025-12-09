import 'package:flutter/material.dart';
import 'package:stock_up/core/resources/style_manager.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/Home/presentation/widgets/profile_dialog.dart';
// import 'package:stock_up/features/Home/presentation/widgets/user_profile_dialog.dart';

class ClassicHeader extends StatelessWidget {
  const ClassicHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'مرحباً بك،',
                  style: getRegularStyle(
                    color: const Color(0xFF64748B),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  CacheService.getData(key: CacheKeys.userName) ?? 'المستخدم',
                  style: getBoldStyle(
                    color: const Color(0xFF1E293B),
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Action buttons
          Row(
            children: [
              _buildActionButton(
                context,
                icon: Icons.notifications_outlined,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.white),
                          const SizedBox(width: 12),
                          Text('لا توجد إشعارات جديدة'),
                        ],
                      ),
                      backgroundColor: const Color(0xFF6366F1),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                context,
                icon: Icons.person_outline_rounded,
                onPressed: () {
                  _showUserProfileDialog(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: IconButton(
        icon: Icon(icon, size: 22),
        color: const Color(0xFF475569),
        onPressed: onPressed,
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      ),
    );
  }

  void _showUserProfileDialog(BuildContext context) {
    final userName =
        CacheService.getData(key: CacheKeys.userName) ?? 'المستخدم';
    final userRole = CacheService.getData(key: CacheKeys.userRole) ?? 'موظف';

    showDialog(
      context: context,
      builder: (context) =>
          ProfileDialog(userName: userName, userRole: userRole),
    );
  }
}
