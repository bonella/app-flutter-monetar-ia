import 'package:flutter/material.dart';

class NewRegisterPage extends StatelessWidget {
  const NewRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Registro'),
        backgroundColor: const Color(0xFF738C61),
      ),
      body: const Center(
        child: Text(
          'Página de Novo Registro',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
