import 'package:app2025_final/providers/atencioncliente_provider.dart';
import 'package:app2025_final/providers/cliente_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Soporte extends StatefulWidget {
  const Soporte({Key? key}) : super(key: key);

  @override
  State<Soporte> createState() => _SoporteState();
}

class _SoporteState extends State<Soporte> {
  TextEditingController _asunto = TextEditingController();
  TextEditingController _descripcion = TextEditingController();

  String? _asuntoError;
  String? _descripcionError;

  @override
  void dispose() {
    _asunto.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  int contarPalabras(String texto) {
    return texto.trim().isEmpty ? 0 : texto.trim().split(' ').length;
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
          "Soporte técnico",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.assistant_outlined),
                        Container(
                          width: 1.sw - 80.w,
                          child: TextFormField(
                            controller: _asunto,
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Ingresa el asunto',
                              hintStyle: GoogleFonts.manrope(fontSize: 11.sp),
                              // prefixIcon: Icon(Icons.abc),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              labelText: "Asunto",
                              labelStyle: GoogleFonts.manrope(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp,
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade200,
                              errorText: _asuntoError,
                              errorStyle: TextStyle(fontSize: 9.sp),
                              //errorText: _errorText,
                              /*helperText: _errorText == null
                                          ? "Puedes usar letras y números"
                                          : null,*/
                            ),
                            onChanged: (value) {
                              // Validación en tiempo real opcional
                              if (contarPalabras(value) > 10) {
                                setState(() {
                                  _asuntoError = 'Máximo 10 palabras';
                                });
                              } else {
                                setState(() {
                                  _asuntoError = null;
                                });
                              }
                            },
                            // onChanged: _validateUsername,
                          ),
                        ),
                      ],
                    ),
                    if (_asuntoError != null)
                      Padding(
                        padding: EdgeInsets.only(left: 40.w, top: 4.h),
                        child: Text(
                          _asuntoError!,
                          style: GoogleFonts.manrope(
                            color: Colors.red,
                            fontSize: 9.sp,
                          ),
                        ),
                      ),
                    SizedBox(height: 19.h),
                    TextFormField(
                      controller: _descripcion,
                      maxLines: 10, // Número de líneas visibles
                      decoration: InputDecoration(
                        labelText: 'Descripción del problema',
                        labelStyle: GoogleFonts.manrope(
                          fontSize: 11.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        alignLabelWithHint: true,
                        hintText: 'Escribe aquí el problema que estás teniendo',
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
                        //print('Descripción: $value');
                        if (contarPalabras(value) > 20) {
                          setState(() {
                            _descripcionError = 'Máximo 20 palabras';
                          });
                        } else {
                          setState(() {
                            _descripcionError = null;
                          });
                        }
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
                          // Validar antes de enviar
                          final palabrasAsunto = contarPalabras(_asunto.text);
                          final palabrasDesc = contarPalabras(
                            _descripcion.text,
                          );

                          setState(() {
                            _asuntoError =
                                palabrasAsunto > 10
                                    ? 'Máximo 10 palabras'
                                    : null;

                            _descripcionError =
                                palabrasDesc > 20 ? 'Máximo 20 palabras' : null;
                          });

                          if (_asuntoError == null &&
                              _descripcionError == null) {
                            final cliente =
                                context
                                    .read<ClienteProvider>()
                                    .clienteActual
                                    ?.cliente;
                            final id = cliente?.id;

                            await atencionCliente.enviarSolicitudSoporte(
                              id!,
                              _asunto.text,
                              _descripcion.text,
                            );
                            _asunto.clear();
                            _descripcion.clear();
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
                          "Enviar solicitud",
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
