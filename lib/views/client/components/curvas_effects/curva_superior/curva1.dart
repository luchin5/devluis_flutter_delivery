import 'dart:async';
import 'package:app2025_final/models/ubicacion_model.dart';
import 'package:app2025_final/providers/carrito_provider.dart';
import 'package:app2025_final/providers/ubicacion_provider.dart';
import 'package:app2025_final/views/client/components/curvas_effects/curva_superior/clipper1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Curva1 extends StatelessWidget {
  final int currentIndex;
  final String fondo;

  Curva1({super.key, required this.currentIndex, required this.fondo});

  Widget build(BuildContext context) {
    final carritoProvider = context.watch<CarritoProvider>();
    final ubicacionProvider = context.watch<UbicacionProvider>();

    UbicacionModel? direccionSeleccionada;

    if (ubicacionProvider.allubicaciones.isNotEmpty) {
      direccionSeleccionada = ubicacionProvider.allubicaciones.firstWhere(
        (u) => u.id == ubicacionProvider.idSeleccionado,
        orElse: () => ubicacionProvider.allubicaciones.first,
      );
    } else {
      direccionSeleccionada = null;
    }

    return ClipPath(
      clipper: MyCustomClipper(),
      child: Container(
        width: 524.w,
        height: 480.h,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 54, 67, 253),
          image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(fondo)),
        ),

        // STACKEANDO EL FONDO
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 45, left: 12.r, right: 16.r),
              child: Column(
                children: [
                  // BARRA DE ICONO + CARRITO
                  Container(
                    height: 50.h,
                    // color: Colors.grey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 45.w,
                          height: 45.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(
                              4.r,
                            ), // Ajusta el padding aquí
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.r),
                              child: Image.asset(
                                'lib/assets/imagenes/logo.png',
                                fit: BoxFit.contain, // O el fit que desees
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 45.w,
                          height: 45.w,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: badges.Badge(
                            position: badges.BadgePosition.topEnd(
                              top: -12,
                              end: -10,
                            ),
                            badgeContent: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                '${carritoProvider.totalItems}',
                                style: GoogleFonts.manrope(
                                  color: Color.fromRGBO(1, 37, 255, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            showBadge:
                                carritoProvider.totalItems > 0 ? true : false,
                            badgeStyle: badges.BadgeStyle(
                              borderRadius: BorderRadius.circular(4),
                              borderSide: BorderSide(
                                color: Color.fromRGBO(1, 37, 255, 1),
                                width: 2,
                              ),
                              badgeColor: const Color.fromARGB(
                                255,
                                255,
                                255,
                                255,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                context.push('/carrito');
                                print("Carrita");
                              },
                              icon: Icon(
                                Icons.shopping_bag_outlined,
                                size: 25.sp,
                                color: Color.fromRGBO(1, 37, 255, 1),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 65.h),
                ],
              ),
            ),

            // PUNTO DE ENTREGA ES FLOTANTE AHORA
            Positioned(
              top: 105.h,
              left: 12.w,
              child: Container(
                height: 50.h,
                width: 250.w,
                decoration: BoxDecoration(
                  // color: Colors.pink,
                  borderRadius: BorderRadius.circular(0.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Punto de entrega - ',
                                style: GoogleFonts.manrope(
                                  color: Colors.grey.shade100,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                              ),
                              TextSpan(
                                text:
                                    direccionSeleccionada?.etiqueta ??
                                    'ninguno',
                                style: GoogleFonts.manrope(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.white,
                          size: 15.sp,
                        ),
                      ],
                    ),
                    SizedBox(height: 0.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5.r),
                        child: Row(
                          children: [
                            Container(
                              width: 215.w,
                              child: Text(
                                direccionSeleccionada != null
                                    ? "${direccionSeleccionada!.direccion} ${direccionSeleccionada!.distrito}"
                                    : "No se ha seleccionado una dirección",
                                style: GoogleFonts.manrope(
                                  color: Colors.black,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.push('/listadirecciones');
                                print("clid direccion");
                              },
                              child: Icon(
                                Icons.arrow_drop_down_circle_outlined,
                                size: 20.sp,
                                color: Color.fromRGBO(1, 37, 255, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
