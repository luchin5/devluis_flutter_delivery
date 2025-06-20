import 'package:app2025_final/models/producto_model.dart';
import 'package:app2025_final/models/promocion_model.dart';
import 'package:app2025_final/models/ubicacion_model.dart';
import 'package:app2025_final/providers/carrito_provider.dart';
import 'package:app2025_final/providers/categoria_inicio_provider.dart';
import 'package:app2025_final/providers/cliente_provider.dart';
import 'package:app2025_final/providers/cupon_provider.dart';
import 'package:app2025_final/providers/delivery_provider.dart';
import 'package:app2025_final/providers/pedido_provider.dart';
import 'package:app2025_final/providers/ubicacion_provider.dart';
import 'package:app2025_final/views/client/components/cupontarjeta.dart';
import 'package:app2025_final/views/client/components/items.dart';
import 'package:app2025_final/views/client/components/subcategorias/tarjeta_sub.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Carrito extends StatefulWidget {
  const Carrito({Key? key}) : super(key: key);

  @override
  State<Carrito> createState() => _CarritoState();
}

class _CarritoState extends State<Carrito> {
  final TextEditingController _telefonoController = TextEditingController();
  final GlobalKey<FormState> _formKeyTelefono = GlobalKey<FormState>();
  void _mostrarPopUp(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true, // 👈 Esto es clave
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Agrega una ubicación",
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(height: 10.h),
              Container(
                width: 1.sw,
                child: ElevatedButton(
                  onPressed: () async {
                    context.go('/listadirecciones');
                    // Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(1, 37, 255, 1),
                  ),
                  child: Text(
                    "Agregar",
                    style: GoogleFonts.manrope(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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

  void _mostrarPopUpTelefono(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true, // 👈 Esto es clave
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKeyTelefono,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Agrega tu número de teléfono",
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.phone_android_outlined),
                      Container(
                        width: 1.sw - 80.w,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _telefonoController,
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
                                _telefonoController.text.isEmpty
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
                  SizedBox(height: 10.h),
                  Container(
                    width: 1.sw,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKeyTelefono.currentState!.validate()) {
                          final telefono = _telefonoController.text.trim();
                          await Provider.of<ClienteProvider>(
                            context,
                            listen: false,
                          ).putTelefono(telefono);
                        }
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(1, 37, 255, 1),
                      ),
                      child: Text(
                        "Agregar",
                        style: GoogleFonts.manrope(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final clienteProvider = Provider.of<ClienteProvider>(
        context,
        listen: false,
      );

      final firebaseUid = clienteProvider.clienteActual?.user.firebaseUid;

      if (firebaseUid != null) {
        // Verificamos en la API si ya tiene teléfono actualizado
        clienteProvider.fetchClientePorFirebaseUid(firebaseUid).then((_) {
          final telefono = clienteProvider.clienteActual?.user.telefono;
          if (telefono == null ||
              telefono.trim() == '-' ||
              telefono.trim().isEmpty) {
            // Mostramos el popup solo si NO hay teléfono actualizado
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _mostrarPopUpTelefono(context);
            });
          }
        });
      }

      final ubicacionProvider = Provider.of<UbicacionProvider>(
        context,
        listen: false,
      );

      final ubicaciones = ubicacionProvider.allubicaciones.length;

      if (ubicaciones < 1) {
        // Mostramos el popup solo si NO hay teléfono actualizado
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _mostrarPopUp(context);
        });
      }

      _isInit = false;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<DeliveryProvider>(context, listen: false).getDeliverys();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final deliveryProvider = context.read<DeliveryProvider>();

        if (deliveryProvider.alldelivery != null &&
            deliveryProvider.alldelivery!.isNotEmpty) {
          setState(() {
            _selectedDeliveryIndex = 0; // index 0, no el id
          });
        }
      }
    });
  }

  //int contador = 1;
  String tipopago = "-";
  String tipoDelivery = "-";
  bool codigoValido = false;
  final TextEditingController _controllerCodigo = TextEditingController();
  bool _seleccionado = false;
  bool _seleccionarDelivery = false;
  int? _selectedDeliveryIndex;

  @override
  Widget build(BuildContext context) {
    final cuponProvider = context.watch<CuponProvider>();
    final carritProvider = context.watch<CarritoProvider>();
    final categoriaProvider = Provider.of<CategoriaInicioProvider>(
      context,
      listen: false,
    );
    final subcategoria =
        categoriaProvider.allcategoria_subcategoria?.subcategorias[0];

    final ubicacionProvider = context.watch<UbicacionProvider>();
    final deliveryProvider = context.watch<DeliveryProvider>();
    final pedidoProvider = context.watch<PedidoProvider>();

    UbicacionModel? direccionSeleccionada;

    final clienteProvider = context.watch<ClienteProvider>();

    if (ubicacionProvider.allubicaciones.isNotEmpty) {
      direccionSeleccionada = ubicacionProvider.allubicaciones.firstWhere(
        (u) => u.id == ubicacionProvider.idSeleccionado,
        orElse: () => ubicacionProvider.allubicaciones.first,
      );
    } else {
      direccionSeleccionada = null;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Carrito", style: GoogleFonts.manrope(fontSize: 16.sp)),
      ),
      body:
          carritProvider.totalItems > 0
              ? Padding(
                padding: EdgeInsets.only(top: 0.r, left: 27.r, right: 27.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // DIRECCIÓN Y ETIQUETA
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Dirección de entrega",
                          style: GoogleFonts.manrope(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.push('/listadirecciones');
                          },
                          child: Row(
                            children: [
                              Text(
                                "Cambiar",
                                style: GoogleFonts.manrope(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(1, 37, 255, 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      ///color: Colors.grey,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Chip(
                              backgroundColor: Color.fromRGBO(1, 37, 255, 1),
                              label: Text(
                                direccionSeleccionada?.etiqueta ?? "-/-",
                                style: GoogleFonts.manrope(
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Container(
                              width: 265.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${direccionSeleccionada!.direccion} ${direccionSeleccionada!.distrito}" ??
                                      "ninguno",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.manrope(fontSize: 14.sp),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    Container(
                      height: 1.sh - 255.h,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TITULO - CAJA CON PRODUCTOS
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Items (${carritProvider.totalItems})",
                                  style: GoogleFonts.manrope(fontSize: 14.sp),
                                ),
                                IconButton(
                                  onPressed: () {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                          cuponProvider.limpiarCupon();
                                        });
                                    carritProvider.deleteCarrito();
                                  },
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                    size: 24.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.h),

                            // CARRITO - CAJA
                            Container(
                              color: Colors.yellow.shade100,
                              height:
                                  carritProvider.totalItems > 1
                                      ? 270.h
                                      : 125.0.h,
                              child: ListView.builder(
                                itemCount:
                                    carritProvider.itemsCombinados.length,
                                itemBuilder: (context, index) {
                                  final item =
                                      carritProvider.itemsCombinados[index];
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      if (item is ProductoModel)
                                        ItemCarrito(
                                          producto: item,
                                          index: index,
                                        )
                                      else if (item is PromocionModel)
                                        ItemCarrito(
                                          producto: item,
                                          index: index,
                                        ),
                                      Divider(color: Colors.grey.shade400),
                                    ],
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 18.h),
                            Text(
                              "Agrega a tu pedido",
                              style: GoogleFonts.manrope(fontSize: 14.sp),
                            ),
                            SizedBox(height: 18.h),
                            // COMPLEMENTO DE PEDIDOS
                            Container(
                              height: 220,
                              //color: Colors.grey,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: subcategoria?.productos.length,
                                itemBuilder: (context, index) {
                                  final producto =
                                      subcategoria?.productos[index];
                                  return tarjeta_sub(
                                    context: context,
                                    alto: 220,
                                    ancho: 133,
                                    separacion_tarjeta: 19,
                                    ima_alto: 100,
                                    ima_ancho: 100,
                                    item: producto,
                                    cajatextoalto: 65,
                                    cajatextoancho: 100,
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 18.h),

                            // CÓDIGO OCASIONAL DE DESCUENTO
                            Text(
                              "Código de descuento",
                              style: GoogleFonts.manrope(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 124, 222, 43),
                              ),
                            ),
                            SizedBox(height: 15.0.h),

                            // CÓDIGO DE DESCUENTO
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 1.sw - 150.w,
                                  height: 60.h,
                                  child: Form(
                                    child: TextFormField(
                                      controller: _controllerCodigo,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ),
                                        ),
                                        hintText: 'Ingresa un código válido',
                                        hintStyle: GoogleFonts.manrope(
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // VALIDACIÓN DE CÓDIGO DE DESCUENTO
                                TextButton(
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
                                    //  await Future.delayed(Duration(seconds: 4));

                                    final esValido = await pedidoProvider
                                        .verificarCodigo(
                                          _controllerCodigo.text.trim(),
                                        );
                                    if (esValido) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Código aplicado correctamente",
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Código inválido o expirado",
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }

                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Aplicar",
                                    style: GoogleFonts.manrope(
                                      fontSize: 14.sp,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),

                            // CUPON CARGADO
                            if (cuponProvider.cargarCupon != null) ...[
                              // METODO DE PAGO
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Cupón de descuento",
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            cuponProvider.limpiarCupon();
                                          });
                                    },
                                    child: Text(
                                      "Quitar cupón",
                                      style: GoogleFonts.manrope(
                                        color: Color.fromRGBO(1, 37, 255, 1),
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 18.h),
                              CuponCard(
                                cupon: cuponProvider.cargarCupon!,
                              ).animate().shake().fadeIn(),
                              SizedBox(height: 22.h),
                            ],

                            // TIPO DE DELIVERY
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Delivery",
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                Text(
                                  "Estimado: 55 min - 65 min",
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                    color: Color.fromRGBO(1, 37, 255, 1),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 18.h),
                            Container(
                              height:
                                  deliveryProvider.alldelivery!.length > 1
                                      ? 165.h
                                      : 78.h,
                              padding: EdgeInsets.all(4.r),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                //  color: const Color.fromARGB(255, 221, 252, 233),
                              ),
                              child: ListView.builder(
                                //scrollDirection: Axis.horizontal,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: deliveryProvider.alldelivery?.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      SizedBox(height: 10),
                                      Container(
                                        height: 50.h,
                                        width: 1.sw,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ),
                                          border: Border.all(
                                            color: Color.fromRGBO(
                                              116,
                                              20,
                                              108,
                                              1,
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "${deliveryProvider.alldelivery?[index].nombre}",
                                                    style: GoogleFonts.manrope(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  SizedBox(width: 20.w),
                                                  Text(
                                                    "S/.${deliveryProvider.alldelivery?[index].precio}",
                                                    style: GoogleFonts.manrope(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Checkbox(
                                                value:
                                                    _selectedDeliveryIndex ==
                                                    index,
                                                checkColor:
                                                    Colors
                                                        .white, // color del ícono de check (✔)
                                                fillColor: WidgetStateProperty.resolveWith<
                                                  Color
                                                >((Set<WidgetState> states) {
                                                  if (states.contains(
                                                    WidgetState.selected,
                                                  )) {
                                                    return Colors
                                                        .amber; // color cuando está seleccionado
                                                  }
                                                  return Colors
                                                      .grey
                                                      .shade50; // color cuando está desactivado
                                                }),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        50.r,
                                                      ),
                                                ),
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    if (value == true) {
                                                      _selectedDeliveryIndex =
                                                          index;
                                                    } else {
                                                      _selectedDeliveryIndex =
                                                          null;
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  );
                                },
                              ),
                            ),

                            SizedBox(height: 18.h),
                            // METODO DE PAGO
                            Text(
                              "Método de pago",
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 18.h),

                            // MÉTODO DE PAGO
                            Container(
                              height: 70.h,
                              width: 1.sw,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                //color: Colors.green.shade100,
                                border: Border.all(
                                  color: Color.fromRGBO(1, 37, 255, 1),
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Efectivo",
                                        style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15.sp,
                                        ),
                                      ),
                                      Checkbox(
                                        value: _seleccionado,
                                        checkColor:
                                            Colors
                                                .white, // color del ícono de check (✔)
                                        fillColor: WidgetStateProperty.resolveWith<
                                          Color
                                        >((Set<WidgetState> states) {
                                          if (states.contains(
                                            WidgetState.selected,
                                          )) {
                                            return Colors
                                                .amber; // color cuando está seleccionado
                                          }
                                          return Colors
                                              .grey
                                              .shade50; // color cuando está desactivado
                                        }),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            50.r,
                                          ),
                                        ),
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _seleccionado = value!;
                                            tipopago =
                                                value! ? "Efectivo" : "-";
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 18.h),
                            Text(
                              "Resumen",
                              style: GoogleFonts.manrope(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 18.h),

                            // RESUMEN DE PEDIDO
                            Container(
                              width: 359.w,
                              height: 200.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: 17.r,
                                  left: 21.r,
                                  right: 21.r,
                                  bottom: 17.r,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Tipo de pago",
                                          style: GoogleFonts.manrope(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          "${tipopago}",
                                          style: GoogleFonts.manrope(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Subtotal",
                                          style: GoogleFonts.manrope(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          "S/.${carritProvider.sumatotalPedido.toStringAsFixed(2)}",
                                          style: GoogleFonts.manrope(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          (deliveryProvider.alldelivery !=
                                                      null &&
                                                  deliveryProvider
                                                      .alldelivery!
                                                      .isNotEmpty &&
                                                  _selectedDeliveryIndex !=
                                                      null &&
                                                  _selectedDeliveryIndex! <
                                                      deliveryProvider
                                                          .alldelivery!
                                                          .length)
                                              ? "Delivery - ${deliveryProvider.alldelivery?[_selectedDeliveryIndex!].nombre}"
                                              : "Delivery - /",
                                          style: GoogleFonts.manrope(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          _selectedDeliveryIndex != null
                                              ? "S/.${deliveryProvider.alldelivery?[_selectedDeliveryIndex!].precio.toStringAsFixed(2)}"
                                              : "S/.0.00",
                                          style: GoogleFonts.manrope(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Código de descuento",
                                              style: GoogleFonts.manrope(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.normal,
                                                color:
                                                    pedidoProvider
                                                                .codigoVerificado
                                                                ?.codigo !=
                                                            null
                                                        ? Colors.orange
                                                        : Colors.black,
                                              ),
                                            ),
                                            pedidoProvider
                                                        .codigoVerificado
                                                        ?.codigo !=
                                                    null
                                                ? Icon(
                                                  Icons.verified_outlined,
                                                  color: Colors.orange,
                                                )
                                                : SizedBox.shrink(),
                                          ],
                                        ),
                                        Text(
                                          pedidoProvider
                                                      .codigoVerificado
                                                      ?.codigo !=
                                                  null
                                              ? "-%${pedidoProvider.codigoVerificado?.descuento}"
                                              : "-",
                                          style: GoogleFonts.manrope(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),

                                    /// CUPÓN DE DESCUENTO
                                    cuponProvider.estaCargado
                                        ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Cupón de decuento",
                                              style: GoogleFonts.manrope(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),

                                            SizedBox(width: 5),
                                            Container(
                                              width: 51.w,
                                              height: 20.h,
                                              decoration: BoxDecoration(
                                                color: Colors.amber,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(
                                                    20.r,
                                                  ),
                                                  bottomLeft: Radius.circular(
                                                    20.r,
                                                  ),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "cupón",
                                                  style: GoogleFonts.manrope(
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Text(
                                              "-%${cuponProvider.cargarCupon?.porcentaje} ",
                                              style: GoogleFonts.manrope(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        )
                                        : SizedBox.shrink(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total",
                                          style: GoogleFonts.manrope(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          (deliveryProvider.alldelivery !=
                                                      null &&
                                                  deliveryProvider
                                                      .alldelivery!
                                                      .isNotEmpty &&
                                                  _selectedDeliveryIndex !=
                                                      null &&
                                                  _selectedDeliveryIndex! <
                                                      deliveryProvider
                                                          .alldelivery!
                                                          .length)
                                              ? "S/.${carritProvider.sumatotalPedido + (deliveryProvider.alldelivery![_selectedDeliveryIndex!].precio)}"
                                              : "-",
                                          style: GoogleFonts.manrope(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 17.h),

                            // CANCELAR PEDIDO
                            Container(
                              width: 1.sw,
                              height: 56.h,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: const Color.fromARGB(
                                        255,
                                        172,
                                        172,
                                        172,
                                      ),
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      15.r,
                                    ), // Bordes completamente rectos
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: Container(
                                          height: 1.sh / 2.5,
                                          child: Padding(
                                            padding: EdgeInsets.all(20),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  height: 120.w,
                                                  width: 120.w,
                                                  child: Icon(
                                                    Icons.cancel_outlined,
                                                    color: Colors.red,
                                                    size: 120.sp,
                                                  ),
                                                ),
                                                /* Icon(
                          Icons.check_circle_outline,
                          size: 60.sp,
                          color: Colors.lightGreen,
                        ),*/
                                                SizedBox(height: 20),
                                                Text(
                                                  "¿Deseas cancelar el pedido?",
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.manrope(
                                                    color: Color.fromRGBO(
                                                      1,
                                                      37,
                                                      255,
                                                      1,
                                                    ),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20.sp,
                                                  ),
                                                ),
                                                SizedBox(height: 20.h),
                                                SizedBox(height: 30.h),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.white,
                                                        side: BorderSide(
                                                          color: Color.fromRGBO(
                                                            1,
                                                            37,
                                                            255,
                                                            1,
                                                          ),
                                                        ),
                                                      ),
                                                  child: Text(
                                                    "Continuar",
                                                    style: GoogleFonts.manrope(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color.fromRGBO(
                                                        1,
                                                        37,
                                                        255,
                                                        1,
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();

                                                    carritProvider
                                                        .deleteCarrito();
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
                                child: Text(
                                  "Cancelar pedido",
                                  style: GoogleFonts.manrope(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),

                            Container(
                              width: 1.sw,
                              height: 56.h,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      15.r,
                                    ), // Bordes completamente rectos
                                  ),
                                  backgroundColor: Color.fromRGBO(
                                    1,
                                    37,
                                    255,
                                    1,
                                  ),
                                ),
                                onPressed:
                                    (_seleccionado &&
                                            _selectedDeliveryIndex != null)
                                        // metodo de pago
                                        ? () async {
                                          showDialog(
                                            context: context,
                                            barrierDismissible:
                                                false, // Evita que el usuario cierre el diálogo
                                            builder: (context) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                              );
                                            },
                                          );
                                          final codigo =
                                              Provider.of<PedidoProvider>(
                                                context,
                                                listen: false,
                                              ).codigoVerificado;
                                          final cuponProvider =
                                              Provider.of<CuponProvider>(
                                                context,
                                                listen: false,
                                              );

                                          double discountAmount = 0.0;
                                          double cuponDiscount = 0.0;
                                          double codigoDiscount = 0.0;

                                          bool hasCupon =
                                              cuponProvider.cargarCupon?.id !=
                                                  null &&
                                              cuponProvider
                                                      .cargarCupon
                                                      ?.productos !=
                                                  null &&
                                              cuponProvider
                                                  .cargarCupon!
                                                  .productos
                                                  .isNotEmpty;

                                          bool hasCodigo = codigo != null;

                                          // CASO 1: Solo cupón (cupon_id && !codigo_id)
                                          if (hasCupon && !hasCodigo) {
                                            final productoIdCupon =
                                                cuponProvider
                                                    .cargarCupon!
                                                    .productos[0]
                                                    .id;
                                            final totalProductoCupon =
                                                carritProvider
                                                    .obtenerTotalSoloProducto(
                                                      productoIdCupon,
                                                    );
                                            final porcentajeDescuentoCupon =
                                                cuponProvider
                                                    .cargarCupon
                                                    ?.porcentaje ??
                                                0;

                                            discountAmount =
                                                totalProductoCupon *
                                                (porcentajeDescuentoCupon /
                                                    100);

                                            print("CASO 1: Solo cupón");
                                            print(
                                              "Total del producto con cupón: $totalProductoCupon",
                                            );
                                            print(
                                              "Descuento aplicado: $discountAmount",
                                            );
                                          }
                                          // CASO 2: Solo código (!cupon_id && codigo_id)
                                          else if (!hasCupon && hasCodigo) {
                                            discountAmount =
                                                carritProvider.sumatotalPedido *
                                                (codigo.descuento / 100);

                                            print("CASO 2: Solo código");
                                            print(
                                              "Descuento código aplicado: $discountAmount",
                                            );
                                          }
                                          // CASO 3: Cupón y código juntos (cupon_id && codigo_id)
                                          else if (hasCupon && hasCodigo) {
                                            // Calcular descuento del cupón (solo para el producto específico)
                                            final productoIdCupon =
                                                cuponProvider
                                                    .cargarCupon!
                                                    .productos[0]
                                                    .id;
                                            final totalProductoCupon =
                                                carritProvider
                                                    .obtenerTotalSoloProducto(
                                                      productoIdCupon,
                                                    );
                                            final porcentajeDescuentoCupon =
                                                cuponProvider
                                                    .cargarCupon
                                                    ?.porcentaje ??
                                                0;

                                            cuponDiscount =
                                                totalProductoCupon *
                                                (porcentajeDescuentoCupon /
                                                    100);

                                            // Calcular descuento del código (sobre el subtotal general)
                                            codigoDiscount =
                                                carritProvider.sumatotalPedido *
                                                (codigo.descuento / 100);

                                            // Promedio de ambos descuentos
                                            discountAmount =
                                                (cuponDiscount +
                                                    codigoDiscount) /
                                                2;

                                            print(
                                              "CASO 3: Cupón y código juntos",
                                            );
                                            print(
                                              "Descuento cupón: $cuponDiscount",
                                            );
                                            print(
                                              "Descuento código: $codigoDiscount",
                                            );
                                            print(
                                              "Descuento promedio aplicado: $discountAmount",
                                            );
                                          }

                                          print("detalles ");
                                          print(
                                            "${carritProvider.detallesPedido}",
                                          );

                                          //carritProvider.sincronizarDetallesPedidoConMap();
                                          carritProvider
                                              .sincronizarCantidadesDetalles();

                                          List<Map<String, dynamic>> detalles =
                                              carritProvider.detallesPedido
                                                  .map(
                                                    (detalle) =>
                                                        detalle.toJson(),
                                                  )
                                                  .toList();

                                          print("Necesidades Detalles");
                                          //print(cuponProvider
                                          //    .cargarCupon?.productos[0].id);
                                          //print(cuponProvider.cargarCupon
                                          //    ?.productos[0].cantidad);

                                          final cliente =
                                              clienteProvider
                                                  .clienteActual
                                                  ?.cliente
                                                  .id;
                                          final totalFinal =
                                              (carritProvider.sumatotalPedido -
                                                  discountAmount) +
                                              deliveryProvider
                                                  .alldelivery![_selectedDeliveryIndex!]
                                                  .precio;
                                          await Provider.of<PedidoProvider>(
                                            context,
                                            listen: false,
                                          ).postPedido(
                                            clienteId: cliente,
                                            estado: "pendiente",
                                            observacion: "observacion",
                                            tipoPago: "${tipopago}",
                                            ubicacionId:
                                                direccionSeleccionada?.id,
                                            cuponId:
                                                cuponProvider.cargarCupon?.id,
                                            deliveryId:
                                                deliveryProvider
                                                    .alldelivery![_selectedDeliveryIndex!]
                                                    .id,
                                            codigoId: codigo?.id,
                                            total: totalFinal,
                                            detalles: detalles,
                                          );
                                          //print(object)
                                          carritProvider.deleteCarrito();
                                          carritProvider.setearDetalle();
                                          cuponProvider.limpiarCupon();
                                          pedidoProvider
                                              .setearCodigoDescuento();

                                          Navigator.pop(context);

                                          context.go('/fin_pedido');
                                        }
                                        : null,
                                child: Text(
                                  "Proceder con el pedido",
                                  style: GoogleFonts.manrope(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 50.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Tu carrito está vacio",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.normal,
                          fontSize: 24.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Empieza ahora",
                        style: GoogleFonts.manrope(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 48.h),
                      Container(
                        width: 1.sw,
                        child: ElevatedButton(
                          onPressed: () {
                            context.go('/barracliente');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(1, 37, 255, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                          ),
                          child: Text(
                            "Escoger productos",
                            style: GoogleFonts.manrope(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
