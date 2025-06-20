import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Mover al punto inicial (esquina superior izquierda)
    path.moveTo(0, 0);

    // Línea hasta la esquina inferior izquierda
    path.lineTo(0, size.height - 30.h);

    // Curva en la parte inferior el 2do x2 es el ancho de la curva, que se divide en la mitad de la pantalla
    path.quadraticBezierTo(
        size.width * 0.02,
        size.height * 0.75, // punto 3
        size.width * 0.15,
        size.height * 0.75); //punto 4

    //path.lineTo(size.width * 0.15, size.height * 0.75);

    path.lineTo(size.width * 0.85, size.height * 0.75);
    // Curva en la parte inferior derecha , ( los anchos no se mueven)
    path.quadraticBezierTo(
        size.width * 0.98, size.height * 0.75, size.width, size.height * 0.6);

    // Línea recta hasta la esquina superior derecha
    path.lineTo(size.width, 0);

    // Cierra el path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
