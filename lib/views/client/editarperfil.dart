import 'package:app2025_final/providers/cliente_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({Key? key}) : super(key: key);

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  // ATRIBUTOS
  TextEditingController _nombres = TextEditingController();
  TextEditingController _apellidos = TextEditingController();
  TextEditingController _telefono = TextEditingController();
  TextEditingController _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final clienteProvider = Provider.of<ClienteProvider>(
      context,
      listen: false,
    );
    _nombres = TextEditingController(
      text: clienteProvider.clienteActual?.cliente.nombres,
    );
    _apellidos = TextEditingController(
      text: clienteProvider.clienteActual?.cliente.nombres,
    );
    _telefono = TextEditingController(
      text: clienteProvider.clienteActual?.user.telefono,
    );
    _email = TextEditingController(
      text: clienteProvider.clienteActual?.user.email,
    );
  }

  String? telefonoValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El teléfono es obligatorio';
    }
    // Elimina espacios, por si acaso
    final telefono = value.trim();
    final regex = RegExp(r'^\d{9}$');
    if (!regex.hasMatch(telefono)) {
      return 'El teléfono debe tener exactamente 9 dígitos';
    }
    return null; // válido
  }

  @override
  Widget build(BuildContext context) {
    final clienteProvider = Provider.of<ClienteProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Editar perfil",
          style: GoogleFonts.manrope(fontSize: 14.sp),
        ),
        leading: Icon(Icons.arrow_back_ios),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      clienteProvider.clienteActual?.cliente?.fotoCliente ??
                          'https://solvida.sfo3.cdn.digitaloceanspaces.com/7fc4c6ecc7738247aac61a60958429d4-removebg-preview.png',
                    ),
                  ),

                  // color: Colors.grey,
                  borderRadius: BorderRadius.circular(50.r),
                ),
              ),
              SizedBox(height: 29.h),
              Text(
                "${clienteProvider.clienteActual?.cliente.nombres}",
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "${clienteProvider.clienteActual?.user.email}",
                style: GoogleFonts.manrope(fontSize: 16.sp),
              ),
              SizedBox(height: 5.h),
              Text(
                "${clienteProvider.clienteActual?.user.telefono}",
                style: GoogleFonts.manrope(fontSize: 16.sp),
              ),
              SizedBox(height: 43.h),
              Text(
                "Actualiza tus datos",
                style: GoogleFonts.manrope(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 19.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.account_circle_outlined),
                        Container(
                          width: 1.sw - 80.w,
                          child: TextFormField(
                            controller: _nombres,
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Ingresa tus nombres',
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
                              fillColor: Colors.grey.shade200,
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.abc),
                        Container(
                          width: 1.sw - 80.w,
                          child: TextFormField(
                            controller: _apellidos,
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
                              fillColor: Colors.grey.shade200,
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.phone_android_outlined),
                        Container(
                          width: 1.sw - 80.w,
                          child: TextFormField(
                            controller: _telefono,
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Ingresa tu teléfono',
                              hintStyle: GoogleFonts.manrope(fontSize: 11.sp),
                              // prefixIcon: Icon(Icons.abc),
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
                              fillColor: Colors.grey.shade200,

                              //errorText: _errorText,
                              helperText:
                                  _telefono.text.isEmpty
                                      ? "Debe tener 9 dígitos"
                                      : null,
                            ),
                            validator: telefonoValidator,
                            onChanged: (value) {
                              setState(
                                () {},
                              ); // para que el helperText se actualice mientras escribes
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 19.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.email_outlined),
                        Container(
                          width: 1.sw - 80.w,
                          child: TextFormField(
                            controller: _email,
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Ingresa tu email',
                              hintStyle: GoogleFonts.manrope(fontSize: 11.sp),
                              // prefixIcon: Icon(Icons.abc),
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
                              fillColor: Colors.grey.shade200,
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
                  ],
                ),
              ),
              SizedBox(height: 19.h),
              Container(
                width: 1.sw,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // está válido, continuar

                      final user = FirebaseAuth.instance.currentUser;
                      // DIÁLOGO DE ESPERA
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
                      await clienteProvider.postClienteData(
                        email: _email.text,
                        telefono: _telefono.text,
                        nombres: _nombres.text,
                        apellidos: _apellidos.text,
                        firebase_uid: user!.uid.toString(),
                        foto: user.photoURL.toString(),
                      );

                      Navigator.pop(context);

                      //
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('telefono', _telefono.text);

                      // LLAMAMOS A
                      /*final ruta = await Provider.of<IniciarappProvider>(
                                context,
                                listen: false)
                            .determinarRutaInicial();

                        context.go(ruta);*/

                      // LIMPIAR FORMULARIO
                      //_formKey.currentState!.reset();
                      _apellidos.clear();
                      _nombres.clear();
                      _telefono.clear();
                      _email.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: const Color.fromARGB(255, 116, 116, 116),
                    backgroundColor: Color.fromRGBO(1, 37, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  child: Text(
                    "Guardar cambios",
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
}
