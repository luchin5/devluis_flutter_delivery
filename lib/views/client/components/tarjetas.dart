import 'package:app2025_final/models/ubicacion_model.dart';
import 'package:app2025_final/providers/categoria_inicio_provider.dart';
import 'package:app2025_final/providers/ubicacion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// TARJETAS
Widget tarjetas(dynamic novedad, BuildContext context) {
  String? imageUrl;

  if (novedad.promocion != null && novedad.promocion.fotos.isNotEmpty) {
    imageUrl = novedad.promocion.fotos.first;
  } else if (novedad.producto != null && novedad.producto.fotos.isNotEmpty) {
    imageUrl = novedad.producto.fotos.first;
  } else {
    imageUrl =
        'https://i.pinimg.com/736x/85/24/76/8524764d9aeb61b77974dc54004f2597.jpg'; // fallback si no hay imagen
  }
  return Row(
    children: [
      // EXTERNO
      Container(
        width: 293.w,
        height: 172.h,
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // INTERNO
            Container(
              width: 293.w,
              height: 135.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.grey,
                //color: const Color.fromRGBO(1, 37, 255, 1),
                /*boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3), // Color de la sombra
                    spreadRadius: 5, // Qué tan expandida está la sombra
                    blurRadius: 5, // Qué tan difuminada está la sombra
                    offset: Offset(0, 3), // Desplazamiento de la sombra (x, y)
                  ),
                ],*/
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // MENSAJE O DESCRIPCION
                  Container(
                    width: 138.w,
                    height: 135.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      // color: const Color.fromARGB(255, 67, 67, 126),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            novedad.titulo,
                            style: GoogleFonts.manrope(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ).animate().shake(
                            duration: 1.seconds,
                            curve: Curves.easeInOut,
                          ),
                          Container(
                            height: 40.h,
                            //color: Colors.grey,
                            child: Text(
                              novedad.descripcion,
                              style: GoogleFonts.manrope(
                                fontSize: 12.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                              softWrap:
                                  true, // Esto asegura que salte si necesita
                            ),
                          ),
                          Container(
                            width: 100.w, // o el que necesites
                            // height: 30.h,
                            child: Chip(
                              label: Center(
                                child: Text(
                                  novedad.categoria.nombre,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ),
                              backgroundColor: Colors.white,
                              shape: StadiumBorder(
                                side: BorderSide(
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      print("....entradon prodcuto");
                      print(
                        "....click en categoria ${novedad.categoria.id} ${novedad.categoria.nombre}",
                      );
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        },
                      );

                      final ubicacionProvider =
                          context.read<UbicacionProvider>();

                      final idSeleccionado = ubicacionProvider.idSeleccionado;

                      // Buscar el zonaTrabajoId de esa ubicación
                      UbicacionModel? ubicacionSeleccionada;
                      try {
                        ubicacionSeleccionada = ubicacionProvider.allubicaciones
                            .firstWhere((u) => u.id == idSeleccionado);
                      } catch (e) {
                        ubicacionSeleccionada = null;
                      }

                      final zonaTrabajoId =
                          ubicacionSeleccionada?.zonatrabajo_id;

                      final categoria = Provider.of<CategoriaInicioProvider>(
                        context,
                        listen: false,
                      );

                      categoria.setCategoriaSeleccionada(novedad.categoria.id);
                      categoria.setZonaTrabajoId(zonaTrabajoId);

                      Navigator.pop(context);
                      context.push('/allcategoria_sub');
                    },
                    child: Container(
                      width: 155.w,
                      height: 145.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imageUrl!),
                          // fit: BoxFit.contain,
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.r),
                          bottomRight: Radius.circular(20.r),
                          topLeft: Radius.circular(60.r),
                          bottomLeft: Radius.circular(60.r),
                        ),
                        color: Colors.white,
                      ),
                    ).animate().scale(
                      duration: 1.seconds,
                      begin: Offset(0.7, 0.7),
                      end: Offset(1.0, 1.0),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 11.h),
            Text(
              "* ${novedad.terminos}",
              style: GoogleFonts.manrope(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      SizedBox(width: 19.w),
    ],
  );
}
