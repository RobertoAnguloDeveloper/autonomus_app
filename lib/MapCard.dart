import 'package:flutter/material.dart';

class MapCard extends StatelessWidget {
  double duration; // Duración de la ruta en segundos

  MapCard(this.duration, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Text('Duración de la ruta $duration minutos',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )));
  }
}
