import 'package:flutter/material.dart';
import 'package:monetar_ia/services/form_validations.dart';

class CardRegister extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const CardRegister({
    super.key,
    required this.nameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  _CardRegisterState createState() => _CardRegisterState();
}

class _CardRegisterState extends State<CardRegister> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildLabel('Nome:', context),
            _buildInput(widget.nameController, validateName, ''),
            _buildLabel('Sobrenome:', context),
            _buildInput(widget.lastNameController, validateSurname, ''),
            _buildLabel('E-mail:', context),
            _buildInput(widget.emailController, validateEmail, ''),
            _buildLabel('Senha:', context),
            _buildInput(widget.passwordController, validatePassword, ''),
            _buildLabel('Confirmar Senha:', context),
            _buildInput(
                widget.confirmPasswordController,
                (value) => validateConfirmPassword(
                    widget.passwordController.text, value),
                ''),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
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

  Widget _buildInput(TextEditingController controller,
      String? Function(String?) validator, String hint) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
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
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(
              color: Color(0xFF738C61),
              width: 2.0,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        ),
        validator: validator,
        obscureText: hint == 'Senha' || hint == 'Confirmar Senha',
      ),
    );
  }
}
