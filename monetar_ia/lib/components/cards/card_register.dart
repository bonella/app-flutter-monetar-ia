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
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    nameFocusNode.dispose();
    lastNameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

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
            _buildInput(widget.nameController, validateName, '',
                isNameField: true,
                currentFocus: nameFocusNode,
                nextFocus: lastNameFocusNode),
            _buildLabel('Sobrenome:', context),
            _buildInput(widget.lastNameController, validateLastName, '',
                isNameField: true,
                currentFocus: lastNameFocusNode,
                nextFocus: emailFocusNode),
            _buildLabel('E-mail:', context),
            _buildInput(widget.emailController, validateEmail, '',
                currentFocus: emailFocusNode, nextFocus: passwordFocusNode),
            _buildLabel('Senha:', context),
            _buildInput(widget.passwordController, validatePassword, '',
                currentFocus: passwordFocusNode,
                nextFocus: confirmPasswordFocusNode),
            _buildLabel('Confirmar Senha:', context),
            _buildInput(
                widget.confirmPasswordController,
                (value) => validateConfirmPassword(
                    widget.passwordController.text, value),
                '',
                currentFocus: confirmPasswordFocusNode,
                nextFocus: null),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
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

  Widget _buildInput(
    TextEditingController controller,
    String? Function(String?) validator,
    String hint, {
    required FocusNode currentFocus,
    FocusNode? nextFocus,
    bool isNameField = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: controller,
        focusNode: currentFocus,
        textCapitalization:
            isNameField ? TextCapitalization.words : TextCapitalization.none,
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
        textInputAction:
            nextFocus != null ? TextInputAction.next : TextInputAction.done,
        onFieldSubmitted: (_) {
          if (nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          } else {
            FocusScope.of(context).unfocus();
          }
        },
      ),
    );
  }
}
