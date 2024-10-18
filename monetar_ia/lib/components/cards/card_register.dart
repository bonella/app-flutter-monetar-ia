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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildLabel('Nome:', context),
              _buildInput(widget.nameController, validateName, '',
                  currentFocus: nameFocusNode,
                  nextFocus: lastNameFocusNode,
                  isNameField: true),
              _buildLabel('Sobrenome:', context),
              _buildInput(widget.lastNameController, validateLastName, '',
                  currentFocus: lastNameFocusNode,
                  nextFocus: emailFocusNode,
                  isNameField: true),
              _buildLabel('E-mail:', context),
              _buildInput(widget.emailController, validateEmail, '',
                  currentFocus: emailFocusNode, nextFocus: passwordFocusNode),
              _buildLabel('Senha:', context),
              _buildPasswordInput(
                widget.passwordController,
                validatePassword,
                isPasswordVisible,
                currentFocus: passwordFocusNode,
                nextFocus: confirmPasswordFocusNode,
                toggleVisibility: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
              _buildLabel('Confirmar Senha:', context),
              _buildPasswordInput(
                widget.confirmPasswordController,
                (value) => validateConfirmPassword(
                    widget.passwordController.text, value),
                isConfirmPasswordVisible,
                currentFocus: confirmPasswordFocusNode,
                nextFocus: null,
                toggleVisibility: () {
                  setState(() {
                    isConfirmPasswordVisible = !isConfirmPasswordVisible;
                  });
                },
              ),
            ],
          ),
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
    bool isVisible, {
    required FocusNode currentFocus,
    FocusNode? nextFocus,
    required VoidCallback toggleVisibility,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: controller,
        focusNode: currentFocus,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: toggleVisibility,
          ),
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
        obscureText: !isVisible,
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
