import 'package:flutter/material.dart';
import 'package:stock_up/core/resources/color_manager.dart';
import 'package:stock_up/features/Inventory/presentation/pages/select_workers_page.dart';

class InventoryDetailPage extends StatefulWidget {
  final int inventoryId;
  final dynamic inventory;

  const InventoryDetailPage({
    super.key,
    required this.inventoryId,
    required this.inventory,
  });

  @override
  State<InventoryDetailPage> createState() => _InventoryDetailPageState();
}

class _InventoryDetailPageState extends State<InventoryDetailPage> {
  late dynamic _inventory;

  @override
  void initState() {
    super.initState();
    _inventory = widget.inventory;
  }

  @override
  Widget build(BuildContext context) {
    final workers = (_inventory.workers as List?) ?? [];

    return Scaffold(
      backgroundColor: ColorManager.lightBackground,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInventoryHeader(),
            const SizedBox(height: 20),
            _buildInfoCard(),
            const SizedBox(height: 20),
            _buildWorkersSection(workers),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: ColorManager.cardGradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: ColorManager.purple2.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: ColorManager.purple2),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: ShaderMask(
        shaderCallback: (bounds) =>
            ColorManager.primaryGradient.createShader(bounds),
        child: Text(
          'جرد #${widget.inventoryId}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildInventoryHeader() {
    final statusColor = _getStatusColor(_inventory.status ?? 'pending');
    final statusText = _getStatusText(_inventory.status ?? 'pending');

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: ColorManager.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ColorManager.purple2.withOpacity(0.5),
            blurRadius: 40,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.inventory_2_rounded,
              size: 56,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'جرد المخزون #${widget.inventoryId}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Text(
              statusText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: ColorManager.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: ColorManager.cardGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: ColorManager.purple2,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              ShaderMask(
                shaderCallback: (bounds) =>
                    ColorManager.primaryGradient.createShader(bounds),
                child: const Text(
                  'معلومات الجرد',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            Icons.calendar_today_rounded,
            'تاريخ الإنشاء',
            _inventory.auditDate ?? 'غير محدد',
          ),
          if (_inventory.notes != null && _inventory.notes!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoRow(
              Icons.note_alt_outlined,
              'الملاحظات',
              _inventory.notes!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: ColorManager.cardGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: ColorManager.purple2),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: ColorManager.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkersSection(List workers) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: ColorManager.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: ColorManager.cardGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.people_rounded,
                  color: ColorManager.purple2,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ShaderMask(
                  shaderCallback: (bounds) =>
                      ColorManager.primaryGradient.createShader(bounds),
                  child: const Text(
                    'العمال المشاركون',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: ColorManager.primaryGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.purple2.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SelectWorkersPage(auditId: widget.inventoryId),
                        ),
                      );

                      if (result == true) {
                        Navigator.pop(context, true);
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'إضافة',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (workers.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: ColorManager.cardGradient,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: ColorManager.purple2.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.person_add_outlined,
                      size: 48,
                      color: ColorManager.purple2,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'لم يتم إضافة عمال بعد',
                      style: TextStyle(
                        fontSize: 15,
                        color: ColorManager.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: workers.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final worker = workers[index];
                return _buildWorkerCard(worker);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildWorkerCard(dynamic worker) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: ColorManager.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorManager.purple2.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: ColorManager.primaryGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.purple2.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                (worker.firstName?[0] ?? 'ع').toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${worker.firstName ?? ''} ${worker.lastName ?? ''}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (worker.role != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorManager.purple2.withOpacity(0.2),
                          ColorManager.purple3.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      worker.role!,
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorManager.purple2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorManager.success.withOpacity(0.2),
                  ColorManager.success.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: ColorManager.success,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return ColorManager.success;
      case 'in_progress':
        return ColorManager.warning;
      case 'pending':
      default:
        return ColorManager.purple2;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'مكتمل';
      case 'in_progress':
        return 'جاري التنفيذ';
      case 'pending':
      default:
        return 'قيد الانتظار';
    }
  }
}
