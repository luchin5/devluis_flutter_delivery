import 'dart:async';
import 'package:app2025_final/class_config/clase_notificacion.dart';
import 'package:app2025_final/providers/carrito_provider.dart';
import 'package:app2025_final/providers/categoria_inicio_provider.dart';
import 'package:app2025_final/providers/categoria_provider.dart';
import 'package:app2025_final/providers/cliente_provider.dart';
import 'package:app2025_final/providers/evento_provider.dart';
import 'package:app2025_final/providers/notificacion_provider.dart';
import 'package:app2025_final/providers/novedades_provider.dart';
import 'package:app2025_final/providers/subcategoria_provider.dart';
import 'package:app2025_final/providers/temperatura_provider.dart';
import 'package:app2025_final/providers/ubicacion_provider.dart';
import 'package:app2025_final/views/client/components/categorias.dart';
import 'package:app2025_final/views/client/components/curvas_effects/curva_inferior/curva2.dart';
import 'package:app2025_final/views/client/components/curvas_effects/curva_superior/curva1.dart';
import 'package:app2025_final/views/client/components/subcategorias/subcategoria.dart';
import 'package:app2025_final/views/client/components/tarjetas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Inicio2 extends StatefulWidget {
  const Inicio2({Key? key}) : super(key: key);

  @override
  State<Inicio2> createState() => _Inicio2State();
}

class _Inicio2State extends State<Inicio2> {
  final PageController _pageController = PageController();
  final GlobalKey _imageKey = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;

  /* @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTutorial();
    });*
  }*/

  void _showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: const Color.fromARGB(255, 59, 59, 59),
      textSkip: "Saltar",
      paddingFocus: 3,
      opacityShadow: 0.8,
    );
    tutorialCoachMark.show(context: context);
  }

  List<TargetFocus> _createTargets() {
    return [
      TargetFocus(
        identify: "item1",
        keyTarget: _imageKey,
        shape: ShapeLightFocus.RRect, // forma rectangular
        radius: 8, // esquinas redondeadas
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Text(
              "Haz clic en la imagen para más detalles.",
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ];
  }

  void _scrollArriba() {
    _scrollControllerInicio.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
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
  void dispose() {
    _scrollTimer.cancel();
    _bannerController.dispose();

    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();
  final ScrollController _scrollControllerInicio = ScrollController();
  final TextEditingController _telefonoController = TextEditingController();
  late Timer _scrollTimer;
  int _currentIndex = 0;
  final GlobalKey<FormState> _formKeyTelefono = GlobalKey<FormState>();

  final PageController _bannerController = PageController();
  int _bannerIndex = 0;
  //final notificationsService = NotificationsService(); // Obtén la instancia

  // POP UP TELÉFONO
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
                          final telefono = _telefonoController.text.trim();
                          await Provider.of<ClienteProvider>(
                            context,
                            listen: false,
                          ).putTelefono(telefono);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
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
              _mostrarPopUp(context);
            });
          }
        });
      }

      _isInit = false;
    }
  }

  @override
  void initState() {
    super.initState();

    final clienteProvider =
        Provider.of<ClienteProvider>(context, listen: false).clienteActual;

    // Llama una vez para obtener los eventos --- descomentado hoy lunes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final clienteID = clienteProvider?.cliente.id;
      if (mounted) {
        Provider.of<UbicacionProvider>(
          context,
          listen: false,
        ).getUbicaciones(clienteID!);
      }
    });

    // Llama una vez para obtener los eventos
    /* WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<UbicacionProvider>(context, listen: false)
            .cargarUbicacionSeleccionada();
      }
    });*/

    // Llama una vez para obtener los eventos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<EventoProvider>(context, listen: false).getEventos();
      }
    });

    // Llama una vez para obtener los eventos FUNCIONA PERO MANDA SIMEPRE LA 1ERA UBICACION PARA MOSTRAR
    /* WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        print("....cliente ...  ubicacion");

        final ubicacionCliente =
            Provider.of<UbicacionProvider>(context, listen: false)
                .allubicaciones;

        if (ubicacionCliente.isNotEmpty) {
          // SE ENVIA NULL POR DEFAULT
          final ubicacion = ubicacionCliente.first;
          Provider.of<CategoriaInicioProvider>(context, listen: false)
              .getCategoriaSubcategoria(null, ubicacion.id!);
        } else {
          print(
              "❗ No hay ubicaciones cargadas. No se puede cargar categorías.");
          // Si es la pantalla principal, podrías redirigir o mostrar un mensaje.
        }
      }
    });*/
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final ubicacionProvider = Provider.of<UbicacionProvider>(
          context,
          listen: false,
        );

        if (ubicacionProvider.allubicaciones.isNotEmpty) {
          // Intentamos obtener la ubicación seleccionada
          final ubicacionSeleccionadaId = ubicacionProvider.idSeleccionado;

          final ubicacion =
              ubicacionSeleccionadaId != null
                  ? ubicacionProvider.allubicaciones.firstWhere(
                    (u) => u.id == ubicacionSeleccionadaId,
                    orElse: () => ubicacionProvider.allubicaciones.first,
                  )
                  : ubicacionProvider.allubicaciones.first;

          // Guardamos zonatrabajo_id en el provider categoria
          Provider.of<CategoriaInicioProvider>(
            context,
            listen: false,
          ).setZonaTrabajoId(ubicacion.zonatrabajo_id);

          Provider.of<CategoriaInicioProvider>(
            context,
            listen: false,
          ).getCategoriaSubcategoria(null, ubicacion.id!);
        } else {
          print(
            "❗ No hay ubicaciones cargadas. No se puede cargar categorías.",
          );
        }
      }
    });

    // Llama una vez para obtener los eventos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<TemperaturaProvider>(
          context,
          listen: false,
        ).getTemperatura();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<NotificacionProvider>(
          context,
          listen: false,
        ).getNotificaciones();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<NovedadesProvider>(context, listen: false).getNovedades();
      }
    });

    /*Future.microtask(() {
      final ubicacionSeleccionada =
          Provider.of<UbicacionProvider>(context, listen: false).idSeleccionado;
      Provider.of<UbicacionProvider>(context, listen: false)
          .verificacionUbicacionSeleccionada(ubicacionSeleccionada!);
    });*/

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final categoriaProvider = Provider.of<CategoriaProvider>(
        context,
        listen: false,
      );
      final categoriaInicioProvider = Provider.of<CategoriaInicioProvider>(
        context,
        listen: false,
      );

      await categoriaProvider.getCategorias(); // Espera a que termine

      final categorias = categoriaProvider.allcategorias;

      if (categorias.isNotEmpty &&
          categoriaInicioProvider.categoriaIdSeleccionada == null) {
        categoriaInicioProvider.setCategoriaSeleccionada(categorias.first.id);
      }
    });

    _scrollTimer = Timer.periodic(Duration(seconds: 4), (_) {
      if (!mounted) return;

      final eventos =
          Provider.of<EventoProvider>(context, listen: false).todoseventos;

      if (eventos.isEmpty) return;

      final eventoActual = eventos[_currentIndex];
      final banners = eventoActual.banners;

      if (banners.isEmpty) return;
      setState(() {
        // Si aún hay más banners en el evento actual
        if (_bannerIndex < banners.length - 1) {
          _bannerIndex += 1;
        } else {
          // Pasamos al siguiente evento
          _currentIndex = (_currentIndex + 1) % eventos.length;
          _bannerIndex = 0;
        }

        if (_bannerController.hasClients) {
          _bannerController.jumpToPage(_bannerIndex);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventos = context.watch<EventoProvider>().todoseventos;
    // Aquí construyes tu vista
    final categorias = context.watch<CategoriaProvider>().allcategorias;

    final categoriaInicio =
        context.watch<CategoriaInicioProvider>().allcategoria_subcategoria;
    //String nombre
    final carritoProvider = context.watch<CarritoProvider>();
    //bool estoyenreparto = context.watch<UbicacionProvider>().fueradelarea;
    final ubicacionProvider = context.watch<UbicacionProvider>();

    final novedadesProvider = context.watch<NovedadesProvider>();
    int totaldenovedades = novedadesProvider.allnovedades!.length;
    final mitadNovedades = (totaldenovedades / 2).ceil();
    final primeraMitad =
        novedadesProvider.allnovedades!.take(mitadNovedades).toList();
    final tempProvider = context.watch<TemperaturaProvider>();
    final segundaMitad =
        novedadesProvider.allnovedades!.skip(mitadNovedades).toList();

    // ⛔ Asegurarse de que hay eventos antes de seguir
    if (eventos.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final eventoactual = eventos[_currentIndex];
    final banners = eventoactual.banners;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollControllerInicio,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CURVA 1 SUPERIROR
                Stack(
                  children: [
                    // CURVA
                    Curva1(
                      currentIndex: _currentIndex,
                      fondo: eventoactual.fondofoto,
                    ),

                    // MENSAJES
                    Positioned(
                      top: 160.h,
                      left: 12.w,
                      child: GestureDetector(
                        onTap: () {
                          print("object");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // MENSAJES
                            Container(
                              height: 200.h,
                              width: 248.w,
                              // color: Colors.green,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '${banners[_bannerIndex].titulo}\n',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24.5.sp,
                                            color: Color.fromRGBO(
                                              255,
                                              255,
                                              255,
                                              1,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              '${banners[_bannerIndex].descripcion}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp,
                                            color: Color.fromRGBO(
                                              255,
                                              255,
                                              255,
                                              1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    maxLines: 2,
                                  ),
                                  SizedBox(height: 18.h),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              '${banners[_bannerIndex].restriccion}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                            color: Color.fromRGBO(
                                              255,
                                              255,
                                              255,
                                              1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // IMAGEN SOBREPUESTA
                    Positioned(
                      top: 160.h,
                      right: 8.w,
                      child: // IMAGENES
                          Container(
                        height: 245.h,
                        width: 140.w,
                        child: PageView.builder(
                          controller: _bannerController,
                          itemCount: banners.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 235.h,
                              width: 140.w,
                              decoration: BoxDecoration(
                                //  color: const Color.fromARGB(255, 100, 125, 134),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    banners[_bannerIndex].foto,
                                  ),
                                  //fit: BoxFit.fill,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                // CUERPO DEL APP
                Transform.translate(
                  offset: Offset(0, -60), //
                  child: Padding(
                    padding: EdgeInsets.only(left: 14.r, right: 14.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // CATEGORÍA + VERMAS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Categorías",
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),

                            // TERNARIO PARA UBICACIÓN
                            /*  TextButton(
                                onPressed: ubicacionProvider.dentrodeArea
                                    ? () {
                                        context.push('/todocategoria');
                                      }
                                    : null,
                                child: Text(
                                  "ver más",
                                  style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                      color: Colors.grey.shade600),
                                ))*/
                          ],
                        ),
                        SizedBox(height: 10.h),
                        // LIST VIEW * OJO CATEGORIAS
                        Container(
                          height: 96.h,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(25.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(
                                  0.3,
                                ), // Color de la sombra
                                spreadRadius:
                                    5, // Qué tan expandida está la sombra
                                blurRadius:
                                    5, // Qué tan difuminada está la sombra
                                offset: Offset(
                                  0,
                                  3,
                                ), // Desplazamiento de la sombra (x, y)
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children:
                                categorias.take(3).map((item) {
                                  return categoria(context, item);
                                }).toList(),
                          ),
                        ),

                        SizedBox(height: 31.h),

                        // CONDICION DE UBICACION CON ZONA y que refresque el home
                        if (ubicacionProvider.dentrodeArea) ...[
                          // NOVEDADES
                          //print("........dentro de area en INCICIOO");
                          Text(
                            "Novedades",
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 23.h),

                          // CARD NOVEDADES
                          Container(
                            height: 172.h,
                            key: _imageKey,
                            //color: Colors.pink,
                            child: ListView.builder(
                              controller: _pageController,
                              scrollDirection: Axis.horizontal,
                              itemCount: primeraMitad.length,
                              itemBuilder: (context, index) {
                                final novedad = primeraMitad[index];

                                return tarjetas(novedad, context);
                              },
                            ),
                          ).animate().flipV(),
                          SizedBox(height: 20.h),

                          // SUBCATEGORIA 1
                          for (
                            int i = 0;
                            i < (categoriaInicio?.subcategorias.length ?? 0);
                            i++
                          ) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        categoriaInicio!
                                                .subcategorias[i]
                                                .nombre ??
                                            'no nombre', // nombre
                                        style: GoogleFonts.manrope(
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      SizedBox(width: 5.w),
                                      Container(
                                        width: 30.w,
                                        height: 30.w,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              categoriaInicio!
                                                      .subcategorias[i]
                                                      .icono ??
                                                  '-',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    categoriaInicio.subcategorias[i];
                                    print("-----------");
                                    print("${categoriaInicio.nombre}");
                                    print(
                                      "${categoriaInicio.subcategorias[i].id}",
                                    );
                                    print(
                                      "${categoriaInicio.subcategorias[i].nombre}",
                                    );
                                    print("-------------");
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
                                    // LLAMADA DE API
                                    final idsubcategoria =
                                        categoriaInicio.subcategorias[i].id;
                                    final zonatrabajocliente =
                                        ubicacionProvider
                                            .allubicaciones
                                            .first
                                            .zonatrabajo_id;
                                    print(
                                      "zona trabajo cliente: $zonatrabajocliente",
                                    );

                                    print("id subcategoria: $idsubcategoria");
                                    await Provider.of<SubcategoriaProvider>(
                                      context,
                                      listen: false,
                                    ).getSubcategoria(
                                      idsubcategoria!,
                                      zonatrabajocliente!,
                                    );

                                    // SALIDA DEL DIÁLOGO ESPERA
                                    Navigator.pop(context);

                                    context.push('/subcategoria');
                                    // se llama a un provider , donde se le pasa el
                                    // id de la subcategori: localhost:20/subacta/{id}
                                  },
                                  child: Text(
                                    "ver más",
                                    style: GoogleFonts.manrope(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h), // Subcategoria 1
                            subcategoria(categoriaInicio!.subcategorias[i]),

                            if (i == 0) ...[
                              SizedBox(height: 50.h),

                              //CONTAINER DE TEMPERATURA
                              Stack(
                                clipBehavior:
                                    Clip.none, // ¡Esto es clave para que el vaso se salga!
                                children: [
                                  // Container base (el rojo)
                                  Container(
                                    width: 1.sw,
                                    height: 140,
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        61,
                                        47,
                                        250,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${tempProvider.temptoday?.temperatura}',
                                          style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 40,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Recuerda',
                                          style: GoogleFonts.manrope(
                                            fontSize: 20.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          'Mantente siempre hidratado',
                                          style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Vaso que se sale del Container
                                  Positioned(
                                    right:
                                        15, // Ajusta este valor según tu diseño
                                    top:
                                        -30, // Puedes moverlo también hacia arriba si quieres
                                    child: Container(
                                      height: 200.w,
                                      width: 140.h,
                                      decoration: BoxDecoration(
                                        //color: Colors.grey,
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                            'lib/assets/imagenes/vaso.png',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 28.h),
                            ],
                          ], // FIN DEL FOR

                          SizedBox(height: 23.h),

                          // NOVEDADES
                          Text(
                            "Novedades",
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 23.h),
                          Container(
                            height: 172.h,

                            //color: Colors.pink,
                            child: ListView.builder(
                              controller: _pageController,
                              scrollDirection: Axis.horizontal,
                              itemCount: segundaMitad.length,
                              itemBuilder: (context, index) {
                                final novedadMitad = segundaMitad[index];

                                return tarjetas(novedadMitad, context);
                              },
                            ),
                          ),
                          SizedBox(height: 5.h),
                          /*Center(
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: 3, // Número de páginas
                            effect: ExpandingDotsEffect(
                              dotHeight: 3.5.h,
                              dotWidth: 15.w,
                              activeDotColor:
                                  const Color.fromARGB(255, 33, 51, 170),
                              dotColor: Colors.grey.shade300,
                            ),
                          ),
                        ),*/
                          SizedBox(height: 30.h),
                          // EXPLORACIÓN
                          Container(
                            height: 100.h,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(1, 37, 255, 1),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 16.r, right: 16.r),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.verified,
                                        size: 30.sp,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        "Explora más productos",
                                        style: GoogleFonts.manrope(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 76.w,
                                    height: 36.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        // Luego navegas
                                        context.push('/allcategoria_sub');
                                      },
                                      child: Text(
                                        "Ver",
                                        style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.5.sp,
                                          color: Color.fromRGBO(1, 37, 255, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 7.h),

                          Transform.translate(
                            offset: Offset(0, 55),
                            child: Container(
                              height: 66.h,
                              decoration: BoxDecoration(
                                //color: const Color.fromRGBO(1, 37, 255, 1),
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 87.w,
                                    height: 87.w,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          'lib/assets/imagenes/logo.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Text(
                                    "! Llevando vida a tu hogar !",
                                    style: GoogleFonts.manrope(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(1, 37, 255, 1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ] else ...[
                          SizedBox(height: 20.h),
                          Center(
                            child: Container(
                              height: 100.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Productos no disponibles en tu ubicacioón",
                                    style: GoogleFonts.manrope(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.warning_amber_rounded,
                                        color: Colors.amber,
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        "Desbes seleccionar otra ubicación",
                                        style: GoogleFonts.manrope(
                                          color: Color.fromRGBO(1, 37, 255, 1),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // CURVA 2 INFERIOR
                curva2(onVolverArriba: _scrollArriba),
              ],
            ),
          ),
          if (carritoProvider.totalItems > 0)
            // CARRITO FLOTANTE
            Positioned(
              bottom: 30.h,
              //right: 20.w,
              left: 80.w,
              child:
                  Container(
                    width: 230.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 238, 48),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 6),
                      ],
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "${carritoProvider.totalItems} agregado(s)",
                            style: GoogleFonts.manrope(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(1, 37, 255, 1),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context.push('/carrito');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Ver",
                                  style: GoogleFonts.manrope(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(1, 37, 255, 1),
                                  ),
                                ),
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Color.fromRGBO(1, 37, 255, 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().shakeX(),
            ),
        ],
      ),
    );
  }
}
