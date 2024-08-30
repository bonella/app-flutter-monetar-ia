import 'package:flutter/material.dart';

class VoicePage extends StatelessWidget {
  const VoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página de Voz'),
        backgroundColor: const Color(0xFF738C61),
      ),
      body: const Center(
        child: Text(
          'Página de Voz',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
