import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: const Color(0xFF738C61),
      ),
      body: const Center(
        child: Text(
          'Página de Perfil',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
