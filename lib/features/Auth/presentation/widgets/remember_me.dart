// import 'package:flutter/material.dart';
//
// class RememberMe extends StatelessWidget {
//   const RememberMe({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         SizedBox(
//           width: 24,
//           height: 24,
//           child: Checkbox(
//             value: _rememberMe,
//             onChanged: (value) {
//               setState(() {
//                 _rememberMe = value ?? false;
//               });
//             },
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(4),
//             ),
//             activeColor: Colors.blue[700],
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text('تذكرني', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
//       ],
//     );
//   }
// }
