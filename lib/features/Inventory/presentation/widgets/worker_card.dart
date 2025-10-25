import 'package:flutter/material.dart';
import 'package:stock_up/core/resources/color_manager.dart';

import '../../data/models/response/get_all_users_model.dart';
import 'info_chip.dart';

class WorkerCard extends StatelessWidget {
  final User user;
  final bool isSelected;
  final VoidCallback onTap;

  const WorkerCard({
    super.key,
    required this.user,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? ColorManager.purple2
              : ColorManager.purple2.withOpacity(0.2),
          width: isSelected ? 2.5 : 1.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: ColorManager.purple2.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? ColorManager.primaryGradient
                        : LinearGradient(
                            colors: [Colors.grey[200]!, Colors.grey[300]!],
                          ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: ColorManager.purple2.withOpacity(0.4),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      (user.firstName?[0] ?? 'ع').toUpperCase(),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.firstName ?? ''} ${user.lastName ?? ''}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 12,
                        runSpacing: 4,
                        children: [
                          if (user.role != null)
                            InfoChip(
                              icon: Icons.work_outline_rounded,
                              label: user.role!,
                            ),
                          if (user.phoneNumber != null)
                            InfoChip(
                              icon: Icons.phone_outlined,
                              label: user.phoneNumber!,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: isSelected ? 1.0 : 0.9,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [Color(0xFF26DE81), Color(0xFF20BF6B)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      border: isSelected
                          ? null
                          : Border.all(
                              color: ColorManager.purple2.withOpacity(0.3),
                              width: 2,
                            ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: ColorManager.success.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 24,
                          )
                        : null,
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
