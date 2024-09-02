import 'package:flutter/material.dart';

class CardRegister extends StatelessWidget {
  const CardRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildLabel('Nome:', context),
                _buildInput(context),
                _buildLabel('Sobrenome:', context),
                _buildInput(context),
                _buildLabel('CPF:', context),
                _buildInput(context),
                _buildLabel('Salário:', context),
                _buildInput(context),
                _buildLabel('E-mail:', context),
                _buildInput(context),
                _buildLabel('Senha:', context),
                _buildInput(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Kumbh Sans',
        fontWeight: FontWeight.w400,
        fontSize: 18,
        color: Color(0xFF3D5936),
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildInput(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        ),
      ),
    );
  }
}
