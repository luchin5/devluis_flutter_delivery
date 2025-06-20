import 'package:app2025_final/providers/categoria_inicio_provider.dart';
import 'package:app2025_final/providers/ubicacion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// CATEGORÍA
Widget categoria(BuildContext context, dynamic item) {
  final ubicacionProvider = Provider.of<UbicacionProvider>(
    context,
    listen: false,
  );

  if (ubicacionProvider.allubicaciones.isEmpty) {
    return SizedBox(); // o un mensaje de error temporal
  }

  final ubicacion = ubicacionProvider.allubicaciones.first;

  return Container(
    width: 80.w,
    height: 75.h,
    decoration: BoxDecoration(
      //color: const Color.fromARGB(255, 171, 167, 167),
      borderRadius: BorderRadius.circular(15.r),
    ),
    child: Column(
      children: [
        GestureDetector(
          onTap: () async {
            print("object******************");
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              },
            );

            try {
              final categoriaProvider = Provider.of<CategoriaInicioProvider>(
                context,
                listen: false,
              );
              categoriaProvider.setCategoriaSeleccionada(item.id);

              // Esperar a que cargue la categoría
              await categoriaProvider.getCategoriaSubcategoria(
                item.id,
                ubicacion.id!,
              );
            } catch (e) {
              print("Error cargando categoría: $e");
            } finally {
              // Cerrar el diálogo cuando termina la carga
              Navigator.of(context).pop();
            }
          },
          child: Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              //color: Colors.amber,
              image: DecorationImage(image: NetworkImage(item.icono)),
              borderRadius: BorderRadius.circular(50.r),
            ),
          ),
        ),
        Text(
          "${item.nombre}",
          style: GoogleFonts.manrope(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(1, 37, 255, 1),
          ),
        ),
      ],
    ),
  );
}
