import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stock_up/core/resources/style_manager.dart';
import 'package:stock_up/core/utils/cashed_data_shared_preferences.dart';
import 'package:stock_up/features/Stores/data/models/response/all_stores_model.dart';

class StoreDropdown extends StatefulWidget {
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
  State<StoreDropdown> createState() => _StoreDropdownState();
}

class _StoreDropdownState extends State<StoreDropdown> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4, bottom: 10),
          child: Text(
            'اختر المتجر',
            style: getBoldStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF9D4EDD), Color(0xFF7B2CBF), Color(0xFF5A189A)],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.errorText != null
                        ? const Color(0xFFE63946).withOpacity(0.8)
                        : Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: DropdownButtonFormField<Results>(
                  value: _getValidSelectedStore(),
                  decoration: InputDecoration(
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(left: 12, right: 16),
                      child: Icon(
                        Icons.store_rounded,
                        color: widget.isEnabled
                            ? const Color(0xFF9D4EDD)
                            : Colors.white.withOpacity(0.4),
                        size: 22,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFF9D4EDD),
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: const Color(0xFFE63946).withOpacity(0.8),
                        width: 1.5,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Color(0xFFE63946),
                        width: 2,
                      ),
                    ),
                    errorText: widget.errorText,
                    errorStyle: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFFE63946).withOpacity(0.9),
                      height: 0.8,
                    ),
                  ),
                  hint: Text(
                    widget.stores.isEmpty
                        ? 'لا توجد متاجر متاحة'
                        : 'اختر المتجر',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  isExpanded: true,
                  icon: AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: widget.isEnabled
                          ? const Color(0xFF9D4EDD)
                          : Colors.white.withOpacity(0.4),
                      size: 28,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(16),
                  dropdownColor: const Color(0xFF1A1A2E),
                  elevation: 12,
                  menuMaxHeight: 300,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.95),
                    fontWeight: FontWeight.w600,
                  ),
                  selectedItemBuilder: (context) {
                    return widget.stores.map((store) {
                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              store.storeName ?? 'متجر بدون اسم',
                              style: getSemiBoldStyle(
                                fontSize: 15,
                                color: Color(0xFF9D4EDD).withOpacity(0.95),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  },
                  items: widget.stores.isEmpty
                      ? null
                      : widget.stores.map((Results store) {
                          return DropdownMenuItem<Results>(
                            value: store,
                            child: _buildStoreItem(store),
                          );
                        }).toList(),
                  onChanged: widget.isEnabled && widget.stores.isNotEmpty
                      ? (Results? newStore) {
                          if (newStore?.id != null) {
                            CacheService.setData(
                              key: CacheKeys.storeId,
                              value: newStore!.id,
                            );
                          }
                          widget.onChanged(newStore);
                        }
                      : null,
                  onTap: () {
                    setState(() {
                      _isExpanded = true;
                    });
                  },
                  validator: (value) {
                    if (!widget.isEnabled) return null;
                    if (widget.stores.isEmpty) {
                      return 'لا توجد متاجر متاحة';
                    }
                    if (value == null) {
                      return 'الرجاء اختيار المتجر';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Results? _getValidSelectedStore() {
    if (widget.selectedStore == null) return null;

    try {
      final storeExists = widget.stores.any(
        (store) => store.id == widget.selectedStore!.id,
      );
      return storeExists ? widget.selectedStore : null;
    } catch (e) {
      return null;
    }
  }

  Widget _buildStoreItem(Results store) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.05), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF9D4EDD), Color(0xFF7B2CBF)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9D4EDD).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                ),
                const Icon(Icons.store_rounded, color: Colors.white, size: 24),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  store.storeName ?? 'متجر بدون اسم',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withOpacity(0.95),
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (store.id != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF9D4EDD).withOpacity(0.3),
                          const Color(0xFF7B2CBF).withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Text(
                      'رقم: ${store.id}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.check_circle_rounded,
            color: widget.selectedStore?.id == store.id
                ? const Color(0xFF06FFA5)
                : Colors.transparent,
            size: 24,
          ),
        ],
      ),
    );
  }
}
