import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 361,
      height: 396,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF3D5936), width: 2),
      ),
      child: const Center(
        child: Text('Gráfico aqui'),
      ),
    );
  }
}
