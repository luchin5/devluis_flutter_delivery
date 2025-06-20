import 'package:app2025_final/models/distritos_model.dart';
import 'package:app2025_final/models/ubicacion_model.dart';
import 'package:app2025_final/providers/ubicacion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  TextEditingController _direccion = TextEditingController();
  TextEditingController _manzana = TextEditingController();
  TextEditingController _etiqueta = TextEditingController();

  String? _selectedDepartamento; // Agrega esto a tu clase
  String? _selectedDistrito; // Agrega esto a tu clase
  final _formKey = GlobalKey<FormState>();

  int? _selectedDepartamentoId;

  @override
  void initState() {
    super.initState();
    /* final ubicacion =
        Provider.of<UbicacionProvider>(context, listen: false).getUbicaiontemp;
    _direccion = TextEditingController(text: ubicacion?.direccion);
    _etiqueta = TextEditingController(text: ubicacion?.etiqueta);
    _manzana = TextEditingController(text: ubicacion?.numero_manzana);
    _selectedDepartamento = ubicacion?.departamento;
    _selectedDistrito = ubicacion?.distrito;*/
    final provider = Provider.of<UbicacionProvider>(context, listen: false);
    provider.cargarDepartamentos();
    final ubicacionTemp = provider.getUbicaiontemp;
    if (ubicacionTemp != null) {
      _selectedDepartamento = ubicacionTemp.departamento;
      _selectedDistrito = ubicacionTemp.distrito;
    }

    final ubicacion =
        Provider.of<UbicacionProvider>(context, listen: false).getUbicaiontemp;
    _direccion = TextEditingController(text: ubicacion?.direccion);
    _etiqueta = TextEditingController(text: ubicacion?.etiqueta);
    _manzana = TextEditingController(text: ubicacion?.numero_manzana);
    _selectedDepartamento = ubicacion?.departamento;
    _selectedDistrito = ubicacion?.distrito;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UbicacionProvider>();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(
          margin: EdgeInsets.only(left: 20.r),
          width: 30.w,
          height: 10.w,
          decoration: BoxDecoration(
            //color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_back_ios, size: 13.sp),
          ),
        ),
        title: Text(
          "Indicaciones del pedido",
          style: GoogleFonts.manrope(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 8.r, left: 27.r, right: 27.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Agrega tu dirección",
                style: GoogleFonts.manrope(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  color: Color.fromRGBO(1, 37, 255, 1),
                ),
              ),
              SizedBox(height: 15.h),
              Text(
                "Ingresa tu información abajo",
                style: GoogleFonts.manrope(fontSize: 11.sp),
              ),
              SizedBox(height: 33.h),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedDepartamento,
                      items:
                          provider.departamentos.map((departamento) {
                            return DropdownMenuItem(
                              value: departamento.nombre,
                              child: Text(departamento.nombre),
                            );
                          }).toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor selecciona un departamento';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _selectedDepartamento = value;
                          _selectedDistrito = null;
                          final depto = provider.departamentos.firstWhere(
                            (d) => d.nombre == value,
                            orElse: () => DepartamentoModel(id: -1, nombre: ''),
                          );

                          if (depto.id != -1) {
                            _selectedDepartamentoId = depto.id;
                            provider.cargarDistritos(depto.id);
                          }
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_searching),
                        labelText: "Departamento",
                        hintText: "Selecciona un departamento",
                        hintStyle: GoogleFonts.manrope(fontSize: 13.sp),
                        labelStyle: GoogleFonts.manrope(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        filled: true,
                        fillColor: Color.fromRGBO(246, 246, 246, 1),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    SizedBox(height: 41.h),
                    /*TextFormField(
                    controller: _username,
                    decoration: InputDecoration(
                      /*contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.sp, ver  ical: 16.sp),*/
                      prefixIcon: Icon(
                        Icons.maps_home_work,
                      ),
                      labelText: "Departamento",
                      labelStyle: GoogleFonts.manrope(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      filled: true,
                      fillColor:
                          Color.fromRGBO(246, 246, 246, 1), // Fondo blanco
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                  SizedBox(
                    height: 41.h,
                  ),*/
                    DropdownButtonFormField<String>(
                      value: _selectedDistrito,
                      items:
                          provider.distritos.map((distrito) {
                            return DropdownMenuItem(
                              value: distrito.nombre,
                              child: Text(distrito.nombre),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDistrito = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor selecciona un distrito';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_city),
                        labelText: "Distrito",
                        hintText: "Selecciona un distrito",
                        hintStyle: GoogleFonts.manrope(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        labelStyle: GoogleFonts.manrope(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        filled: true,
                        fillColor: Color.fromRGBO(246, 246, 246, 1),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    SizedBox(height: 41.h),
                    TextFormField(
                      controller: _direccion,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor ingresa tu dirección';
                        }
                        if (value.trim().length < 5) {
                          return 'Dirección demasiado corta';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        /*contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.sp, ver  ical: 16.sp),*/
                        prefixIcon: Icon(Icons.map_outlined),
                        labelText: "Dirección",
                        hintText: "Ej. Av. Sol",
                        hintStyle: GoogleFonts.manrope(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
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
                    SizedBox(height: 41.h),
                    TextFormField(
                      controller: _manzana,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor ingresa número, Mz. o lote';
                        }
                        if (!RegExp(
                          r'^[a-zA-Z0-9\s\-\/]+$',
                        ).hasMatch(value.trim())) {
                          return 'Solo se permiten letras, números, espacios, guiones y /';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        /*contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.sp, ver  ical: 16.sp),*/
                        prefixIcon: Icon(Icons.maps_home_work_outlined),
                        labelText: "Número/Mz./Lote",
                        hintText: "Ej. 200/F/2",
                        hintStyle: GoogleFonts.manrope(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
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
                    SizedBox(height: 41.h),
                    TextFormField(
                      controller: _etiqueta,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        /*contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.sp, ver  ical: 16.sp),*/
                        prefixIcon: Icon(Icons.label_outline),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: "Etiqueta tu dirección",
                        hintText: "Ej. Casa / Oficina / Novia",
                        hintStyle: GoogleFonts.manrope(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        helperText:
                            "Elige un nombre corto para etiquetar tu dirección",
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
                  ],
                ),
              ),
              SizedBox(height: 45.h),
              Container(
                width: 350.w,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Aquí todo está válido
                      // Tu lógica...
                      final ubicacionExistente =
                          Provider.of<UbicacionProvider>(
                            context,
                            listen: false,
                          ).getUbicaiontemp;

                      Provider.of<UbicacionProvider>(
                        context,
                        listen: false,
                      ).setTemporal(
                        UbicacionModel(
                          id:
                              ubicacionExistente
                                  ?.id, // ← Aquí lo conservas si existe
                          departamento: _selectedDepartamento,
                          distrito: _selectedDistrito,
                          direccion: _direccion.text,
                          numero_manzana: _manzana.text,
                          etiqueta: _etiqueta.text,
                        ),
                      );
                      print("ID enviado a mapa: ${ubicacionExistente?.id}");

                      context.push('/mapa');
                      print("Formulario válido, puedes continuar");
                    } else {
                      print("Formulario inválido");
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
                    "Continuar",
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
