import 'package:app2025_final/providers/carrito_provider.dart';
import 'package:app2025_final/providers/categoria_inicio_provider.dart';
import 'package:app2025_final/providers/subcategoria_provider.dart';
import 'package:app2025_final/providers/ubicacion_provider.dart';
import 'package:app2025_final/views/client/components/subcategorias/subcategoria.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Completacategoria extends StatefulWidget {
  const Completacategoria({Key? key}) : super(key: key);

  @override
  State<Completacategoria> createState() => _CompletacategoriaState();
}

class _CompletacategoriaState extends State<Completacategoria> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Llama una vez para obtener los eventos
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final categoriaProvider = Provider.of<CategoriaInicioProvider>(
        context,
        listen: false,
      );

      final zonatrabajoid = categoriaProvider.zonaTrabajoId;
      final categoriaiD = categoriaProvider.categoriaIdSeleccionada;

      if (categoriaiD != null && zonatrabajoid != null) {
        await categoriaProvider.getCategoriaCompleta(
          categoriaiD,
          zonatrabajoid,
        );
      }

      // Espera 500ms antes de mostrar el contenido final
      await Future.delayed(Duration(milliseconds: 500));

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoriaInicio =
        context.watch<CategoriaInicioProvider>().todolacategoriacompleta;
    final ubicacionProvider = context.watch<UbicacionProvider>();
    final carritoProvider = context.watch<CarritoProvider>();
    // Mostrar loader si isLoading o datos aún no llegaron
    if (isLoading || categoriaInicio == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${categoriaInicio?.nombre}",
              style: GoogleFonts.manrope(fontSize: 14.sp),
            ),
            badges.Badge(
              position: badges.BadgePosition.topEnd(top: -1, end: -1),
              badgeContent: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  '${carritoProvider.totalItems}',
                  style: GoogleFonts.manrope(
                    color: Color.fromRGBO(1, 37, 255, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              showBadge: carritoProvider.totalItems > 0 ? true : false,
              badgeStyle: badges.BadgeStyle(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: Color.fromRGBO(1, 37, 255, 1),
                  width: 2,
                ),
                badgeColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              child: IconButton(
                onPressed: () {
                  context.push('/carrito');
                  print("Carrita");
                },
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  size: 25.sp,
                  color: Color.fromRGBO(0, 0, 0, 1),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            children: [
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
                            "${categoriaInicio?.subcategorias[i].nombre}", // nombre
                            style: GoogleFonts.manrope(fontSize: 16.sp),
                          ),
                          SizedBox(width: 10.w),
                          Container(
                            width: 30.w,
                            height: 30.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  categoriaInicio!.subcategorias[i].icono ??
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
                        categoriaInicio?.subcategorias[i];

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
                            categoriaInicio?.subcategorias[i].id;
                        final zonatrabajocliente =
                            ubicacionProvider
                                .allubicaciones
                                .first
                                .zonatrabajo_id;
                        await Provider.of<SubcategoriaProvider>(
                          context,
                          listen: false,
                        ).getSubcategoria(idsubcategoria!, zonatrabajocliente);

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

                /*if (i == 0) ...[*/
                SizedBox(height: 10.h),

                //CONTAINER DE TEMPERATURA
                /*
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
                        color: const Color.fromARGB(255, 216, 186, 125),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('21°C',
                              style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 40,
                                  color: Colors.white)),
                          Text('¡Qué calor!',
                              style: GoogleFonts.manrope(
                                  fontSize: 20.sp, color: Colors.white)),
                          Text('Mantente siempre hidratado',
                              style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                  color: Colors.white70)),
                        ],
                      ),
                    ),

                    // Vaso que se sale del Container
                    Positioned(
                      right: 15, // Ajusta este valor según tu diseño
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
                                    'lib/assets/imagenes/vaso.png'))),
                      ),
                    ),
                  ],
                ),*/
              ],
              //   ], //
            ],
          ),
        ),
      ),
    );
  }
}
