import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({Key? key}) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  List<InvoiceProduct> products = [
    InvoiceProduct(
      id: '1',
      productName: 'حليب الصافي كامل الدسم',
      selectedUnit: ProductUnit(
        name: 'كرتونة 12 علبة',
        barcode: '6281007001235',
        price: 100.00,
      ),
      selectedQuantity: 2,
      availableUnits: [
        ProductUnit(name: 'علبة 1 لتر', barcode: '6281007001234', price: 8.50),
        ProductUnit(
          name: 'كرتونة 12 علبة',
          barcode: '6281007001235',
          price: 100.00,
        ),
        ProductUnit(
          name: 'كرتونة 24 علبة',
          barcode: '6281007001236',
          price: 190.00,
        ),
        ProductUnit(
          name: 'كرتونة 100 علبة',
          barcode: '6281057002597',
          price: 500.00,
        ),
      ],
      image: '🥛',
    ),
    InvoiceProduct(
      id: '2',
      productName: 'لبن الصافي قليل الدسم',
      selectedUnit: ProductUnit(
        name: 'كيس 500 مل',
        barcode: '6281007005678',
        price: 4.25,
      ),
      selectedQuantity: 5,
      availableUnits: [
        ProductUnit(name: 'كيس 500 مل', barcode: '6281007005678', price: 4.25),
        ProductUnit(name: 'علبة 1 لتر', barcode: '6281007005679', price: 7.50),
        ProductUnit(
          name: 'كرتونة 10 أكياس',
          barcode: '6281007005680',
          price: 40.00,
        ),
      ],
      image: '🥛',
    ),
  ];

  bool showScanner = false;
  String? expandedProductId;

  double get total => products.fold(
    0,
    (sum, item) => sum + (item.selectedQuantity * item.selectedUnit.price),
  );

  void updateQuantity(String id, int delta) {
    setState(() {
      final index = products.indexWhere((p) => p.id == id);
      if (index != -1) {
        products[index].selectedQuantity =
            (products[index].selectedQuantity + delta).clamp(0, 999);
      }
    });
  }

  void changeUnit(String productId, ProductUnit unit) {
    setState(() {
      final index = products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        products[index].selectedUnit = unit;
      }
      expandedProductId = null;
    });
  }

  void removeProduct(String id) {
    setState(() {
      products.removeWhere((p) => p.id == id);
    });
  }

  void scanBarcode() {
    setState(() {
      showScanner = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              if (showScanner) _buildScanner(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    ...products.map((product) => _buildProductCard(product)),
                    const SizedBox(height: 12),
                    _buildAddProductButton(),
                  ],
                ),
              ),
              _buildTotalSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'فاتورة جديدة',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2d3748),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                DateTime.now().toString().split(' ')[0],
                style: const TextStyle(fontSize: 14, color: Color(0xFF718096)),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: scanBarcode,
            icon: const Icon(Icons.camera_alt, size: 20),
            label: const Text(
              'مسح باركود',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667eea),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              shadowColor: const Color(0xFF667eea).withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF667eea), width: 2),
            ),
            child: MobileScanner(
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
                  if (barcode.rawValue != null) {
                    // Find product and unit by barcode
                    _handleBarcodeScanned(barcode.rawValue!);
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'ضع الباركود أمام الكاميرا للمسح',
            style: TextStyle(fontSize: 16, color: Color(0xFF4a5568)),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                showScanner = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  void _handleBarcodeScanned(String barcode) {
    // Search for product with this barcode
    for (var product in products) {
      for (var unit in product.availableUnits) {
        if (unit.barcode == barcode) {
          setState(() {
            // Check if product with this unit already exists
            final existingIndex = products.indexWhere(
              (p) =>
                  p.productName == product.productName &&
                  p.selectedUnit.barcode == barcode,
            );

            if (existingIndex != -1) {
              // Increment quantity
              products[existingIndex].selectedQuantity++;
            } else {
              // Check if same product exists with different unit
              final sameProductIndex = products.indexWhere(
                (p) => p.productName == product.productName,
              );

              if (sameProductIndex != -1) {
                // Change unit of existing product
                products[sameProductIndex].selectedUnit = unit;
                products[sameProductIndex].selectedQuantity++;
              }
            }

            showScanner = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم إضافة: ${product.productName} - ${unit.name}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }
      }
    }

    // Barcode not found
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('الباركود غير موجود: $barcode'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Widget _buildProductCard(InvoiceProduct product) {
    final isExpanded = expandedProductId == product.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667eea).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(product.image, style: const TextStyle(fontSize: 36)),
            ),
          ),
          const SizedBox(width: 15),
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name & Delete
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.productName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2d3748),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => removeProduct(product.id),
                      icon: const Icon(Icons.delete, color: Colors.red),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Unit Selector Button
                InkWell(
                  onTap: () {
                    setState(() {
                      expandedProductId = isExpanded ? null : product.id;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.inventory_2,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              product.selectedUnit.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              '${product.selectedUnit.price.toStringAsFixed(2)} ريال',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Units Dropdown
                if (isExpanded) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFf7fafc),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFe2e8f0),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: product.availableUnits.map((unit) {
                        final isSelected =
                            unit.barcode == product.selectedUnit.barcode;

                        return InkWell(
                          onTap: () => changeUnit(product.id, unit),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF667eea).withOpacity(0.1)
                                  : Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF667eea)
                                    : const Color(0xFFe2e8f0),
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      unit.name,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF2d3748),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.tag,
                                          size: 12,
                                          color: Color(0xFF718096),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          unit.barcode,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF718096),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  '${unit.price.toStringAsFixed(2)} ريال',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF667eea),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],

                const SizedBox(height: 12),

                // Selected Barcode Display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFf7fafc),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.tag, size: 14, color: Color(0xFF4a5568)),
                      const SizedBox(width: 6),
                      const Text(
                        'الباركود:',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4a5568),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        product.selectedUnit.barcode,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4a5568),
                          fontFamily: 'monospace',
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFe2e8f0)),
                const SizedBox(height: 12),

                // Quantity & Total Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quantity Controls
                    Row(
                      children: [
                        _buildQuantityButton(
                          icon: Icons.remove,
                          onPressed: () => updateQuantity(product.id, -1),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 60,
                          child: Text(
                            '${product.selectedQuantity}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2d3748),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildQuantityButton(
                          icon: Icons.add,
                          onPressed: () => updateQuantity(product.id, 1),
                        ),
                      ],
                    ),
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${product.selectedUnit.price.toStringAsFixed(2)} ريال × ${product.selectedQuantity}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF718096),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(product.selectedUnit.price * product.selectedQuantity).toStringAsFixed(2)} ريال',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF667eea),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF667eea), width: 2),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: const Color(0xFF667eea)),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildAddProductButton() {
    return InkWell(
      onTap: () {
        // Add new product logic
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              'إضافة منتج',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTotalRow('عدد الأصناف:', '${products.length}'),
          const Divider(height: 24, color: Color(0xFFe2e8f0)),
          _buildTotalRow(
            'إجمالي الوحدات:',
            '${products.fold<int>(0, (sum, p) => sum + p.selectedQuantity)}',
          ),
          const Divider(height: 24, color: Color(0xFFe2e8f0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الإجمالي:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2d3748),
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ).createShader(bounds),
                child: Text(
                  '${total.toStringAsFixed(2)} ريال',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم إتمام الفاتورة بنجاح!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              shadowColor: Colors.green.withOpacity(0.4),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, size: 24),
                SizedBox(width: 8),
                Text(
                  'إتمام الفاتورة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Color(0xFF718096)),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2d3748),
          ),
        ),
      ],
    );
  }
}

// Models
class InvoiceProduct {
  final String id;
  final String productName;
  ProductUnit selectedUnit;
  int selectedQuantity;
  final List<ProductUnit> availableUnits;
  final String image;

  InvoiceProduct({
    required this.id,
    required this.productName,
    required this.selectedUnit,
    required this.selectedQuantity,
    required this.availableUnits,
    required this.image,
  });
}

class ProductUnit {
  final String name;
  final String barcode;
  final double price;

  ProductUnit({required this.name, required this.barcode, required this.price});
}
