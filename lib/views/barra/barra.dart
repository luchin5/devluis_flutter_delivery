import 'package:app2025_final/providers/notificacion_provider.dart';
import 'package:app2025_final/views/client/cupones.dart';
import 'package:app2025_final/views/client/inicio2.dart';
import 'package:app2025_final/views/client/notificaciones.dart';
import 'package:app2025_final/views/client/ordenes.dart';
import 'package:app2025_final/views/client/perfil.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BarraNavegacion extends StatefulWidget {
  const BarraNavegacion({Key? key}) : super(key: key);

  @override
  State<BarraNavegacion> createState() => _BarraNavegacionState();
}

class _BarraNavegacionState extends State<BarraNavegacion> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = const [
    Inicio2(),
    Ordenes(),
    Cupones(),
    Notificaciones(),
    Perfil(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notificacion = context.watch<NotificacionProvider>();
    print("....BARRITA");
    return Scaffold(
      bottomNavigationBar: ConvexAppBar.badge(
        // Si ya fue leído, no se muestra el badge
        notificacion.cant > 0 ? {3: '${notificacion.cant}'} : {},
        style: TabStyle.reactCircle,
        //  curveSize: 2.0,
        badgeMargin: EdgeInsets.only(bottom: 18, left: 20),
        backgroundColor: Colors.white, //Color.fromRGBO(1, 37, 255, 1),
        color: Color.fromRGBO(1, 37, 255, 1), //Colors.white,
        activeColor: Color.fromRGBO(1, 37, 255, 1),
        items: [
          TabItem(icon: Icons.home_outlined),
          TabItem(icon: Icons.assignment_outlined),
          TabItem(icon: Icons.style_outlined),
          TabItem(icon: Icons.notifications_outlined),
          TabItem(icon: Icons.person_outline),
        ],
        initialActiveIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
    );
  }
}
