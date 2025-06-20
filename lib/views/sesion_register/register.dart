import 'dart:convert';
import 'package:app2025_final/providers/cliente_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _controlleremail = TextEditingController();
  TextEditingController _controllerpass = TextEditingController();
  TextEditingController _controllernombres = TextEditingController();
  TextEditingController _controllertelefono = TextEditingController();
  TextEditingController _controllerapellidos = TextEditingController();

  String apiGw = dotenv.env['MICRO_URL'] ?? '';
  final _formKey = GlobalKey<FormState>();

  Future<void> _registermanual(
    String nombres,
    String apellidos,
    String telefono,
    String email,
    String pass,
  ) async {
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
          .createUserWithEmailAndPassword(email: email, password: pass);

      // POSTEO revisado lunes fallo el post
      await Provider.of<ClienteProvider>(
        context,
        listen: false,
      ).postClienteData(
        email: email,
        telefono: telefono,
        nombres: nombres,
        apellidos: apellidos,
        foto: userCred.user?.photoURL,
        firebase_uid: userCred.user?.uid,
      );

      if (mounted) Navigator.of(context).pop();
      print("Registro manual exitoso");
      await Future.delayed(const Duration(milliseconds: 200));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
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
                            'lib/assets/imagenes/felicitaciones.png',
                          ),
                        ),
                      ),
                    ),
                    /* Icon(
                        Icons.check_circle_outline,
                        size: 60.sp,
                        color: Colors.lightGreen,
                      ),*/
                    SizedBox(height: 20),
                    Text(
                      "¡Felicitaciones!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        color: Color.fromRGBO(1, 37, 255, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Registro completado satisfactoriamente",
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
                        side: BorderSide(color: Color.fromRGBO(1, 37, 255, 1)),
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
    } catch (e) {
      print("Error de registro: $e");
      if (mounted) Navigator.of(context).pop();
      await Future.delayed(const Duration(milliseconds: 200));
      String errorMessage = "Error al registrar la cuenta";
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? errorMessage;
      }
      if (mounted)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                "Algo falló!",
                style: GoogleFonts.manrope(fontWeight: FontWeight.bold),
              ),
              content: Text(
                "Este e-mail ya está en uso por otra cuenta. Intente de nuevo por favor.",
                textAlign: TextAlign.justify,
                style: GoogleFonts.manrope(fontWeight: FontWeight.w500),
              ),
              actions: [
                TextButton(
                  child: Text(
                    "Cerrar",
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(1, 37, 255, 1),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Cierra el diálogo
                  },
                ),
              ],
            );
          },
        );

      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );*/
    }
  }

  Future<void> registerWithGoogle() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (_) =>
                Center(child: CircularProgressIndicator(color: Colors.white)),
      );
      // Forzar selección de cuenta cada vez
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        signInOption: SignInOption.standard, // Esto muestra el selector siempre
      );

      // Cerrar cualquier sesión previa de Google
      await googleSignIn.signOut();
      await Future.delayed(Duration(milliseconds: 100));

      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      Navigator.of(context, rootNavigator: true).pop(); // Cierra el dialog

      if (googleUser == null) return; // El usuario canceló el login

      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential user = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      print("........../////.......GOOGLE");
      print(user.user?.phoneNumber);
      print(user.user?.photoURL);
      print(user.user?.email);
      print(user.user?.displayName);
      /* SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('fotito', user.user!.photoURL!);*/
      var res = await http.post(
        Uri.parse(apiGw + "/register_cliente"),
        body: json.encode({
          "user": {
            "rol_id": 4,
            "email": user.user?.email ?? '-',
            "telefono": user.user?.phoneNumber ?? '-',
            "firebase_uid": user.user?.uid,
          },
          "cliente": {
            "nombres": user.additionalUserInfo?.profile?['given_name'] ?? '-',
            "apellidos":
                user.additionalUserInfo?.profile?['family_name'] ?? '-',
            "foto_cliente":
                user.user?.photoURL ??
                "https://solvida.sfo3.cdn.digitaloceanspaces.com/7fc4c6ecc7738247aac61a60958429d4-removebg-preview.png",
          },
        }),
        headers: {"Content-type": "application/json"},
      );
      if (res.statusCode == 201) {
        final clienteProvider = Provider.of<ClienteProvider>(
          context,
          listen: false,
        );
        // LLAMAR AL FETCH PARA Q CLIENTE SE LLENE
        // var data = json.decode(res.body);
        await Future.delayed(const Duration(milliseconds: 500));
        await clienteProvider.fetchClientePorFirebaseUid(user.user!.uid);
        if (mounted) Navigator.of(context).pop();
        print("Registro google exitoso");
      }
      context.go('/previa');

      // Navegar a la página principal después del login exitoso
    } catch (e) {
      print("Error en Google SignIn: $e");
      if (!mounted) return;
      Navigator.pop(context);
      // Mostrar error al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al iniciar sesión con Google")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

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
                "Registra tu nueva cuenta",
                style: GoogleFonts.manrope(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  color: Color.fromRGBO(1, 37, 255, 1),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Ingresa tu información abajo",
                style: GoogleFonts.manrope(fontSize: 11.sp),
              ),
              SizedBox(height: 24.h),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.person_outlined),
                        Container(
                          width: 1.sw - 100.w,
                          child: TextFormField(
                            controller: _controllernombres,
                            style: GoogleFonts.manrope(
                              fontSize: 11.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Ingresa tu nombre',
                              hintStyle: GoogleFonts.manrope(fontSize: 11.sp),
                              // prefixIcon: Icon(Icons.abc),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              labelText: "Nombres",
                              labelStyle: GoogleFonts.manrope(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp,
                              ),
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
                    SizedBox(height: 19.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.abc),
                        Container(
                          width: 1.sw - 100.w,
                          child: TextFormField(
                            controller: _controllerapellidos,
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Ingresa tus apellidos',
                              hintStyle: GoogleFonts.manrope(fontSize: 11.sp),
                              // prefixIcon: Icon(Icons.abc),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              labelText: "Apellidos",
                              labelStyle: GoogleFonts.manrope(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp,
                              ),
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
                    SizedBox(height: 19.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.phone_android_outlined),
                        Container(
                          width: 1.sw - 100.w,
                          child: TextFormField(
                            controller: _controllertelefono,
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                              color: Colors.black,
                            ),
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: 'Ingresa tu teléfono ',
                              hintStyle: GoogleFonts.manrope(fontSize: 11.sp),
                              // prefixIcon: Icon(Icons.phone_android_outlined),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              labelText: "Teléfono",
                              labelStyle: GoogleFonts.manrope(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp,
                              ),
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
                    SizedBox(height: 19.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.email_outlined),
                        Container(
                          width: 1.sw - 100.w,
                          child: TextFormField(
                            controller: _controlleremail,
                            style: GoogleFonts.manrope(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Ingresa un correo válido',
                              hintStyle: GoogleFonts.manrope(fontSize: 11.sp),

                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              labelText: "E-mail",
                              labelStyle: GoogleFonts.manrope(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp,
                              ),
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
                    SizedBox(height: 19.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.lock_outline),
                        Container(
                          width: 1.sw - 100.w,
                          child: TextFormField(
                            controller: _controllerpass,
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  'Ingresa una contraseña (8 caracteres min.)',
                              hintStyle: GoogleFonts.manrope(fontSize: 11.sp),
                              //prefixIcon: Icon(Icons.lock_outline),
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
                    SizedBox(height: 19.h),
                  ],
                ),
              ),
              Container(
                width: 1.sw,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _registermanual(
                        _controllernombres.text,
                        _controllerapellidos.text,
                        _controllertelefono.text,
                        _controlleremail.text,
                        _controllerpass.text,
                      );
                    }
                    // LLAMAMOS A LA FUNCIÓN

                    // LIMPIAR FORMULARIO
                    /*_formKey.currentState!.reset();
                      _controllerapellidos.clear();
                      _controllernombres.clear();
                      _controllertelefono.clear();
                      _controlleremail.clear();
                      _controllerpass.clear();*/
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: const Color.fromARGB(255, 116, 116, 116),
                    backgroundColor: Color.fromRGBO(1, 37, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  child: Text(
                    "Registrarse",
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
                      padding: const EdgeInsets.only(left: 27, right: 20),
                      child: Divider(
                        color: Colors.black,
                        thickness: 1, // Grosor de la línea
                        endIndent: 10, // Espaciado al final
                      ),
                    ),
                  ),
                  Text(
                    "o regístrate",
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: Colors.black,
                    ),
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
              SizedBox(height: 29.h),
              Container(
                width: 350.w,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    registerWithGoogle();

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
                            image: AssetImage('lib/assets/imagenes/google.png'),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        "Registrarse con Google",
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
              SizedBox(height: 46.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "¿ Ya tienes cuenta ?",
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.go('/');
                    },
                    child: Text(
                      "Inicia aquí",
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                        color: Colors.amber.shade700,
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
