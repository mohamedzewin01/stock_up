import 'package:flutter/material.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/splash_screen.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({
    super.key,
    required this.userName,
    required this.userRole,
  });

  final String userName;
  final String userRole;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Color(0xFF1A1A2E),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9D4EDD), Color(0xFF7B2CBF)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF9D4EDD).withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(Icons.person_rounded, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            userName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF9D4EDD).withOpacity(0.3),
                  Color(0xFF7B2CBF).withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Text(
              userRole,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              CacheService.clearItems();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SplashScreen()),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFD12B9D).withOpacity(0.3),
                    Color(0xFFBD0615).withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Text(
                'تسجيل خروج',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('إغلاق', style: TextStyle(color: Color(0xFF9D4EDD))),
        ),
      ],
    );
  }
}
