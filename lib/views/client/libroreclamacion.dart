import 'package:app2025_final/providers/atencioncliente_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Libroreclamacion extends StatefulWidget {
  const Libroreclamacion({Key? key}) : super(key: key);

  @override
  State<Libroreclamacion> createState() => _LibroreclamacionState();
}

class _LibroreclamacionState extends State<Libroreclamacion> {
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  // Variables para mensajes de error
  String? _nombresError;
  String? _apellidosError;
  String? _dniError;
  String? _fechaError;
  String? _tipoError;
  String? _descripcionError;

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _dniController.dispose();
    _fechaController.dispose();
    _tipoController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  int contarPalabras(String texto) {
    return texto.trim().isEmpty ? 0 : texto.trim().split(' ').length;
  }

  bool validarFecha(String fecha) {
    final regex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    return regex.hasMatch(fecha);
  }

  @override
  Widget build(BuildContext context) {
    final atencionCliente = Provider.of<AtencionClienteProvider>(
      context,
      listen: false,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Libro de reclamaciones",
          style: GoogleFonts.manrope(fontSize: 14.sp),
        ),
        leading: Icon(Icons.arrow_back_ios),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ingrese la información",
                style: GoogleFonts.manrope(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              Form(
                child: Column(
                  children: [
                    // NOMBRES
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.account_circle_outlined),
                        Container(
                          width: 1.sw - 80.w,
                          child: TextFormField(
                            // controller: _asunto,
                            controller: _nombresController,
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Nombres',
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
                              errorText: _nombresError,
                              errorStyle: TextStyle(fontSize: 9.sp),
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

                    if (_nombresError != null)
                      Padding(
                        padding: EdgeInsets.only(left: 40.w, top: 4.h),
                        child: Text(
                          _nombresError!,
                          style: GoogleFonts.manrope(
                            color: Colors.red,
                            fontSize: 9.sp,
                          ),
                        ),
                      ),
                    SizedBox(height: 19.h),

                    // Campo Apellidos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.people),
                        Container(
                          width: 1.sw - 80.w,
                          child: TextFormField(
                            controller: _apellidosController,
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Apellidos',
                              hintStyle: GoogleFonts.manrope(fontSize: 11.sp),
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
                              errorText: _apellidosError,
                              errorStyle: TextStyle(fontSize: 9.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_apellidosError != null)
                      Padding(
                        padding: EdgeInsets.only(left: 40.w, top: 4.h),
                        child: Text(
                          _apellidosError!,
                          style: GoogleFonts.manrope(
                            color: Colors.red,
                            fontSize: 9.sp,
                          ),
                        ),
                      ),
                    SizedBox(height: 19.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.abc),
                        Container(
                          width: 1.sw - 80.w,
                          child: TextFormField(
                            controller: _dniController,
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Ingresa tu DNI',
                              hintStyle: GoogleFonts.manrope(fontSize: 11.sp),
                              // prefixIcon: Icon(Icons.abc),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              labelText: "DNI",
                              labelStyle: GoogleFonts.manrope(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              errorText: _dniError,
                              errorStyle: TextStyle(fontSize: 9.sp),
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
                    if (_dniError != null)
                      Padding(
                        padding: EdgeInsets.only(left: 40.w, top: 4.h),
                        child: Text(
                          _dniError!,
                          style: GoogleFonts.manrope(
                            color: Colors.red,
                            fontSize: 9.sp,
                          ),
                        ),
                      ),
                    SizedBox(height: 19.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.date_range),
                        Container(
                          width: 1.sw - 80.w,
                          child: TextFormField(
                            controller: _fechaController,
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'DD/MM/AAAA',
                              hintStyle: GoogleFonts.manrope(fontSize: 11.sp),
                              // prefixIcon: Icon(Icons.abc),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              labelText: "Fecha del incidente",
                              labelStyle: GoogleFonts.manrope(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              errorText: _fechaError,
                              errorStyle: TextStyle(fontSize: 9.sp),
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
                    if (_fechaError != null)
                      Padding(
                        padding: EdgeInsets.only(left: 40.w, top: 4.h),
                        child: Text(
                          _fechaError!,
                          style: GoogleFonts.manrope(
                            color: Colors.red,
                            fontSize: 9.sp,
                          ),
                        ),
                      ),
                    SizedBox(height: 19.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.type_specimen),
                        Container(
                          width: 1.sw - 80.w,
                          child: TextFormField(
                            controller: _tipoController,
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Ingresa el tipo de reclamo',
                              hintStyle: GoogleFonts.manrope(fontSize: 11.sp),
                              // prefixIcon: Icon(Icons.abc),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              labelText: "Tipo de reclamo",
                              labelStyle: GoogleFonts.manrope(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              errorText: _tipoError,
                              errorStyle: TextStyle(fontSize: 9.sp),
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
                    if (_tipoError != null)
                      Padding(
                        padding: EdgeInsets.only(left: 40.w, top: 4.h),
                        child: Text(
                          _tipoError!,
                          style: GoogleFonts.manrope(
                            color: Colors.red,
                            fontSize: 9.sp,
                          ),
                        ),
                      ),
                    SizedBox(height: 19.h),
                    TextFormField(
                      controller: _descripcionController,
                      maxLines: 10, // Número de líneas visibles
                      decoration: InputDecoration(
                        labelText: 'Descripción del reclamo',
                        labelStyle: GoogleFonts.manrope(
                          fontSize: 11.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        alignLabelWithHint: true,
                        hintText: 'Escribe aquí el reclamo',
                        hintStyle: GoogleFonts.manrope(fontSize: 11.sp),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        errorText: _descripcionError,
                        errorStyle: TextStyle(fontSize: 9.sp),
                      ),
                      onChanged: (value) {
                        // Guarda o procesa el valor si es necesario
                        print('Descripción: $value');
                      },
                    ),
                    if (_descripcionError != null)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          _descripcionError!,
                          style: GoogleFonts.manrope(
                            color: Colors.red,
                            fontSize: 9.sp,
                          ),
                        ),
                      ),
                    SizedBox(height: 20.h),
                    Container(
                      width: 1.sw,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: () async {
                          bool valido = true;
                          // Validar nombres (máx 4 palabras)
                          if (contarPalabras(_nombresController.text) > 4) {
                            setState(() {
                              _nombresError = 'Máximo 4 palabras';
                              valido = false;
                            });
                          }

                          // Validar apellidos (máx 4 palabras)
                          if (contarPalabras(_apellidosController.text) > 4) {
                            setState(() {
                              _apellidosError = 'Máximo 4 palabras';
                              valido = false;
                            });
                          }

                          // Validar DNI (solo números)
                          if (!RegExp(
                            r'^[0-9]+$',
                          ).hasMatch(_dniController.text)) {
                            setState(() {
                              _dniError = 'Solo números permitidos';
                              valido = false;
                            });
                          }

                          // Validar fecha (formato DD/MM/AAAA)
                          if (!validarFecha(_fechaController.text)) {
                            setState(() {
                              _fechaError = 'Formato DD/MM/AAAA requerido';
                              valido = false;
                            });
                          }

                          // Validar tipo de reclamo (máx 10 palabras)
                          if (contarPalabras(_tipoController.text) > 10) {
                            setState(() {
                              _tipoError = 'Máximo 10 palabras';
                              valido = false;
                            });
                          }

                          // Validar descripción (máx 20 palabras)
                          if (contarPalabras(_descripcionController.text) >
                              20) {
                            setState(() {
                              _descripcionError = 'Máximo 20 palabras';
                              valido = false;
                            });
                          }
                          if (valido) {
                            await atencionCliente.enviarReclamo(
                              _nombresController.text,
                              _apellidosController.text,
                              _dniController.text,
                              _fechaController.text,
                              _tipoController.text,
                              _descripcionController.text,
                            );
                            _nombresController.clear();
                            _apellidosController.clear();
                            _dniController.clear();
                            _fechaController.clear();
                            _tipoController.clear();
                            _descripcionController.clear();

                            // Limpiar errores
                            setState(() {
                              _nombresError = null;
                              _apellidosError = null;
                              _dniError = null;
                              _fechaError = null;
                              _tipoError = null;
                              _descripcionError = null;
                            });
                          }
                        },
                        // LLAMAMOS A LA FUNCIÓN
                        /* _registermanual(
                          _controllernombres.text,
                          _controllerapellidos.text,
                          _controllertelefono.text,
                          _controlleremail.text,
                          _controllerpass.text);*/

                        // LIMPIAR FORMULARIO
                        /*_formKey.currentState!.reset();
                      _controllerapellidos.clear();
                      _controllernombres.clear();
                      _controllertelefono.clear();
                      _controlleremail.clear();
                      _controllerpass.clear();*/
                        //},
                        style: ElevatedButton.styleFrom(
                          shadowColor: const Color.fromARGB(255, 116, 116, 116),
                          backgroundColor: Color.fromRGBO(1, 37, 255, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                        child: Text(
                          "Enviar reclamo",
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
            ],
          ),
        ),
      ),
    );
  }
}
