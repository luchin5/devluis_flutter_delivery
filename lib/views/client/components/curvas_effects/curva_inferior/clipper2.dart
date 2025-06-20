import 'package:flutter/material.dart';

class MyCustomClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Mover al punto inicial (esquina superior izquierda)
    path.moveTo(0, size.height * 0.4);

    // Curva en la parte superior izquierda
    path.quadraticBezierTo(
      size.width * 0.02,
      size.height * 0.25,
      size.width * 0.15,
      size.height * 0.25,
    );

    // Línea recta al otro lado antes de la curva derecha
    path.lineTo(size.width * 0.85, size.height * 0.25);

    // Curva en la parte superior derecha
    path.quadraticBezierTo(
      size.width * 0.98,
      size.height * 0.25,
      size.width,
      size.height * 0.0,
    );

    // Línea hasta la esquina inferior derecha
    path.lineTo(size.width, size.height);

    // Línea hasta la esquina inferior izquierda
    path.lineTo(0, size.height);

    // Cierra el path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
