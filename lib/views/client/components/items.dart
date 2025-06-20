import 'package:app2025_final/providers/carrito_provider.dart';
import 'package:app2025_final/providers/detalleproducto_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ItemCarrito extends StatefulWidget {
  final dynamic producto;
  final int index;
  const ItemCarrito({super.key, required this.producto, required this.index});

  @override
  State<ItemCarrito> createState() => _ItemCarritoState();
}

class _ItemCarritoState extends State<ItemCarrito> {
  @override
  Widget build(BuildContext context) {
    final carritoProvider = context.watch<CarritoProvider>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 119.h,
          width: 1.sw - 130.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Provider.of<DetalleProductoProvider>(
                        context,
                        listen: false,
                      ).cargar(widget.producto);
                      context.push('/detalle_producto');
                    },
                    child: Container(
                      width: 55.w,
                      height: 55.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.producto.fotos[0]),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.producto.nombre}",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "S/.${widget.producto.precio}",
                            style: GoogleFonts.manrope(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          widget.producto.descuento! > 0
                              ? Container(
                                height: 30.h,
                                width: 60.w,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(1, 37, 255, 1),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Center(
                                  child: Text(
                                    "${widget.producto.descuento}%",
                                    style: GoogleFonts.manrope(
                                      fontSize: 12.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 140.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (widget.producto.cantidad > 1)
                            carritoProvider.decrementar(widget.index);
                        });
                      },
                      icon: Icon(Icons.remove),
                    ),
                    Text(
                      "${widget.producto.cantidad}",
                      style: GoogleFonts.manrope(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      color: Color.fromRGBO(1, 37, 255, 1),
                      onPressed: () {
                        setState(() {
                          if (widget.producto.cantidad < 99)
                            carritoProvider.incrementar(widget.index);
                        });
                      },
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            carritoProvider.deleteProducto(widget.index);
          },
          icon: Icon(Icons.delete_outline),
        ),
      ],
    );
  }
}
