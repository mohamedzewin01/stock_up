// // lib/features/Auth/presentation/widgets/store_dropdown.dart
//
// import 'package:flutter/material.dart';
// import 'package:stock_up/features/Stores/data/models/response/all_stores_model.dart';
//
// class StoreDropdown extends StatelessWidget {
//   final List<Results> stores;
//   final Results? selectedStore;
//   final Function(Results?) onChanged;
//   final String? errorText;
//   final bool isEnabled;
//
//   const StoreDropdown({
//     super.key,
//     required this.stores,
//     required this.selectedStore,
//     required this.onChanged,
//     this.errorText,
//     this.isEnabled = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'اختر المتجر',
//           style: TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF475569),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: isEnabled ? Colors.grey[50] : Colors.grey[100],
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: errorText != null ? Colors.red : Colors.grey[300]!,
//               width: 1,
//             ),
//           ),
//           child: DropdownButtonFormField<Results>(
//             value: _getValidSelectedStore(),
//             decoration: InputDecoration(
//               prefixIcon: Icon(
//                 Icons.store,
//                 color: isEnabled ? Colors.grey[600] : Colors.grey[400],
//                 size: 22,
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 16,
//               ),
//               border: InputBorder.none,
//               enabledBorder: InputBorder.none,
//               focusedBorder: InputBorder.none,
//               errorText: errorText,
//               errorStyle: const TextStyle(fontSize: 12, height: 0.8),
//             ),
//             hint: Text(
//               stores.isEmpty ? 'لا توجد متاجر متاحة' : 'اختر المتجر',
//               style: TextStyle(color: Colors.grey[400], fontSize: 14),
//             ),
//             isExpanded: true,
//             icon: Icon(
//               Icons.keyboard_arrow_down,
//               color: isEnabled ? Colors.grey[600] : Colors.grey[400],
//             ),
//             borderRadius: BorderRadius.circular(12),
//             dropdownColor: Colors.white,
//             style: const TextStyle(fontSize: 16, color: Color(0xFF1E293B)),
//             items: stores.isEmpty
//                 ? null
//                 : stores.map((Results store) {
//                     return DropdownMenuItem<Results>(
//                       value: store,
//                       child: _buildStoreItem(store),
//                     );
//                   }).toList(),
//             onChanged: isEnabled && stores.isNotEmpty ? onChanged : null,
//             validator: (value) {
//               if (!isEnabled) return null;
//               if (stores.isEmpty) {
//                 return 'لا توجد متاجر متاحة';
//               }
//               if (value == null) {
//                 return 'الرجاء اختيار المتجر';
//               }
//               return null;
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   // التحقق من أن المتجر المحدد موجود في القائمة
//   Results? _getValidSelectedStore() {
//     if (selectedStore == null) return null;
//
//     // التحقق من وجود المتجر المحدد في القائمة الحالية
//     try {
//       final storeExists = stores.any((store) => store.id == selectedStore!.id);
//       return storeExists ? selectedStore : null;
//     } catch (e) {
//       return null;
//     }
//   }
//
//   Widget _buildStoreItem(Results store) {
//     return Text(
//       store.storeName ?? 'متجر بدون اسم',
//       style: const TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.w500,
//         color: Color(0xFF1E293B),
//       ),
//       maxLines: 1,
//       overflow: TextOverflow.ellipsis,
//     );
//   }
// }
// lib/features/Auth/presentation/widgets/store_dropdown.dart

import 'package:flutter/material.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/Stores/data/models/response/all_stores_model.dart';

class StoreDropdown extends StatelessWidget {
  final List<Results> stores;
  final Results? selectedStore;
  final Function(Results?) onChanged;
  final String? errorText;
  final bool isEnabled;

  const StoreDropdown({
    super.key,
    required this.stores,
    required this.selectedStore,
    required this.onChanged,
    this.errorText,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اختر المتجر',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isEnabled ? Colors.grey[50] : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: DropdownButtonFormField<Results>(
            value: _getValidSelectedStore(),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.store,
                color: isEnabled ? Colors.grey[600] : Colors.grey[400],
                size: 22,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorText: errorText,
              errorStyle: const TextStyle(fontSize: 12, height: 0.8),
            ),
            hint: Text(
              stores.isEmpty ? 'لا توجد متاجر متاحة' : 'اختر المتجر',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: isEnabled ? Colors.grey[600] : Colors.grey[400],
            ),
            borderRadius: BorderRadius.circular(12),
            dropdownColor: Colors.white,
            style: const TextStyle(fontSize: 16, color: Color(0xFF1E293B)),
            items: stores.isEmpty
                ? null
                : stores.map((Results store) {
                    return DropdownMenuItem<Results>(
                      value: store,
                      child: _buildStoreItem(store),
                    );
                  }).toList(),
            onChanged: isEnabled && stores.isNotEmpty
                ? (Results? newStore) {
                    // حفظ storeId في CacheService
                    if (newStore?.id != null) {
                      CacheService.setData(
                        key: CacheKeys.storeId,
                        value: newStore!.id,
                      );
                    }
                    // استدعاء callback الأصلي
                    onChanged(newStore);
                  }
                : null,
            validator: (value) {
              if (!isEnabled) return null;
              if (stores.isEmpty) {
                return 'لا توجد متاجر متاحة';
              }
              if (value == null) {
                return 'الرجاء اختيار المتجر';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  // التحقق من أن المتجر المحدد موجود في القائمة
  Results? _getValidSelectedStore() {
    if (selectedStore == null) return null;

    // التحقق من وجود المتجر المحدد في القائمة الحالية
    try {
      final storeExists = stores.any((store) => store.id == selectedStore!.id);
      return storeExists ? selectedStore : null;
    } catch (e) {
      return null;
    }
  }

  Widget _buildStoreItem(Results store) {
    return Text(
      store.storeName ?? 'متجر بدون اسم',
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF1E293B),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
