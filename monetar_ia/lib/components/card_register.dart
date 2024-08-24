import 'package:flutter/material.dart';

class CardRegister extends StatelessWidget {
  const CardRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: double.infinity,
      width: MediaQuery.of(context).size.width *
          1, // Ajusta a largura do card para 90% da largura da tela
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildLabel('Nome:', context),
            _buildInput(context),
            const SizedBox(height: 20),
            _buildLabel('Sobrenome:', context),
            _buildInput(context),
            const SizedBox(height: 20),
            _buildLabel('CPF:', context),
            _buildInput(context),
            const SizedBox(height: 20),
            _buildLabel('Salário:', context),
            _buildInput(context),
            const SizedBox(height: 20),
            _buildLabel('E-mail:', context),
            _buildInput(context),
            const SizedBox(height: 20),
            _buildLabel('Senha:', context),
            _buildInput(context, hasBottomMargin: true), //
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, BuildContext context) {
    return SizedBox(
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Kumbh Sans',
          fontWeight: FontWeight.w400,
          fontSize: 18,
          color: Color(0xFF3D5936),
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildInput(BuildContext context, {bool hasBottomMargin = false}) {
    return Container(
      margin: hasBottomMargin
          ? const EdgeInsets.only(bottom: 40.0)
          : EdgeInsets.zero,
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(
              color: Color(0xFF3D5936),
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(
              color: Color(0xFF738C61),
              width: 2.0,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
      ),
    );
  }
}
