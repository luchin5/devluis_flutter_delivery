import 'dart:math';

import 'package:app2025_final/providers/pedido_provider.dart';
import 'package:app2025_final/views/client/components/pedidos/timeline.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

final estados = [
  {'label': 'Pendiente', 'icon': Icons.hourglass_empty, 'color': Colors.grey},
  {'label': 'En proceso', 'icon': Icons.local_shipping, 'color': Colors.orange},
  {'label': 'Entregado', 'icon': Icons.check_circle, 'color': Colors.green},
];

Widget pedido(BuildContext context, dynamic item) {
  final historial = context.watch<PedidoProvider>();
  return Column(
    children: [
      Container(
        height: 380.h,
        width: 360.w,
        decoration: BoxDecoration(
          //color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          children: [
            // NÚMERO Y ESTADO
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pedido N°${item.id}",
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Chip(
                      // shadowColor: Colors.amber,
                      label: Text(
                        "${item.estado}",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: Color.fromRGBO(1, 37, 255, 1),
                        ),
                      ),
                      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15.h),

            // FECHA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "F-H: ${item.fecha}",
                        style: GoogleFonts.manrope(fontSize: 14.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            // DIRECCIÓN
            Container(
              // color: Colors.white,
              child: Row(
                children: [
                  Text(
                    "Dirección: ",
                    style: GoogleFonts.manrope(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Container(
                    //color: Colors.green,
                    width: 280.5.w,
                    child: Text(
                      "${item.direccion}",
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.manrope(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // CONTENIDO DEL PEDIDO
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Resumen",
                    style: GoogleFonts.manrope(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 50.w,
                        width: 145.w,
                        // color: Colors.amber,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: item.fotos.length,
                          itemBuilder: (context, index) {
                            final fotoactual = item.fotos[index];

                            return Container(
                              height: 50.w,
                              width: 50.w,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 185, 185, 185),
                                borderRadius: BorderRadius.circular(50.r),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(fotoactual),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Text(
                        "S/.${item.total}",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w500,
                          fontSize: 20.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // TIMELINE ESTADO PEDIDO
            Container(
              padding: EdgeInsets.only(left: 0.r, right: 0.r),
              width: 360.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 240, 255, 236),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color:
                          item.estado == 'pendiente'
                              ? Colors.yellowAccent
                              : Colors.white,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Icon(
                      Icons.timer_outlined,
                      color: const Color.fromRGBO(1, 37, 255, 1),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [...List.generate(9, (index) => timeline())],
                    ),
                  ),
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color:
                          item.estado == 'en proceso'
                              ? Colors.yellowAccent
                              : Colors.white,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Icon(
                      Icons.delivery_dining,
                      color: const Color.fromRGBO(1, 37, 255, 1),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [...List.generate(9, (index) => timeline())],
                    ),
                  ),
                  Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color:
                          item.estado == 'entregado'
                              ? Colors.yellowAccent
                              : Colors.white,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Icon(
                      Icons.check,
                      color: const Color.fromRGBO(1, 37, 255, 1),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),

            // BOTÓN DE PEDIDO ANULAR
            Container(
              width: 1.sw,
              child: ElevatedButton(
                onPressed:
                    (item.estado != 'entregado' && item.estado != 'anulado')
                        ? () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Container(
                                  height: 1.sh / 2.5,
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 120.w,
                                          width: 120.w,
                                          child: Icon(
                                            Icons.cancel_outlined,
                                            color: Colors.red,
                                            size: 120.sp,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          "¿Deseas anular el pedido?",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.manrope(
                                            color: Color.fromRGBO(
                                              1,
                                              37,
                                              255,
                                              1,
                                            ),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20.sp,
                                          ),
                                        ),
                                        SizedBox(height: 20.h),
                                        SizedBox(height: 30.h),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            side: BorderSide(
                                              color: Color.fromRGBO(
                                                1,
                                                37,
                                                255,
                                                1,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            "Continuar",
                                            style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(
                                                1,
                                                37,
                                                255,
                                                1,
                                              ),
                                            ),
                                          ),
                                          onPressed: () async {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                );
                                              },
                                            );
                                            await Provider.of<PedidoProvider>(
                                              context,
                                              listen: false,
                                            ).putEstadoAnulado(item.id);
                                            Navigator.pop(context);

                                            Navigator.of(context).pop();

                                            // carritProvider.deleteCarrito();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  side: BorderSide(
                    color:
                        item.estado == 'anulado' || item.estado == 'entregado'
                            ? Colors.grey
                            : Color.fromARGB(255, 255, 54, 54),
                    width: 1,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Anular pedido",
                      style: GoogleFonts.manrope(
                        fontSize: 14.sp,
                        color:
                            item.estado == 'anulado' ||
                                    item.estado == 'entregado'
                                ? Colors.grey
                                : Color.fromARGB(255, 255, 54, 54),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Icon(
                      Icons.cancel_outlined,
                      color:
                          item.estado == 'anulado' || item.estado == 'entregado'
                              ? Colors.grey
                              : Color.fromARGB(255, 255, 54, 54),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      Divider(color: Colors.grey.shade300, indent: sqrt1_2),
    ],
  );
}
