import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Otp extends StatefulWidget {
  const Otp({Key? key}) : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController _controlleremail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 8.r, left: 27.r, right: 27.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Recupera tu contraseña",
                style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w900,
                    color: Color.fromRGBO(1, 37, 255, 1)),
              ),
              SizedBox(
                height: 12.h,
              ),
              Text(
                "Ingresa tu información, para recuperar tu contraseña",
                style: GoogleFonts.manrope(
                  fontSize: 11.sp,
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
              Form(
                  child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.email_outlined),
                      Container(
                        width: 1.sw - 100.w,
                        child: TextFormField(
                          controller: _controlleremail,
                          decoration: InputDecoration(
                            // prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15)),
                            labelText: "Email",
                            hintText: "Ingresa tu e-mail",
                            hintStyle: GoogleFonts.manrope(fontSize: 11.sp),
                            labelStyle: GoogleFonts.manrope(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp),
                            filled: true,
                            fillColor: Color.fromRGBO(246, 246, 246, 1),
                            //errorText: _errorText,
                            /*helperText: _errorText == null
                                          ? "Puedes usar letras y números"
                                          : null,*/
                          ),
                          // onChanged: _validateUsername,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 29.h,
                  ),
                  /*  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 27, right: 20),
                          child: Divider(
                            color: Colors.black,
                            thickness: 1, // Grosor de la línea
                            endIndent: 10, // Espaciado al final
                          ),
                        ),
                      ),
                      Text(
                        "o recupera con",
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: Colors.black),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 27, left: 20),
                          child: Divider(
                            color: Colors.black,
                            thickness: 1,
                            indent: 10, // Espaciado al inicio
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 29.h,
                  ),
                  TextFormField(
                    //controller: _password,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone_android_outlined),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)),
                      labelText: "Teléfono",
                      labelStyle: GoogleFonts.manrope(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.sp),
                      filled: true,
                      fillColor: Color.fromRGBO(246, 246, 246, 1),
                      //errorText: _errorText,
                      /*helperText: _errorText == null
                                    ? "Puedes usar letras y números"
                                    : null,*/
                    ),
                    // onChanged: _validateUsername,
                  ),
                  SizedBox(
                    height: 19.h,
                  ),*/
                  SizedBox(
                    height: 19.h,
                  ),
                ],
              )),
              Container(
                width: 1.sw,
                height: 50.h,
                child: ElevatedButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        barrierDismissible:
                            false, // Evita que el usuario cierre el diálogo
                        builder: (context) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        },
                      );
                      await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: _controlleremail.text.trim(),
                      );
                      if (mounted) Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Container(
                              height: 1.sh / 2.3,
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 120.w,
                                      width: 120.w,
                                      decoration: BoxDecoration(
                                          //color: Colors.amber,
                                          image: DecorationImage(
                                              fit: BoxFit.contain,
                                              image: AssetImage(
                                                  'lib/assets/imagenes/avion.png'))),
                                    ),
                                    /* Icon(
                        Icons.check_circle_outline,
                        size: 60.sp,
                        color: Colors.lightGreen,
                      ),*/
                                    SizedBox(height: 20),
                                    Text(
                                      "¡Enviado!",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.manrope(
                                        color: Color.fromRGBO(1, 37, 255, 1),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.sp,
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    Text(
                                      "Revisa tu e-mail y sigue las instrucciones del enlace.",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20.sp,
                                      ),
                                    ),
                                    SizedBox(height: 30.h),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                            color:
                                                Color.fromRGBO(1, 37, 255, 1)),
                                      ),
                                      child: Text(
                                        "Continuar",
                                        style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromRGBO(1, 37, 255, 1),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        shadowColor: const Color.fromARGB(255, 116, 116, 116),
                        backgroundColor: Color.fromRGBO(1, 37, 255, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r))),
                    child: Text(
                      "Enviar",
                      style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                          color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget nodireccion() {
    return Column(
      children: [
        Expanded(
          child: Column(
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
            ],
          ),
        ),
        Container(
          width: 350.w,
          height: 50.h,
          child: ElevatedButton(
            onPressed: () {},
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
        SizedBox(height: 20.h),
      ],
    );
  }
}
