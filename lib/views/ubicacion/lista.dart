import 'package:app2025_final/providers/cliente_provider.dart';
import 'package:app2025_final/providers/ubicacion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Lista extends StatefulWidget {
  const Lista({Key? key}) : super(key: key);

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ubicacionProvider = Provider.of<UbicacionProvider>(
        context,
        listen: false,
      );
      final clienteProvider =
          Provider.of<ClienteProvider>(context, listen: false).clienteActual;
      final clientId = clienteProvider?.cliente.id;

      if (clientId == null) return;

      // 1. Carga el id guardado (si hay)
      await ubicacionProvider.cargarUbicacionSeleccionada();

      // 2. Carga todas las ubicaciones del cliente
      await ubicacionProvider.getUbicaciones(clientId);

      // 3. Si no hay seleccionado, elige la última o la primera
      /*if (ubicacionProvider.idSeleccionado == null &&
          ubicacionProvider.allubicaciones.isNotEmpty) {
        final ultima = ubicacionProvider.allubicaciones.last;
        await ubicacionProvider.seleccionarUbicacion(ultima.id!);
      }*/
    });
  }

  bool _seleccionado = false;

  @override
  Widget build(BuildContext context) {
    int cantidadDir = 1;
    final ubicacionProvider = context.watch<UbicacionProvider>();
    final ubicaciones = ubicacionProvider.allubicaciones;
    final isloading = ubicacionProvider.isLoading;
    final idSeleccionado = ubicacionProvider.idSeleccionado;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: Container(
          margin: EdgeInsets.only(left: 20.r),
          width: 30.w,
          height: 10.w,
          decoration: BoxDecoration(
            //color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back_ios, size: 13.sp),
          ),
        ),
        title: Text(
          "Tus direcciones",
          style: GoogleFonts.manrope(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 8.r, left: 16.r, right: 16.r),
          child:
              isloading
                  ? Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                  : ubicaciones.isEmpty
                  ? nodireccion()
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Edita tus direcciones",
                        style: GoogleFonts.manrope(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: Color.fromRGBO(1, 37, 255, 1),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "Lista (${ubicaciones.length})",
                        style: GoogleFonts.manrope(fontSize: 11.sp),
                      ),
                      SizedBox(height: 33.h),
                      Container(
                        color: Colors.grey.shade100,
                        height: ubicaciones.length > 1 ? 450.h : 145.h,
                        child: ListView.builder(
                          itemCount: ubicaciones.length,
                          itemBuilder: (context, index) {
                            final ubicacionActual = ubicaciones[index];
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 50.h,
                                      width: 320.w,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color.fromRGBO(1, 37, 255, 1),
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          15.r,
                                        ),
                                        color: const Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 70.w,
                                              // color: Colors.amber,
                                              child: Chip(
                                                backgroundColor: Color.fromRGBO(
                                                  1,
                                                  37,
                                                  255,
                                                  1,
                                                ),
                                                label: Text(
                                                  '${ubicacionActual.etiqueta}',
                                                  style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 11.sp,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Container(
                                              width: 180.w,
                                              child: Text(
                                                "${ubicacionActual.distrito} - ${ubicacionActual.direccion}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: GoogleFonts.manrope(
                                                  fontSize: 11.5.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color.fromARGB(
                                                    255,
                                                    0,
                                                    0,
                                                    0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Checkbox(
                                              value:
                                                  ubicacionActual.id ==
                                                  idSeleccionado,
                                              onChanged: (bool? value) {
                                                if (value == true) {
                                                  ubicacionProvider
                                                      .seleccionarUbicacion(
                                                        ubicacionActual.id!,
                                                      );
                                                }
                                              },
                                              checkColor:
                                                  Colors
                                                      .white, // color del ícono de check (✔)
                                              fillColor: WidgetStateProperty.resolveWith<
                                                Color
                                              >((Set<WidgetState> states) {
                                                if (states.contains(
                                                  WidgetState.selected,
                                                )) {
                                                  return const Color.fromARGB(
                                                    255,
                                                    255,
                                                    218,
                                                    7,
                                                  ); // color cuando está seleccionado
                                                }
                                                return Colors
                                                    .grey
                                                    .shade50; // color cuando está desactivado
                                              }),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50.r),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Provider.of<UbicacionProvider>(
                                          context,
                                          listen: false,
                                        ).setTemporal(ubicacionActual);
                                        context.push('/location');
                                      },
                                      child: Icon(Icons.edit_outlined),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        print(
                                          "${ubicacionProvider.allubicaciones.length}",
                                        );
                                        if (ubicacionProvider
                                                .allubicaciones
                                                .length >
                                            1) {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                              );
                                            },
                                          );
                                          await Provider.of<UbicacionProvider>(
                                            context,
                                            listen: false,
                                          ).deleteUbicacion(
                                            ubicacionActual.id!,
                                          );
                                          /*await Future.delayed(
                                            Duration(seconds: 3),
                                          );*/
                                          Navigator.pop(context);
                                          setState(() {});
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Container(
                                                  height: 1.sh / 2.5,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(20),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          height: 120.w,
                                                          width: 120.w,
                                                          child: Icon(
                                                            Icons.warehouse,
                                                            color:
                                                                const Color.fromARGB(
                                                                  255,
                                                                  67,
                                                                  54,
                                                                  244,
                                                                ),
                                                            size: 120.sp,
                                                          ),
                                                        ),
                                                        /* Icon(
                        Icons.check_circle_outline,
                        size: 60.sp,
                        color: Colors.lightGreen,
                      ),*/
                                                        SizedBox(height: 20),
                                                        Text(
                                                          "Se necesita al menos una ubicación de entrega",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: GoogleFonts.manrope(
                                                            color:
                                                                Color.fromRGBO(
                                                                  1,
                                                                  37,
                                                                  255,
                                                                  1,
                                                                ),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 20.sp,
                                                          ),
                                                        ),
                                                        SizedBox(height: 20.h),
                                                        SizedBox(height: 30.h),
                                                        ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors.white,
                                                            side: BorderSide(
                                                              color:
                                                                  Color.fromRGBO(
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
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Color.fromRGBO(
                                                                    1,
                                                                    37,
                                                                    255,
                                                                    1,
                                                                  ),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                              context,
                                                            ).pop();
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
                                      },
                                      child: Icon(Icons.delete_outline),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 29.h),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 100.h),
                      Container(
                        width: 1.sw,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () {
                            // Limpiar el valor temporal antes de abrir el formulario
                            Provider.of<UbicacionProvider>(
                              context,
                              listen: false,
                            ).setTemporal(null);

                            // Luego navegar al formulario de dirección (nuevo registro)
                            context.push('/location');
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: const Color.fromARGB(
                              255,
                              116,
                              116,
                              116,
                            ),
                            backgroundColor: Color.fromRGBO(1, 37, 255, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                          ),
                          child: Text(
                            "Agregar dirección",
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget nodireccion() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Todavía no hay dirección",
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w300,
            fontSize: 24.sp,
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          "Empieza ahora",
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w300,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 20.h),
        Container(
          width: 1.sw,
          height: 50.h,
          child: ElevatedButton(
            onPressed: () {
              context.push('/location');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(1, 37, 255, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
            child: Text(
              "Agregar dirección",
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
