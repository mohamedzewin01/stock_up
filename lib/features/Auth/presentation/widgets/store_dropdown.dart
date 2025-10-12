import 'package:flutter/material.dart';
import 'package:stock_up/features/Stores/data/models/response/all_stores_model.dart';

class StoreDropdown extends StatelessWidget {
  final List<Results> stores;
  final Results? selectedStore;
  final Function(Results?) onChanged;

  const StoreDropdown({
    super.key,
    required this.stores,
    required this.selectedStore,
    required this.onChanged,
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
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: DropdownButtonFormField<Results>(
            value: selectedStore,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.store, color: Colors.grey[600], size: 22),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            hint: Text(
              'اختر المتجر',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
            borderRadius: BorderRadius.circular(12),
            dropdownColor: Colors.white,
            style: const TextStyle(fontSize: 16, color: Color(0xFF1E293B)),
            items: stores.map((Results store) {
              return DropdownMenuItem<Results>(
                value: store,
                child: _buildStoreItem(store),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (value) {
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

  Widget _buildStoreItem(Results store) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          store.storeName ?? '',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        if (store.storeLocation != null && store.storeLocation!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  store.storeLocation!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
