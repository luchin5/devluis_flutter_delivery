import 'package:app2025_final/models/promocion_model.dart';
import 'package:app2025_final/providers/carrito_provider.dart';
import 'package:app2025_final/providers/cliente_provider.dart';
import 'package:app2025_final/providers/detalleproducto_provider.dart';
import 'package:app2025_final/views/client/components/opiniones.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DetalleProducto extends StatefulWidget {
  const DetalleProducto({Key? key}) : super(key: key);

  @override
  State<DetalleProducto> createState() => _DetalleProductoState();
}

class _DetalleProductoState extends State<DetalleProducto> {
  int contador = 1;
  double _calificacion = 3;

  @override
  Widget build(BuildContext context) {
    final productogenerico = context.watch<DetalleProductoProvider>().item;
    return Scaffold(
      backgroundColor: Colors.white,
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
          child: GestureDetector(
            onTap: () {
              print("atrasito");
            },
            child: Icon(Icons.arrow_back_ios, size: 13.sp),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Detalle del producto',
              style: GoogleFonts.manrope(fontSize: 16.sp),
            ),
            badges.Badge(
              position: badges.BadgePosition.topEnd(top: -1, end: -1),
              badgeContent: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  '${Provider.of<CarritoProvider>(context, listen: false).totalItems}',
                  style: GoogleFonts.manrope(
                    color: Color.fromRGBO(1, 37, 255, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              showBadge:
                  Provider.of<CarritoProvider>(
                            context,
                            listen: true,
                          ).totalItems >
                          0
                      ? true
                      : false,
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
          padding: EdgeInsets.only(left: 25.r, right: 25.r, top: 21.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text:
                          productogenerico is PromocionModel
                              ? "Promoción\n"
                              : null,
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w200,
                        fontSize: 50.sp,
                      ),
                    ),
                    TextSpan(
                      text: "${productogenerico.nombre}",
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.bold,
                        fontSize: 50.sp,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.sp),
              Container(
                // width: 327.w,
                height: 221.h,
                decoration: BoxDecoration(
                  //color: Colors.amber,
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: NetworkImage('${productogenerico?.fotos[0]}'),
                  ),
                ),
              ),
              SizedBox(height: 15.sp),
              Container(
                height: 36.h,
                child: Row(
                  mainAxisAlignment:
                      productogenerico.descuento > 0
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.spaceEvenly,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'S/.${productogenerico?.precio} PEN/',
                            style: GoogleFonts.manrope(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(1, 37, 255, 1),
                            ),
                          ),
                          /* TextSpan(
                          text: '${productogenerico.item.tipo_empaque ?? '-/-'}',
                          style: GoogleFonts.manrope(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w300,
                              color: Color.fromRGBO(1, 37, 255, 1)))*/
                        ],
                      ),
                    ),
                    productogenerico?.descuento > 0
                        ? Container(
                          height: 36.h,
                          padding: EdgeInsets.only(left: 8, right: 8),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(1, 37, 255, 1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Center(
                            child: Text(
                              "S/.${productogenerico?.descuento} DCTO",
                              style: GoogleFonts.manrope(
                                color: Colors.white,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                        )
                        : SizedBox.shrink(),
                    Text(
                      "Reg: S/.${productogenerico?.precio_regular} PEN",
                      style: GoogleFonts.manrope(
                        color: const Color.fromARGB(255, 136, 136, 136),
                        fontSize: 15.sp,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 56.h,
                    width: 115.0.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Colors.white,
                      border: Border.all(
                        width: 2,
                        color: Color.fromRGBO(1, 37, 255, 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (productogenerico.cantidad > 1) {
                                productogenerico.cantidad--;
                              }
                            });
                          },
                          icon: Icon(Icons.remove, size: 20.sp),
                        ),
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "${productogenerico.cantidad}",
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (productogenerico.cantidad < 99) {
                                productogenerico.cantidad++;
                              }
                            });
                          },
                          icon: Icon(Icons.add, size: 20.sp),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 56.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Colors.white,
                      border: Border.all(
                        width: 2,
                        color: Color.fromRGBO(1, 37, 255, 1),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Provider.of<CarritoProvider>(
                          context,
                          listen: false,
                        ).agregarProducto(productogenerico);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            15.r,
                          ), // Bordes completamente rectos
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          "Añadir al\n carrito",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: Color.fromRGBO(1, 37, 255, 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 56.h,
                    width: 120.w,
                    child: ElevatedButton(
                      onPressed: () {
                        context.push('/carrito');
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            15.r,
                          ), // Bordes completamente rectos
                        ),
                        backgroundColor: Color.fromRGBO(1, 37, 255, 1),
                      ),
                      child: Text(
                        "Pagar ahora",
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Text(
                "Detalles",
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                //padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  // color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  "${productogenerico.descripcion}",
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "Opiniones",
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                ),
              ),
              Container(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      //height: 24.h,
                      width: 54.w,
                      child: Text(
                        "${productogenerico?.valoracion}",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                          fontSize: 34.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RatingBar.builder(
                          itemSize: 22.sp,
                          initialRating: productogenerico.valoracion ?? 5.0,
                          minRating: 1,
                          unratedColor: Colors.black,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                          itemBuilder:
                              (context, _) =>
                                  Icon(Icons.star_rounded, color: Colors.amber),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                        Text(
                          "${productogenerico.totalclientecalificacion} Opiniones",
                          style: GoogleFonts.manrope(
                            fontSize: 15.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: SizedBox()),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, color: Colors.grey),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Container(
                                    height: 1.sh / 2.1,
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 120.w,
                                          width: 120.w,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.contain,
                                              image: AssetImage(
                                                'lib/assets/imagenes/felicitaciones.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        Text(
                                          "Calificación",
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
                                        SizedBox(height: 10.h),
                                        Text(
                                          "¿Cómo calificarías este producto?",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                        SizedBox(height: 20.h),
                                        RatingBar.builder(
                                          initialRating: _calificacion,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 40.sp,
                                          itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0,
                                          ),
                                          unratedColor: Colors.grey[300],
                                          itemBuilder:
                                              (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                          onRatingUpdate: (rating) {
                                            _calificacion = rating;
                                          },
                                        ),
                                        SizedBox(height: 30.h),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
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
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(
                                                1,
                                                37,
                                                255,
                                                1,
                                              ),
                                            ),
                                          ),
                                          onPressed: () async {
                                            final cliente =
                                                Provider.of<ClienteProvider>(
                                                  context,
                                                  listen: false,
                                                ).clienteActual;
                                            final idcliente =
                                                cliente?.cliente.id;

                                            print(
                                              "...claificacion $_calificacion",
                                            );
                                            await Provider.of<CarritoProvider>(
                                              context,
                                              listen: false,
                                            ).postCalificacion(
                                              idcliente,
                                              productogenerico,
                                              productogenerico.id,
                                              _calificacion,
                                            );
                                            Navigator.of(context).pop();
                                            // Aquí puedes usar `_calificacion` para guardar el voto
                                            print(
                                              "El usuario votó con $_calificacion estrellas.",
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Text(
                            "votar",
                            style: GoogleFonts.manrope(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(1, 37, 255, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                height:
                    productogenerico.totalclientecalificacion > 1
                        ? 300.h
                        : 100.h,
                //color: Colors.amber,
                child: ListView.builder(
                  itemCount: productogenerico.calificaciones.length,
                  itemBuilder: (context, index) {
                    print(
                      ".....TOTAL CALIFICACIONES ${productogenerico.calificaciones.length}",
                    );
                    final productogenericoActual =
                        productogenerico.calificaciones[index];
                    return Column(
                      children: [
                        opiniones(
                          productogenericoActual.nombres,
                          productogenericoActual.apellidos,
                          productogenericoActual.calificacion,
                        ),
                        SizedBox(height: 33.h),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }
}
