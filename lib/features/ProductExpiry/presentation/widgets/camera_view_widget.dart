// lib/features/DateScanner/presentation/widgets/camera_view_widget.dart

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraViewWidget extends StatelessWidget {
  final CameraController controller;

  const CameraViewWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: controller.value.previewSize!.height,
          height: controller.value.previewSize!.width,
          child: CameraPreview(controller),
        ),
      ),
    );
  }
}
