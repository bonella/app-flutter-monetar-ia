import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final String label;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool autoFocus;
  final bool capitalize;
  final bool obscureText;
  final Function(String)? onFieldSubmitted;
  final IconButton? suffixIcon;
  final bool enabled; // Parâmetro adicionado

  const CustomTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    required this.label,
    this.validator,
    this.isPassword = false,
    this.autoFocus = false,
    this.capitalize = false,
    this.obscureText = false,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.enabled = true, // Valor padrão como true
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool isPasswordVisible;

  @override
  void initState() {
    super.initState();
    isPasswordVisible = widget.obscureText; // Inicializa o estado da senha
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: widget.isPassword &&
            !isPasswordVisible, // Controla se a senha está oculta
        textCapitalization: widget.capitalize
            ? TextCapitalization.words
            : TextCapitalization.none,
        decoration: InputDecoration(
          labelText: widget.label,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF3D5936),
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF3D5936),
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF003566), width: 2.0),
          ),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          // Exibe o ícone de olho apenas se for um campo de senha
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible =
                          !isPasswordVisible; // Alterna o estado da visibilidade
                    });
                  },
                )
              : widget.suffixIcon,
        ),
        validator: widget.validator,
        textInputAction: widget.nextFocusNode != null
            ? TextInputAction.next
            : TextInputAction.done,
        onFieldSubmitted: (value) {
          if (widget.onFieldSubmitted != null) {
            widget.onFieldSubmitted!(value);
          }
          if (widget.nextFocusNode != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          } else {
            FocusScope.of(context).unfocus();
          }
        },
        enabled: widget.enabled, // Aqui você controla se o campo é editável
      ),
    );
  }
}
