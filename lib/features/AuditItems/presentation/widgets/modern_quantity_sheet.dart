import 'package:flutter/material.dart';
import 'package:stock_up/features/AuditItems/presentation/widgets/quantity_input_field.dart';
import 'package:stock_up/features/AuditItems/presentation/widgets/quantity_sheet_actions.dart';
import 'package:stock_up/features/AuditItems/presentation/widgets/quantity_sheet_header.dart';

import '../../data/models/response/search_products_model.dart';
import 'notes_input_field.dart';

class ModernQuantitySheet extends StatefulWidget {
  final Results product;
  final Function(int quantity, String? notes) onConfirm;

  const ModernQuantitySheet({
    super.key,
    required this.product,
    required this.onConfirm,
  });

  @override
  State<ModernQuantitySheet> createState() => _ModernQuantitySheetState();
}

class _ModernQuantitySheetState extends State<ModernQuantitySheet> {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    quantityController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    final quantity = int.tryParse(quantityController.text);

    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('يرجى إدخال كمية صحيحة'),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await widget.onConfirm(
        quantity,
        notesController.text.isEmpty ? null : notesController.text,
      );
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  QuantitySheetHeader(product: widget.product),

                  const SizedBox(height: 32),

                  // Quantity Input
                  QuantityInputField(
                    controller: quantityController,
                    enabled: !isLoading,
                  ),

                  const SizedBox(height: 24),

                  // Notes Input
                  NotesInputField(
                    controller: notesController,
                    enabled: !isLoading,
                  ),

                  const SizedBox(height: 32),

                  // Action Buttons
                  QuantitySheetActions(
                    isLoading: isLoading,
                    onCancel: () => Navigator.pop(context),
                    onConfirm: _handleConfirm,
                  ),

                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
