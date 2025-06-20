import 'package:flutter/material.dart';
import 'dart:math';

class WavySun extends StatelessWidget {
  final Size size;
  //const WavySun({super.key});
  const WavySun({super.key, required this.size});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      //size: const Size(100, 100), // tamaño del canvas
      painter: WavyCirclePainter(),
    );
  }
}

class WavyCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final Paint fillPaint = Paint()
      ..color = Colors.yellow // Color del relleno
      ..style = PaintingStyle.fill; // Estilo de relleno

    final Path path = Path();

    final int waves = 15; // cantidad de ondas
    final double radius = size.width / 2.5;
    final Offset center = Offset(size.width / 2, size.height / 2);

    for (double i = 0; i <= 2 * pi; i += (2 * pi / 100)) {
      final double wave = sin(i * waves) * 2.5; // profundidad de la onda
      final double x = center.dx + (radius + wave) * cos(i);
      final double y = center.dy + (radius + wave) * sin(i);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
