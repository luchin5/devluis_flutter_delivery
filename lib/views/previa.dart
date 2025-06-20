import 'package:app2025_final/providers/cliente_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Previa extends StatefulWidget {
  const Previa({Key? key}) : super(key: key);

  @override
  State<Previa> createState() => _PreviaState();
}

class _PreviaState extends State<Previa> {
  final PageController _pageController =
      PageController(); // Controlador para el PageView
  bool _hasAnimated = false; // Para asegurarnos de que se ejecute solo una vez

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
    final clienteProvider = Provider.of<ClienteProvider>(
      context,
      listen: false,
    );
    /*
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final clienteId = clienteProvider.clienteActual?.cliente?.id;

      if (clienteId != null) {
        Provider.of<UbicacionProvider>(context, listen: false)
            .getUbicaciones(clienteId);
      } else {
        print('⚠️ clienteId es null. No se pudo cargar ubicaciones.');
      }
    });*/
  }

  void _startAutoScroll() async {
    for (int i = 1; i < 3; i++) {
      await Future.delayed(Duration(seconds: 4));
      if (!mounted) return;
      _pageController.animateToPage(
        i,
        duration: Duration(milliseconds: 3000),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 85.h), // Espaciado superior
            Container(
              // color: Colors.red,
              height: 500.h,
              width: 310.w,
              child: PageView(
                controller: _pageController,
                children: [
                  _buildPage(
                    "lib/assets/imagenes/logo.png",
                    "Bienvenido",
                    "a SolVida",
                    "y su gran familia.",
                    "Un lugar lleno de vida, para ti y tu familia.",
                  ),
                  _buildPage(
                    "lib/assets/imagenes/humanbidon.png",
                    "Delivery",
                    "totalmente gratis",
                    "estés donde éstes.",
                    "Siempre con la mejor atención al ciente",
                  ),
                  _buildPage(
                    "lib/assets/imagenes/bodegon.png",
                    "Con los mejores",
                    "productos",
                    "para ti",
                    "Todo a un click de distancia y con buenos precios",
                  ),
                ],
              ),
            ),
            SizedBox(height: 51.h),

            // Indicador de página
            SmoothPageIndicator(
              controller: _pageController,
              count: 3, // Número de páginas
              effect: ExpandingDotsEffect(
                dotHeight: 8.h,
                dotWidth: 8.w,
                activeDotColor: Colors.black,
                dotColor: Colors.grey,
              ),
            ),

            SizedBox(height: 81.h),
            Center(
              child: Container(
                width: 350.w,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () async {
                    /* final ruta = await context
                          .read<IniciarappProvider>()
                          .determinarRutaInicial(context);*/
                    context.go('/location');
                    // context.go('/barracliente');
                  },
                  style: ElevatedButton.styleFrom(
                    shadowColor: const Color.fromARGB(255, 116, 116, 116),
                    backgroundColor: Color.fromRGBO(1, 37, 255, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  child: Text(
                    "Comenzar",
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir cada página
  Widget _buildPage(
    String imagePath,
    String frase1,
    String frase2,
    String frase3,
    String mensaje,
  ) {
    return Container(
      //color: Colors.blue,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 200.w,
              height: 300.h,
              decoration: BoxDecoration(
                //color: Colors.grey,
                image: DecorationImage(image: AssetImage(imagePath)),
              ),
            ),
          ),
          SizedBox(height: 32.h),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "${frase1}\n",
                  style: GoogleFonts.manrope(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "${frase2}\n",
                  style: GoogleFonts.manrope(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "${frase3}",
                  style: GoogleFonts.manrope(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 7.h),
          Text(
            mensaje,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
