import 'package:app2025_final/views/client/components/curvas_effects/curva_inferior/clipper2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget curva2({required VoidCallback onVolverArriba}) {
  return ClipPath(
    clipper: MyCustomClipper2(),
    child: Container(
      height: 250.h,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(20.r),
        color: const Color.fromRGBO(1, 37, 255, 1),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 18.0, top: 55, right: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 135.w,
              height: 36.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: ElevatedButton(
                onPressed: onVolverArriba,
                child: Text(
                  "Ir al principio",
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.normal,
                    fontSize: 13.sp,
                    color: Color.fromRGBO(1, 37, 255, 1),
                  ),
                ),
              ),
            ),
            Container(
              width: 160.w,
              height: 110.h,
              decoration: BoxDecoration(
                //color: Colors.white
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Cuidemos el planeta",
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.normal,
                      fontSize: 15.sp,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Recicla tus bidones",
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.normal,
                      fontSize: 12.sp,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/assets/imagenes/mundo.png'),
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
