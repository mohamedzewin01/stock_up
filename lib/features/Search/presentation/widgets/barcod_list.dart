import 'package:flutter/material.dart';

class BarcodeList extends StatefulWidget {
  final List<dynamic> barcodes;

  const BarcodeList({super.key, required this.barcodes});

  @override
  State<BarcodeList> createState() => BarcodeListState();
}

class BarcodeListState extends State<BarcodeList> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final firstBarcode = widget.barcodes.first.toString();
    final hasMore = widget.barcodes.length > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // First Barcode with Visual Representation
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[50]!, Colors.grey[100]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!, width: 2),
          ),
          child: Column(
            children: [
              // Barcode Visual
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: Center(child: _buildBarcodeVisual(firstBarcode)),
              ),
              const SizedBox(height: 12),
              // Barcode Number
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4FACFE).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.tag_rounded,
                      size: 18,
                      color: Color(0xFF4FACFE),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      firstBarcode,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3436),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // More Barcodes Section
        if (hasMore) ...[
          const SizedBox(height: 16),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Column(
              children: [
                // Show More Button
                InkWell(
                  onTap: () {
                    setState(() {
                      _showAll = !_showAll;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF4FACFE).withOpacity(0.1),
                          const Color(0xFF00F2FE).withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF4FACFE).withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _showAll
                              ? Icons.expand_less_rounded
                              : Icons.expand_more_rounded,
                          color: const Color(0xFF4FACFE),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _showAll
                              ? 'إخفاء الباركودات الإضافية'
                              : 'عرض ${widget.barcodes.length - 1} باركود إضافي',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4FACFE),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Additional Barcodes List
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: _showAll
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Container(
                    margin: const EdgeInsets.only(top: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!, width: 1),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      itemCount: widget.barcodes.length - 1,
                      separatorBuilder: (context, index) =>
                          Divider(height: 20, color: Colors.grey[300]),
                      itemBuilder: (context, index) {
                        final barcode = widget.barcodes[index + 1].toString();
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey[300]!,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF4FACFE),
                                      Color(0xFF00F2FE),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${index + 2}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  barcode,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2D3436),
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.qr_code_rounded,
                                color: Colors.grey[400],
                                size: 20,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  secondChild: const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBarcodeVisual(String barcode) {
    // Create a visual representation of barcode using vertical bars
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(barcode.length > 13 ? 13 : barcode.length, (
        index,
      ) {
        final digit = int.tryParse(barcode[index]) ?? 0;
        final height = 40.0 + (digit * 2.0);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          width: 3,
          height: height,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2D3436), Color(0xFF636E72)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }
}
