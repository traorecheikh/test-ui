import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../controllers/join_scanner_controller.dart';

class JoinScannerScreen extends GetView<JoinScannerController> {
  const JoinScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Obx(() {
        if (!controller.permissionChecked.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!controller.cameraGranted.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  size: 64,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Camera permission denied. Please enable it in settings.',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: controller.checkCameraPermission,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return Stack(
          children: [
            MobileScanner(
              controller: controller.scannerController,
              onDetect: controller.onDetect,
              fit: BoxFit.cover,
              overlayBuilder: (context, constraints) {
                final scanSize = MediaQuery.of(context).size.width * 0.7;
                final centerX = constraints.maxWidth / 2;
                final centerY = constraints.maxHeight / 2;
                final scanRect = Rect.fromCenter(
                  center: Offset(centerX, centerY),
                  width: scanSize,
                  height: scanSize,
                );
                return Stack(
                  children: [
                    // White overlay outside the scan area, with rounded corners
                    CustomPaint(
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                      painter: _WhiteOutsideOverlayPainter(
                        scanRect: scanRect,
                        borderRadius: 32,
                      ),
                    ),
                    // App color corners for the scan area
                    Positioned(
                      left: scanRect.left,
                      top: scanRect.top,
                      child: SizedBox(
                        width: scanRect.width,
                        height: scanRect.height,
                        child: CustomPaint(
                          painter: _CornerArcPainter(
                            color: theme.colorScheme.primary,
                            radius: 32,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              top: 32,
              left: 20,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
                onPressed: () => Get.back(),
                tooltip: 'Retour',
              ),
            ),
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Scannez le QR code pour rejoindre',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: OutlinedButton.icon(
                          onPressed: () => Get.toNamed('/join'),
                          icon: Icon(
                            Icons.keyboard,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          label: Text(
                            'Entrer le code manuellement',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.95),
                            side: BorderSide(
                              color: theme.colorScheme.primary,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _WhiteOutsideOverlayPainter extends CustomPainter {
  final Rect scanRect;
  final double borderRadius;
  _WhiteOutsideOverlayPainter({
    required this.scanRect,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.85)
      ..style = PaintingStyle.fill;
    final screenRect = Offset.zero & size;
    // Draw white overlay outside scan area
    canvas.saveLayer(screenRect, Paint());
    canvas.drawRect(screenRect, paint);
    // Cut out the scan area with rounded corners
    final rrect = RRect.fromRectAndRadius(
      scanRect,
      Radius.circular(borderRadius),
    );
    canvas.drawRRect(rrect, Paint()..blendMode = BlendMode.clear);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CornerArcPainter extends CustomPainter {
  final Color color;
  final double radius;
  _CornerArcPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;
    final r = radius;
    // Top-left
    canvas.drawArc(Rect.fromLTWH(0, 0, r * 2, r * 2), 3.14, 1.57, false, paint);
    // Top-right
    canvas.drawArc(
      Rect.fromLTWH(size.width - r * 2, 0, r * 2, r * 2),
      4.71,
      1.57,
      false,
      paint,
    );
    // Bottom-left
    canvas.drawArc(
      Rect.fromLTWH(0, size.height - r * 2, r * 2, r * 2),
      1.57,
      1.57,
      false,
      paint,
    );
    // Bottom-right
    canvas.drawArc(
      Rect.fromLTWH(size.width - r * 2, size.height - r * 2, r * 2, r * 2),
      0,
      1.57,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
