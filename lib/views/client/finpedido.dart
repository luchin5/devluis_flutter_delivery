import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class Finpedido extends StatefulWidget {
  const Finpedido({Key? key}) : super(key: key);

  @override
  State<Finpedido> createState() => _FinpedidoState();
}

class _FinpedidoState extends State<Finpedido> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: EdgeInsets.only(top: 27.r, left: 27.r, right: 27.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 147,
                height: 215,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage('lib/assets/imagenes/humanbidon.png'))),
              ),
            ),
            Text(
              "¡Listo!",
              style: GoogleFonts.manrope(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w900,
                  color: Color.fromRGBO(1, 37, 255, 1)),
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              "Tu pedido ha sido tomado, verifica el estado en la sección de pedidos.",
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 80.h,
            ),
            Container(
              width: 1.sw,
              height: 50.h,
              child: ElevatedButton(
                  onPressed: () {
                    context.go('/barracliente');
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      backgroundColor: Color.fromRGBO(1, 37, 255, 1)),
                  child: Text(
                    "Volver al menú",
                    style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
