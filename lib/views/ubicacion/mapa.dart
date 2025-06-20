import 'dart:async';
import 'dart:convert';
import 'package:app2025_final/providers/cliente_provider.dart';
import 'package:app2025_final/providers/ubicacion_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Mapa extends StatefulWidget {
  const Mapa({Key? key}) : super(key: key);

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  GoogleMapController? _mapController;

  LatLng? _ubicacionSeleccionada;
  BitmapDescriptor? customIcon;

  final String googleApiKey =
      "AIzaSyA45xOgppdm-PXYDE5r07eDlkFuPzYmI9g"; // Reemplaza con tu API Key

  @override
  void initState() {
    super.initState();
    // _loadMapStyle();

    final ubicacionProvier =
        Provider.of<UbicacionProvider>(context, listen: false).getUbicaiontemp;
    final direccionCompleta =
        "${ubicacionProvier?.departamento} ${ubicacionProvier?.distrito} ${ubicacionProvier?.direccion} ${ubicacionProvier?.numero_manzana}";
    print("...................UBICACION TEMPORAL");
    print(direccionCompleta);
    print("........................FIN");
    _obtenerCoordenadasDeDireccion(direccionCompleta);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // _mapController?.setMapStyle(_mapStyle);
  }

  void _actualizarUbicacion(LatLng nuevaUbicacion) {
    setState(() {
      _ubicacionSeleccionada = nuevaUbicacion;
    });
    print("....NUEVA: $nuevaUbicacion");
  }

  void _usarUbicacionFallback() {
    setState(() {
      _ubicacionSeleccionada = const LatLng(
        -12.0464,
        -77.0428,
      ); // Por ejemplo Lima
    });
  }

  Future<void> _obtenerCoordenadasDeDireccion(String direccion) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(direccion)}&key=$googleApiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final geometry = data['results'][0]['geometry']['location'];
          final lat = geometry['lat'];
          final lng = geometry['lng'];

          setState(() {
            _ubicacionSeleccionada = LatLng(lat, lng);
          });
        } else {
          debugPrint('Error en la API de Geocoding: ${data['status']}');
          _usarUbicacionFallback();
        }
      } else {
        debugPrint('Error en la solicitud HTTP: ${response.statusCode}');
        _usarUbicacionFallback();
      }
    } catch (e) {
      debugPrint('Error al obtener las coordenadas: $e');
      _usarUbicacionFallback();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ubicacionProvider =
        context.watch<UbicacionProvider>().getUbicaiontemp;
    final clienteProvider = context.watch<ClienteProvider>().clienteActual;
    final LatLng ubicacion = _ubicacionSeleccionada ?? LatLng(0, 0);
    return Scaffold(
      backgroundColor: Colors.white,
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
          "Confirmación",
          style: GoogleFonts.manrope(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SafeArea(
        child:
            _ubicacionSeleccionada == null
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                  padding: EdgeInsets.only(top: 8.r, left: 27.r, right: 27.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ajusta tu ubicación",
                        style: GoogleFonts.manrope(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: Color.fromRGBO(1, 37, 255, 1),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        "Tu dirección",
                        style: GoogleFonts.manrope(fontSize: 11.sp),
                      ),
                      SizedBox(height: 25.h),
                      Container(
                        height: 50.h,
                        width: 358.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          color: Colors.grey.shade200,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Chip(
                                backgroundColor: Color.fromRGBO(1, 37, 255, 1),
                                label: Text(
                                  '${ubicacionProvider?.etiqueta}',
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                width: 200.w,
                                child: Text(
                                  "${ubicacionProvider?.distrito} ${ubicacionProvider?.direccion}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        height: 388.h,
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: ubicacion,
                            zoom: 17.5,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId("ubicacion"),
                              position: ubicacion,
                              icon: BitmapDescriptor.defaultMarker,
                              draggable: true,
                              onDragEnd: (LatLng position) {
                                _actualizarUbicacion(position);
                              },
                            ),
                          },
                          onTap: _actualizarUbicacion,
                        ),
                      ),
                      SizedBox(height: 27.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 40.w,
                            width: 40.w,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                            child: Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 30.sp,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            "Ajusta con el pin si es necesario",
                            style: GoogleFonts.manrope(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 85.0.h),
                      Container(
                        width: 350.w,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () async {
                            print("...POSTEANDO ...");
                            print("${ubicacionProvider}");
                            print("${clienteProvider?.cliente.id}");
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
                            print("...id ubicacon ");
                            print("...........${ubicacionProvider?.id}");
                            if (ubicacionProvider?.id == null) {
                              print("...dentro de POST id ubi");
                              print(
                                "LATITUD seleccionada: ${_ubicacionSeleccionada?.latitude}",
                              );
                              print(
                                "LONGITUD seleccionada: ${_ubicacionSeleccionada?.longitude}",
                              );
                              try {
                                await Provider.of<UbicacionProvider>(
                                  context,
                                  listen: false,
                                ).postNewUbicacion(
                                  departamento: ubicacionProvider?.departamento,
                                  distrito: ubicacionProvider?.distrito,
                                  direccion: ubicacionProvider?.direccion,
                                  etiqueta: ubicacionProvider?.etiqueta,
                                  latitud: _ubicacionSeleccionada?.latitude,
                                  numero_manzana:
                                      ubicacionProvider?.numero_manzana,
                                  longitud: _ubicacionSeleccionada?.longitude,
                                  cliente_id: clienteProvider?.cliente.id,
                                );
                              } catch (e) {
                                print("Error creando ubicación: $e");
                                showDialog(
                                  context: context,
                                  builder:
                                      (_) => AlertDialog(
                                        title: Text("Ubicación inválida"),
                                        content: Text(
                                          "La ubicación seleccionada está fuera de nuestra área de cobertura.",
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text("OK"),
                                            onPressed:
                                                () =>
                                                    Navigator.of(context).pop(),
                                          ),
                                        ],
                                      ),
                                );
                              }
                            } else {
                              print("soy un EDIT");
                              await Provider.of<UbicacionProvider>(
                                context,
                                listen: false,
                              ).updateUbicacion(
                                ubicacionProvider?.departamento,
                                ubicacionProvider?.distrito,
                                ubicacionProvider?.direccion,
                                ubicacionProvider?.numero_manzana,
                                ubicacionProvider?.etiqueta,
                                _ubicacionSeleccionada!.latitude,
                                _ubicacionSeleccionada!.longitude,
                                ubicacionProvider!.id!,
                              );
                            }

                            Navigator.pop(context);

                            context.go('/barracliente');
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: const Color.fromARGB(
                              255,
                              116,
                              116,
                              116,
                            ),
                            backgroundColor: Color.fromRGBO(1, 37, 255, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                          ),
                          child: Text(
                            "Confirmación dirección",
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
