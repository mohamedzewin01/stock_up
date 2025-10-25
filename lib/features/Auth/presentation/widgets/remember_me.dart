// // import 'package:flutter/material.dart';
// // import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
// //
// // class RememberMe extends StatelessWidget {
// //   final bool value;
// //   final ValueChanged<bool> onChanged;
// //
// //   const RememberMe({super.key, required this.value, required this.onChanged});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       children: [
// //         SizedBox(
// //           width: 24,
// //           height: 24,
// //           child: Checkbox(
// //             value: value,
// //             onChanged: (newValue) {
// //               onChanged(newValue ?? false);
// //               CacheService.setData(key: CacheKeys.rememberMe, value: newValue);
// //             },
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(4),
// //             ),
// //             activeColor: Colors.blue[700],
// //           ),
// //         ),
// //         const SizedBox(width: 8),
// //         Text('تذكرني', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
// //       ],
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
//
// class RememberMe extends StatelessWidget {
//   final bool value;
//   final ValueChanged<bool> onChanged;
//
//   const RememberMe({super.key, required this.value, required this.onChanged});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         onChanged(!value);
//         CacheService.setData(key: CacheKeys.rememberMe, value: !value);
//       },
//       borderRadius: BorderRadius.circular(8),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 4),
//         child: Row(
//           children: [
//             AnimatedContainer(
//               duration: const Duration(milliseconds: 200),
//               width: 24,
//               height: 24,
//               decoration: BoxDecoration(
//                 gradient: value
//                     ? const LinearGradient(
//                         colors: [Color(0xFF667eea), Color(0xFF764ba2)],
//                       )
//                     : null,
//                 color: value ? null : Colors.grey[300],
//                 borderRadius: BorderRadius.circular(6),
//                 border: Border.all(
//                   color: value ? Colors.transparent : Colors.grey[400]!,
//                   width: 2,
//                 ),
//               ),
//               child: value
//                   ? const Icon(
//                       Icons.check_rounded,
//                       size: 16,
//                       color: Colors.white,
//                     )
//                   : null,
//             ),
//             const SizedBox(width: 10),
//             const Text(
//               'تذكرني',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Color(0xFF4A5568),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:stock_up/features/Auth/presentation/bloc/Auth_cubit.dart';

class RememberMe extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const RememberMe({super.key, required this.value, required this.onChanged});

  @override
  State<RememberMe> createState() => _RememberMeState();
}

class _RememberMeState extends State<RememberMe>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
      ),
    );

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(RememberMe oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    final newValue = !widget.value;
    widget.onChanged(newValue);
    AuthCubit.get(context).handleRememberMe(newValue);

    print(AuthCubit.get(context).rememberMe);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: widget.value
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF9D4EDD), Color(0xFF7B2CBF)],
                            )
                          : null,
                      color: widget.value ? null : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: widget.value
                            ? Colors.transparent
                            : Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                      boxShadow: widget.value
                          ? [
                              BoxShadow(
                                color: const Color(0xFF9D4EDD).withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: widget.value
                        ? Transform.scale(
                            scale: _checkAnimation.value,
                            child: Icon(
                              Icons.check_rounded,
                              size: 18,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            Text(
              'تذكرني',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white.withOpacity(0.85),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
