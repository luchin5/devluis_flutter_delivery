import 'package:app2025_final/models/cupon_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CuponCard extends StatelessWidget {
  final CuponModel cupon;

  const CuponCard({super.key, required this.cupon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 191.h,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Container(
            height: 148.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(cupon.foto),
              ),
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RotatedBox(
                  quarterTurns: -1,
                  child: Text(
                    cupon.titulo ?? "cupon",
                    style: GoogleFonts.manrope(
                      fontSize: 23.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    19,
                    (int index) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 2.5, height: 2.5, color: Colors.white),
                        SizedBox(height: 5.0),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 85.w,
                          height: 85.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50.r),
                            image:
                                cupon.productos.isNotEmpty &&
                                        cupon.productos.first.foto.isNotEmpty
                                    ? DecorationImage(
                                      image: NetworkImage(
                                        cupon.productos.first.foto.first,
                                      ),
                                    )
                                    : null,
                          ),
                        ),
                        SizedBox(width: 30.w),
                        Text(
                          "-${cupon.porcentaje}%",
                          style: GoogleFonts.manrope(
                            color: Colors.white,
                            fontSize: 55.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      cupon.cupon_nombre ?? "cupon",
                      style: GoogleFonts.manrope(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0, top: 5.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "* ${cupon.regla_descuento}",
                      style: GoogleFonts.manrope(
                        color: const Color.fromRGBO(1, 37, 255, 1),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "* Válido: ${DateFormat('dd MMMM', 'es_ES').format(cupon.fecha_inicio)} al ${DateFormat('dd MMMM', 'es_ES').format(cupon.fecha_fin)}",
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10.w),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
