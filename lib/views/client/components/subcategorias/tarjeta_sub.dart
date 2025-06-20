import 'package:app2025_final/models/producto_model.dart';
import 'package:app2025_final/providers/carrito_provider.dart';
import 'package:app2025_final/providers/detalleproducto_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Widget tarjeta_sub({
  required BuildContext context,
  // required String sub_nombre,
  required double alto,
  required double ancho,
  required double separacion_tarjeta,
  required double ima_alto,
  required double ima_ancho,
  required dynamic item,
  required double cajatextoalto,
  required double cajatextoancho,
}) {
  return Padding(
    padding: const EdgeInsets.all(1.0),
    child: Row(
      children: [
        Container(
          height: alto.h, //194.h,
          width: ancho.w, //128.w,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(
                  255,
                  202,
                  201,
                  201,
                ).withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
            //color: Color.fromRGBO(1, 37, 255, 1),
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 6.0.r, left: 14.r, right: 14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        //  Provider<ProductoGenerico>.context().llamarProducto(item.id);
                        Provider.of<DetalleProductoProvider>(
                          context,
                          listen: false,
                        ).cargar(item);
                        context.push('/detalle_producto');
                        //print("hola soy producto ${item.id}");
                      },
                      child: Container(
                        height: ima_alto.h,
                        width: ima_ancho.w,
                        decoration: BoxDecoration(
                          //color: Colors.white,
                          image: DecorationImage(
                            image: NetworkImage(item.fotos.first),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    item.descuento > 0
                        ? Positioned(
                          top: 0.h,
                          left: 2.0.w,
                          child: Container(
                            width: 50.w,
                            height: 25.h,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 245, 54),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: Color.fromRGBO(1, 37, 255, 1),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "-20%",
                                style: GoogleFonts.manrope(
                                  fontSize: 14.sp,
                                  color: Color.fromRGBO(1, 37, 255, 1),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )
                        : SizedBox.shrink(),
                  ],
                ),
                Container(width: 100.w, child: Divider(height: 2)),
                SizedBox(height: 7.h),

                // CAJA DE TEXTO
                Container(
                  height: cajatextoalto.h,
                  width: cajatextoancho.h,
                  // color: Colors.amber,
                  child: Column(
                    children: [
                      Text(
                        "${item.nombre}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item is ProductoModel
                            ? "${item.cantidad_unidad}und./ ${item.tipo_empaque}"
                            : "Promo",
                        style: GoogleFonts.manrope(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        item is ProductoModel
                            ? "${item.volumen_unidad} ${item.unidad_medidad}"
                            : "",
                        style: GoogleFonts.manrope(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 8.h),
                Container(
                  height: 24.h,
                  width: 108.w,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 237, 237, 237),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "S/. ${item.precio}",
                          style: GoogleFonts.manrope(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(1, 37, 255, 1),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              //print("hoal");
                              Provider.of<CarritoProvider>(
                                context,
                                listen: false,
                              ).agregarProducto(item);
                              Provider.of<CarritoProvider>(
                                context,
                                listen: false,
                              ).mostrarProducto(item);
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20.sp,
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
        ),
        SizedBox(width: separacion_tarjeta.w),
      ],
    ),
  );
}
