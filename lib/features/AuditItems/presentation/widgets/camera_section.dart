import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stock_up/features/AuditItems/presentation/widgets/camera_control_button.dart';
import 'package:stock_up/features/AuditItems/presentation/widgets/camera_placeholder.dart';

class CameraSection extends StatelessWidget {
  final MobileScannerController cameraController;
  final bool isCameraExpanded;
  final bool isCameraActive;
  final bool isFlashOn;
  final Function(BarcodeCapture) onBarcodeDetected;
  final VoidCallback onToggleCamera;
  final VoidCallback onToggleFlash;
  final VoidCallback onToggleExpand;

  const CameraSection({
    super.key,
    required this.cameraController,
    required this.isCameraExpanded,
    required this.isCameraActive,
    required this.isFlashOn,
    required this.onBarcodeDetected,
    required this.onToggleCamera,
    required this.onToggleFlash,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isCameraExpanded
          ? MediaQuery.of(context).size.height * 0.5
          : isCameraActive
          ? MediaQuery.of(context).size.height * 0.25
          : MediaQuery.of(context).size.height * 0.1,
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Camera View or Placeholder
            if (isCameraActive)
              MobileScanner(
                controller: cameraController,
                onDetect: onBarcodeDetected,
              )
            else
              const CameraPlaceholder(),

            // Scanner Frame
            if (isCameraActive)
              Center(
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

            // Top Controls Row
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Flash Button
                  CameraControlButton(
                    icon: isFlashOn ? Icons.flash_on : Icons.flash_off,
                    isActive: isFlashOn,
                    onTap: isCameraActive ? onToggleFlash : null,
                    tooltip: isFlashOn ? 'إطفاء الفلاش' : 'تشغيل الفلاش',
                  ),

                  // Expand Button
                  CameraControlButton(
                    icon: isCameraExpanded
                        ? Icons.fullscreen_exit
                        : Icons.fullscreen,
                    isActive: isCameraExpanded,
                    onTap: onToggleExpand,
                    tooltip: isCameraExpanded
                        ? 'تصغير الكاميرا'
                        : 'تكبير الكاميرا',
                  ),
                ],
              ),
            ),

            // Bottom Left - Camera Toggle Button
            Positioned(
              bottom: 16,
              left: 12,
              child: CameraControlButton(
                icon: isCameraActive ? Icons.videocam : Icons.videocam_off,
                isActive: isCameraActive,
                onTap: onToggleCamera,
                tooltip: isCameraActive ? 'إيقاف الكاميرا' : 'تشغيل الكاميرا',
              ),
            ),

            // Bottom Center - Instruction Text
            Positioned(
              bottom: 16,
              left: 80,
              right: 80,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isCameraActive
                        ? 'وجه الكاميرا نحو الباركود'
                        : 'قم بتشغيل الكاميرا للمسح',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
