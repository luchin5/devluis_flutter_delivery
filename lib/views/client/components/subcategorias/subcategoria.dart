import 'package:app2025_final/models/subcategoria_model.dart';
import 'package:app2025_final/views/client/components/subcategorias/tarjeta_sub.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget subcategoria(SubcategoriaModel subcategoria) {
  // print(".....dentro de sub para tarjeta ${subcategoria.productos.length}");

  return Container(
    height: 444.h,
    // color: const Color.fromARGB(255, 191, 34, 34),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (subcategoria.productos.isNotEmpty)
          Container(
            height: 222.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: subcategoria.productos.length,
              itemBuilder: (context, index) {
                final producto = subcategoria.productos[index];
                return tarjeta_sub(
                  context: context,
                  // sub_nombre: subcategoria.nombre,
                  alto: 222,
                  ancho: 150,
                  separacion_tarjeta: 19,
                  ima_alto: 100,
                  ima_ancho: 100,
                  //nombre:sub
                  item: producto,
                  cajatextoalto: 65,
                  cajatextoancho: 100,
                );
                //return tarjeta_sub(context , 194, 133, 19, 100, 100, producto);
              },
            ),
          ),
        if (subcategoria.promociones.isNotEmpty)
          Container(
            height: 222.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: subcategoria.promociones.length,
              itemBuilder: (context, index) {
                final promo = subcategoria.promociones[index];
                return tarjeta_sub(
                  context: context,
                  //sub_nombre: subcategoria.nombre,
                  alto: 222,
                  ancho: 150,
                  separacion_tarjeta: 19,
                  ima_alto: 100,
                  ima_ancho: 100,
                  item: promo,
                  cajatextoalto: 65,
                  cajatextoancho: 100,
                );
                // return tarjeta_sub(context:context, 194, 133, 19, 100, 100, promo);
              },
            ),
          ),
      ],
    ),
  );
}
