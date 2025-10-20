import 'package:flutter/material.dart';

class CameraPlaceholder extends StatelessWidget {
  const CameraPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 60,
                color: Colors.white.withOpacity(0.5),
              ),
              // const SizedBox(height: 10),
              // Text(
              //   'الكاميرا متوقفة',
              //   style: TextStyle(
              //     color: Colors.white.withOpacity(0.7),
              //     fontSize: 10,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
