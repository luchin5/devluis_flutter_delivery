import 'dart:math';

import 'package:app2025_final/providers/cliente_provider.dart';
import 'package:app2025_final/providers/pedido_provider.dart';
import 'package:app2025_final/views/client/components/pedidos/pedido.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Ordenes extends StatefulWidget {
  const Ordenes({Key? key}) : super(key: key);

  @override
  State<Ordenes> createState() => _OrdenesState();
}

class _OrdenesState extends State<Ordenes> {
  String fechaActual = DateFormat('dd/MM/yyyy').format(DateTime.now());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final cliente =
            Provider.of<ClienteProvider>(context, listen: false).clienteActual;
        final id = cliente?.cliente.id;
        Provider.of<PedidoProvider>(
          context,
          listen: false,
        ).fetchHistorialPedidos(id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final historialfinal = context.watch<PedidoProvider>();
    final cantidad = historialfinal.allhistorial?.length ?? 0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text('Pedidos', style: GoogleFonts.manrope(fontSize: 16.sp)),
      ),
      body:
          cantidad > 0
              ? Padding(
                padding: EdgeInsets.only(top: 27.r, left: 27.r, right: 27.r),
                child: Column(
                  children: [
                    Text(
                      fechaActual,
                      style: GoogleFonts.manrope(fontSize: 14.sp),
                    ),
                    SizedBox(height: 30.h),
                    Container(
                      //color: Colors.amber,
                      height: 1.sh - 250.h,
                      child: ListView.builder(
                        itemCount: historialfinal.allhistorial?.length,
                        itemBuilder: (context, index) {
                          final pedidohistorial =
                              historialfinal.allhistorial?[index];
                          return pedido(context, pedidohistorial);
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
                        "Todavía no tienes pedidos",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.normal,
                          fontSize: 24.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Empieza ahora",
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
