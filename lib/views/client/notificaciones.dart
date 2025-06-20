import 'dart:math';
import 'package:app2025_final/providers/notificacion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Notificaciones extends StatefulWidget {
  const Notificaciones({Key? key}) : super(key: key);

  @override
  State<Notificaciones> createState() => _NotificacionesState();
}

class _NotificacionesState extends State<Notificaciones> {
  final PageController _pageController = PageController();
  String fechaActual = DateFormat('dd/MM/yyyy').format(DateTime.now());
  late String horaFormateada;

  @override
  void initState() {
    super.initState();

    horaFormateada = DateFormat('hh:mm a').format(DateTime.now());
    // Llama una vez para obtener los eventos

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        final provider = Provider.of<NotificacionProvider>(
          context,
          listen: false,
        );
        provider.resetContador();

        // provider.marcarComoLeido(); // <-- Marca como leído al abrir
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notificaciones = context.watch<NotificacionProvider>();
    final totalnotify = notificaciones.allnotifycliente?.length ?? 0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Notificaciones",
          style: GoogleFonts.manrope(fontSize: 16.sp),
        ),
      ),
      body:
          totalnotify > 0
              ? Padding(
                padding: EdgeInsets.only(top: 10.r, left: 27.r, right: 27.r),
                child: Column(
                  children: [
                    Text(
                      fechaActual,
                      style: GoogleFonts.manrope(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      height: 1.sh - 270.h,
                      child: ListView.builder(
                        itemCount: notificaciones.allnotifycliente?.length,
                        itemBuilder: (context, index) {
                          final notify =
                              notificaciones.allnotifycliente?[index];
                          return Column(
                            children: [
                              Container(
                                height: 130.h,
                                //  color: Colors.amber,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${notify?.titulo}",
                                          style: GoogleFonts.manrope(
                                            fontSize: 14.sp,
                                            color: Color.fromRGBO(
                                              1,
                                              37,
                                              255,
                                              1,
                                            ),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Container(
                                          width: 285.w,
                                          height: 100.h,
                                          //color: Colors.green,
                                          child: Text(
                                            "${notify?.descripcion}",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.justify,
                                            maxLines: 5,
                                            style: GoogleFonts.manrope(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10.w),
                                    Text(
                                      "${horaFormateada}",
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                color: Colors.grey.shade300,
                                indent: sqrt1_2,
                              ),
                              SizedBox(height: 10.h),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
              : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No tienes notificaciones",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.normal,
                          fontSize: 24.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Espera nuestras difusiones en el día",
                        style: GoogleFonts.manrope(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 48.h),
                    ],
                  ),
                ),
              ),
    );
  }
}
