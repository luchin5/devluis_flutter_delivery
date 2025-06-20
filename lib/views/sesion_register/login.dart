import 'package:app2025_final/providers/cliente_provider.dart';
import 'package:app2025_final/providers/ubicacion_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  String? _errorText;

  // Simulación de nombres de usuario ya existentes
  final List<String> existingUsernames = [
    "iamsupercool",
    "flutterdev",
    "material3",
  ];

  void _validateUsername(String value) {
    if (existingUsernames.contains(value.toLowerCase())) {
      setState(() {
        _errorText = "Este nombre de usuario ya existe!";
      });
    } else {
      setState(() {
        _errorText = null; // Sin error
      });
    }
  }

  // LOGIN MANUAL + FIREBASE
  Future<void> _loginmanual() async {
    showDialog(
      context: context,
      barrierDismissible: false, // Evita que el usuario cierre el diálogo
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      },
    );

    try {
      UserCredential userCred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _username.text,
            password: _password.text,
          );
      print("Login exitoso: ${userCred.user!.uid}");

      await Provider.of<ClienteProvider>(
        context,
        listen: false,
      ).fetchClientePorFirebaseUid(userCred.user!.uid);
      if (mounted) Navigator.of(context).pop(); // Cierra el diálogo

      // VERIFICAR SI HAY O NO UBICACION
      final cliente =
          Provider.of<ClienteProvider>(context, listen: false).clienteActual;

      final ubicacionProvider = Provider.of<UbicacionProvider>(
        context,
        listen: false,
      );
      await ubicacionProvider.getUbicaciones(cliente?.cliente.id!);
      int cantidadUbicacionesCliente = ubicacionProvider.allubicaciones.length;
      print("tiene ubicacion o no ?");
      if (cantidadUbicacionesCliente > 0) {
        await ubicacionProvider.cargarUbicacionSeleccionada();
        if (ubicacionProvider.idSeleccionado != null) {
          await ubicacionProvider.verificacionUbicacionSeleccionada(
            ubicacionProvider.idSeleccionado!,
          );
        }
        context.go('/barracliente');
      } else {
        context.go('/previa');
      }

      //  context.go('/previa');
    } catch (e) {
      print("Error de login: $e");
      if (mounted)
        Navigator.of(context).pop(); // Cierra el diálogo si hay error
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error al iniciar sesión")));
    }
  }

  Future<void> signinWithGoogle(BuildContext context) async {
    print(".....DENTRO DEL GOOGLE SIGN");
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (_) =>
                Center(child: CircularProgressIndicator(color: Colors.white)),
      );
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        signInOption: SignInOption.standard,
      );
      print(".....DENTRO DEL GOOGLE SIGN 2");

      await googleSignIn.signOut();
      await Future.delayed(const Duration(milliseconds: 100));

      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      Navigator.of(context, rootNavigator: true).pop();

      print(".....DENTRO DEL GOOGLE SIGN");
      if (googleUser == null) return; // Usuario canceló

      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential user = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      print("..........USUARIO GOOGLE $user");
      final clienteProvider = Provider.of<ClienteProvider>(
        context,
        listen: false,
      );

      await clienteProvider.fetchClientePorFirebaseUid(user.user!.uid);

      print("📦 Resultado del fetch: ${clienteProvider.clienteActual}");

      if (clienteProvider.clienteActual == null) {
        print("⚠️ Cliente no encontrado, registrando...");

        await clienteProvider.postClienteData(
          email: user.user!.email ?? '-',
          telefono: user.user!.phoneNumber ?? '-',
          nombres: user.additionalUserInfo?.profile?['given_name'] ?? '-',
          apellidos: user.additionalUserInfo?.profile?['family_name'] ?? '-',
          foto: user.user!.photoURL,
          firebase_uid: user.user!.uid,
        );

        //clienteProvider.setClienteCompleto(nuevoCliente);
        // 🔽 Aquí agregas este pequeño delay
        await Future.delayed(const Duration(milliseconds: 500));
        await clienteProvider.fetchClientePorFirebaseUid(user.user!.uid);
        print("✅ Cliente registrado y recargado");
      }

      /*     SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('fotito', user.user!.photoURL ?? '');
*/
      if (!mounted) return;

      // VERIFICAR SI HAY O NO UBICACION
      final cliente =
          Provider.of<ClienteProvider>(context, listen: false).clienteActual;
      final ubicacionProvider = Provider.of<UbicacionProvider>(
        context,
        listen: false,
      );
      await ubicacionProvider.getUbicaciones(cliente?.cliente.id!);

      int cantidadUbicacionesCliente = ubicacionProvider.allubicaciones.length;

      if (cantidadUbicacionesCliente > 0) {
        print("....ayudaaa");
        await ubicacionProvider.cargarUbicacionSeleccionada();
        if (ubicacionProvider.idSeleccionado != null) {
          print("....aquiiiiiiiiiiiiiiii");
          await ubicacionProvider.verificacionUbicacionSeleccionada(
            ubicacionProvider.idSeleccionado!,
          );
        }
        print(".........oee");
        context.go('/barracliente');
      } else {
        context.go('/previa');
      }

      // await Future.delayed(Duration(seconds: 3));
      //context.go('/previa');
    } catch (e) {
      print("ERRROR EN $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al iniciar sesión con Google ")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Hace que la pantalla se ajuste al teclado

      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 31.r, right: 31.r),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 221.h,
                    width: 218.w,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/assets/imagenes/logo.png'),
                      ),
                    ),
                  ),
                  SizedBox(height: 35.h),
                  Text(
                    "Iniciar sesión",
                    style: GoogleFonts.manrope(
                      color: Color.fromRGBO(1, 37, 255, 1),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    "Ingresa tu información abajo",
                    style: GoogleFonts.manrope(
                      color: Color.fromRGBO(1, 37, 255, 1),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 29.h),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              _errorText != null
                                  ? Icons.error
                                  : Icons.person_2_outlined,
                            ),
                            Container(
                              width: 1.sw - 100.w,
                              child: TextFormField(
                                controller: _username,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  /*contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20.sp, vertical: 16.sp),*/
                                  labelText: "Email o usuario",
                                  labelStyle: GoogleFonts.manrope(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  filled: true,
                                  fillColor: Color.fromRGBO(
                                    246,
                                    246,
                                    246,
                                    1,
                                  ), // Fondo blanco
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 19.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              _errorText != null
                                  ? Icons.error
                                  : Icons.lock_outline,
                            ),
                            Container(
                              width: 1.sw - 100.w,
                              child: TextFormField(
                                controller: _password,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  labelText: "Contraseña",
                                  labelStyle: GoogleFonts.manrope(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.sp,
                                  ),
                                  filled: true,
                                  fillColor: Color.fromRGBO(246, 246, 246, 1),
                                  errorText: _errorText,
                                  /*helperText: _errorText == null
                                          ? "Puedes usar letras y números"
                                          : null,*/
                                ),
                                onChanged: _validateUsername,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.push('/recovery');
                        },
                        child: Text(
                          "¿ Olvidaste tu contraseña ?",
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Container(
                    width: 350.w,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        _loginmanual();
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: const Color.fromARGB(255, 116, 116, 116),
                        backgroundColor: Color.fromRGBO(1, 37, 255, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      child: Text(
                        "Iniciar sesión",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 29.h),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 27),
                          child: Divider(
                            color: Colors.black,
                            thickness: 1, // Grosor de la línea
                            endIndent: 10, // Espaciado al final
                          ),
                        ),
                      ),
                      Text(
                        "o inicia sesión",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                          color: Colors.black,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 27.0),
                          child: Divider(
                            color: Colors.black,
                            thickness: 1,
                            indent: 10, // Espaciado al inicio
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 29.h),
                  Container(
                    width: 350.w,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        signinWithGoogle(context);

                        // Forma CORRECTA de navegar:
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: const Color.fromARGB(
                          255,
                          134,
                          134,
                          134,
                        ), // Elimina la sombra

                        backgroundColor: Colors.white, // Blanco puro
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 30.w,
                            height: 30.h,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'lib/assets/imagenes/google.png',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            "Iniciar sesión con Google",
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "¿ Eres nuevo en la aplicación ?",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                          color: Colors.black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.push('/register');
                        },
                        child: Text(
                          "Regístrate aquí",
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
