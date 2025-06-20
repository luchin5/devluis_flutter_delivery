import 'package:app2025_final/providers/cliente_provider.dart';
import 'package:app2025_final/providers/ubicacion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Perfil extends StatefulWidget {
  const Perfil({Key? key}) : super(key: key);

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clienteProvider = context.watch<ClienteProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Mi perfil", style: GoogleFonts.manrope(fontSize: 16.sp)),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 27.r, left: 27.r, right: 27.r),
        child: Container(
          height: 1.sh,
          child: Column(
            children: [
              // FOTO + NOMBRES
              Container(
                height: 100.h,
                //color: Colors.grey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // FOTO DEL PERFIL
                    Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            clienteProvider
                                    .clienteActual
                                    ?.cliente
                                    ?.fotoCliente ??
                                'https://solvida.sfo3.cdn.digitaloceanspaces.com/7fc4c6ecc7738247aac61a60958429d4-removebg-preview.png',
                          ),
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                    ),
                    SizedBox(width: 30.w),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${clienteProvider.clienteActual?.cliente.nombres}",
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.sp,
                          ),
                        ),
                        Text(
                          "${clienteProvider.clienteActual?.user.email}",
                          style: GoogleFonts.manrope(fontSize: 14.sp),
                        ),
                        Text(
                          "${clienteProvider.clienteActual?.user.telefono}",
                          style: GoogleFonts.manrope(fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 36.h),

              Container(child: Divider(color: Colors.grey)),
              SizedBox(height: 10.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Opciones",
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 1.sw,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      onPressed: () {
                        context.push('/editarperfil');
                      },
                      child: Text(
                        "Mi perfil",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1.sw,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      onPressed: () {
                        context.push('/soporte');
                      },
                      child: Text(
                        "Soporte técnico",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1.sw,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      onPressed: () {
                        context.push('/libro');
                      },
                      child: Text(
                        "Libro de reclamaciones",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1.sw,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(1, 37, 255, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          },
                        );
                        await FirebaseAuth.instance.signOut();

                        final prefs = await SharedPreferences.getInstance();

                        // Limpia el número de teléfono u otros datos personalizados
                        //await prefs.remove('telefono');
                        clienteProvider.limpiarCliente();
                        Provider.of<UbicacionProvider>(
                          context,
                          listen: false,
                        ).limpiarUbicaciones();
                        Navigator.of(context).pop();
                        context.go('/');
                      },
                      child: Text(
                        "Cerrar sesión",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
