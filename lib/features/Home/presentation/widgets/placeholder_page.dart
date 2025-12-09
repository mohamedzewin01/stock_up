import 'package:flutter/material.dart';
import 'package:stock_up/core/resources/style_manager.dart';

class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _buildAppBar(context),

            // Content
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIconContainer(),
                      const SizedBox(height: 32),
                      _buildTitle(),
                      const SizedBox(height: 16),
                      _buildSubtitle(),
                      const SizedBox(height: 48),
                      // _buildFeaturesList(),
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

  Widget _buildAppBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6366F1).withOpacity(0.2),
                  const Color(0xFF8B5CF6).withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
              padding: const EdgeInsets.all(8),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: getBoldStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.5),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: const Icon(
        Icons.construction_rounded,
        size: 60,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFFFFFFFF), Color(0xFFE0AAFF)],
      ).createShader(bounds),
      child: Text(
        'صفحة $title',
        style: getBoldStyle(color: Colors.white, fontSize: 32),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFBBF24).withOpacity(0.2),
            const Color(0xFFF59E0B).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFFFBBF24).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: const Color(0xFFFBBF24),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFBBF24).withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'قيد التطوير او ليس لديك صلاحية وصول ',
            style: getMediumStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildFeaturesList() {
  //   return Container(
  //     padding: const EdgeInsets.all(28),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFF1E293B),
  //       borderRadius: BorderRadius.circular(24),
  //       border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
  //     ),
  //     child: Column(
  //       children: [
  //         Text(
  //           'قريباً',
  //           style: getBoldStyle(color: Colors.white, fontSize: 22),
  //         ),
  //         const SizedBox(height: 24),
  //         _buildFeatureItem(
  //           icon: Icons.rocket_launch_rounded,
  //           text: 'مميزات جديدة',
  //           color: const Color(0xFF6366F1),
  //         ),
  //         const SizedBox(height: 16),
  //         _buildFeatureItem(
  //           icon: Icons.speed_rounded,
  //           text: 'أداء محسّن',
  //           color: const Color(0xFF10B981),
  //         ),
  //         const SizedBox(height: 16),
  //         _buildFeatureItem(
  //           icon: Icons.security_rounded,
  //           text: 'أمان متقدم',
  //           color: const Color(0xFFF59E0B),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFeatureItem({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        const SizedBox(width: 16),
        Text(
          text,
          style: getMediumStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.85),
          ),
        ),
      ],
    );
  }
}
