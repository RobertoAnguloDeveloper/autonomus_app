import 'package:flutter/material.dart';

class MapCard extends StatelessWidget {
  double duration,distance; // Duración de la ruta en segundos

  MapCard(this.duration, this.distance, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 0, 0, 0),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Duración: $duration minutos',
            style: const TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Distancia: $distance metros',
            style: const TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      ));
  }
}
