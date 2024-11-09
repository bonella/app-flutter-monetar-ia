import 'package:flutter/material.dart';
import 'package:monetar_ia/utils/form_validations.dart';

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

  final ScrollController _scrollController = ScrollController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    nameFocusNode.addListener(() => _scrollToFocusedField(nameFocusNode));
    lastNameFocusNode
        .addListener(() => _scrollToFocusedField(lastNameFocusNode));
    emailFocusNode.addListener(() => _scrollToFocusedField(emailFocusNode));
    passwordFocusNode
        .addListener(() => _scrollToFocusedField(passwordFocusNode));
    confirmPasswordFocusNode
        .addListener(() => _scrollToFocusedField(confirmPasswordFocusNode));
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    lastNameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToFocusedField(FocusNode focusNode) {
    if (focusNode.hasFocus) {
      final renderBox = focusNode.context?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final offset = renderBox.localToGlobal(Offset.zero).dy;
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

        if (offset + renderBox.size.height >
            MediaQuery.of(context).size.height - keyboardHeight) {
          _scrollController.animateTo(
            offset +
                renderBox.size.height -
                (MediaQuery.of(context).size.height - keyboardHeight),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildInput(widget.nameController, validateName, 'Nome',
                  nameFocusNode, lastNameFocusNode, true),
              _buildInput(widget.lastNameController, validateLastName,
                  'Sobrenome', lastNameFocusNode, emailFocusNode, true),
              _buildInput(widget.emailController, validateEmail, 'E-mail',
                  emailFocusNode, passwordFocusNode),
              _buildPasswordInput(
                  widget.passwordController,
                  validatePassword,
                  isPasswordVisible,
                  passwordFocusNode,
                  confirmPasswordFocusNode,
                  'Senha',
                  true),
              _buildPasswordInput(
                  widget.confirmPasswordController,
                  (value) => validateConfirmPassword(
                      widget.passwordController.text, value),
                  isConfirmPasswordVisible,
                  confirmPasswordFocusNode,
                  null,
                  'Confirmar Senha',
                  false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String? Function(String?) validator,
    String hint,
    FocusNode currentFocus,
    FocusNode? nextFocus, [
    bool capitalize = false,
  ]) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        focusNode: currentFocus,
        textCapitalization:
            capitalize ? TextCapitalization.words : TextCapitalization.none,
        decoration: InputDecoration(
          labelText: hint,
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
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFF003566), width: 2),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        validator: validator,
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

  Widget _buildPasswordInput(
    TextEditingController controller,
    String? Function(String?) validator,
    bool isVisible,
    FocusNode currentFocus,
    FocusNode? nextFocus,
    String label,
    bool isPrimaryPassword,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        focusNode: currentFocus,
        obscureText: !isVisible,
        decoration: InputDecoration(
          labelText: label,
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                if (isPrimaryPassword) {
                  isPasswordVisible = !isPasswordVisible;
                } else {
                  isConfirmPasswordVisible = !isConfirmPasswordVisible;
                }
              });
            },
          ),
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
            borderSide: const BorderSide(
              color: Color(0xFF003566),
              width: 2.0,
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        validator: validator,
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
