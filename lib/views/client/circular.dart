import 'dart:async';
import 'package:flutter/material.dart';

class ListaCircular extends StatefulWidget {
  @override
  _ListaCircularState createState() => _ListaCircularState();
}

class _ListaCircularState extends State<ListaCircular> {
  final List<int> _elementos = [1, 2, 3];
  late PageController _controladorPagina;
  late Timer _temporizador;
  int _indiceActual = 0;

  @override
  void initState() {
    super.initState();
    _controladorPagina = PageController(initialPage: _indiceActual);
    _iniciarDesplazamientoAutomatico();
  }

  @override
  void dispose() {
    _temporizador.cancel();
    _controladorPagina.dispose();
    super.dispose();
  }

  void _iniciarDesplazamientoAutomatico() {
    _temporizador = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_indiceActual < _elementos.length - 1) {
        _indiceActual++;
      } else {
        _indiceActual = 0;
      }

      _controladorPagina.animateToPage(
        _indiceActual,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista Circular con Fade'),
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 800),
        child: PageView.builder(
          key: ValueKey<int>(_indiceActual),
          controller: _controladorPagina,
          scrollDirection: Axis.horizontal,
          itemCount: _elementos.length,
          itemBuilder: (context, index) {
            return Container(
              key: ValueKey<int>(_elementos[index]),
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              color: Colors.amber,
              alignment: Alignment.center,
              child: Text(
                'Elemento ${_elementos[index]}',
                style: TextStyle(fontSize: 24.0),
              ),
            );
          },
        ),
      ),
    );
  }
}
