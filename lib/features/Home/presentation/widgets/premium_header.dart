import 'package:flutter/material.dart';
import 'package:stock_up/core/resources/style_manager.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/Home/presentation/widgets/header_button.dart';
import 'package:stock_up/features/Home/presentation/widgets/user_profile_dialog.dart';

class PremiumHeader extends StatelessWidget {
  const PremiumHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              HeaderButton(
                icon: Icons.notifications_rounded,
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
                      backgroundColor: Color(0xFF9D4EDD),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              HeaderButton(
                icon: Icons.person_rounded,
                onPressed: () {
                  _showUserProfileDialog(context);
                },
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'مرحباً بك',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFFFFFFFF), Color(0xFFE0AAFF)],
                  ).createShader(bounds),
                  child: Text(
                    CacheService.getData(key: CacheKeys.userName),
                    style: getBoldStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
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
