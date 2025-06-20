import 'package:app2025_final/models/producto_model.dart';
import 'package:app2025_final/models/promocion_model.dart';
import 'package:app2025_final/providers/carrito_provider.dart';
import 'package:app2025_final/providers/subcategoria_provider.dart';
import 'package:app2025_final/views/client/components/subcategorias/tarjeta_sub.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SubCategoria extends StatefulWidget {
  const SubCategoria({Key? key}) : super(key: key);

  @override
  State<SubCategoria> createState() => _SubCategoriaState();
}

class _SubCategoriaState extends State<SubCategoria> {
  int selectedIndex = 0;
  List<dynamic> todoslosProductos = [];

  // final List<String> chips = ['Todos', 'promocion', 'producto'];
  @override
  Widget build(BuildContext context) {
    final seccionSub =
        context.watch<SubcategoriaProvider>().allproductossubcategoria;
    final promociones = seccionSub?.promociones;
    final productos = seccionSub?.productos;
    todoslosProductos = [
      if (productos != null) ...productos,
      if (promociones != null) ...promociones,
    ];

    final carritoProvider = context.watch<CarritoProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      // APP BAR + CARRITO
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${seccionSub?.nombre}',
              style: GoogleFonts.manrope(fontSize: 16.sp),
            ),
            Container(
              width: 30.w,
              height: 30.h,
              decoration: BoxDecoration(
                //color: Colors.amber,
                image: DecorationImage(
                  image: NetworkImage(
                    seccionSub?.icono ?? 'https://via.placeholder.com/150',
                  ),
                ),
              ),
            ),
            SizedBox(width: 1.sw - 290.0.w),
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
      body: Padding(
        padding: EdgeInsets.only(left: 27.r, top: 0.r, right: 27.r),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 23.h),

              // CUERPO DEL GRID
              //Text("Productos y Promociones"),
              Container(
                //color: Colors.amber,
                height: 1.sh - 150.h,
                child: GridView.count(
                  crossAxisCount: 2, // 2 columnas
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 5,
                  childAspectRatio: 175 / 350, // alto/anchura
                  children: List.generate(todoslosProductos.length, (index) {
                    final actualProducto = todoslosProductos[index];
                    if (actualProducto is ProductoModel) {
                      return tarjeta_sub(
                        context: context,
                        //  sub_nombre: seccionSub!.nombre,
                        alto: 350,
                        ancho: 175,
                        separacion_tarjeta: 0,
                        ima_alto: 200,
                        ima_ancho: 200,
                        item: actualProducto,
                        cajatextoalto: 75,
                        cajatextoancho: 130,
                      );
                    } else if (actualProducto is PromocionModel) {
                      return tarjeta_sub(
                        context: context,
                        // sub_nombre: seccionSub!.nombre,
                        alto: 350,
                        ancho: 175,
                        separacion_tarjeta: 0,
                        ima_alto: 200,
                        ima_ancho: 200,
                        item: actualProducto,
                        cajatextoalto: 75,
                        cajatextoancho: 130,
                      );
                    } else {
                      // fallback por si viene un tipo inesperado
                      return const SizedBox.shrink();
                    }

                    //return tarjeta_sub(context, 300, 169, 0, 200, 200);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
