import 'package:flutter/material.dart';
import 'package:monetar_ia/services/request_http.dart';

class ChangePasswordPopup extends StatefulWidget {
  const ChangePasswordPopup({super.key});

  @override
  _ChangePasswordPopupState createState() => _ChangePasswordPopupState();
}

class _ChangePasswordPopupState extends State<ChangePasswordPopup> {
  final _formKey = GlobalKey<FormState>();
  String newPassword = '';
  String confirmPassword = '';
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final RequestHttp _requestHttp = RequestHttp();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Center(
            child: ClipOval(
              child: Image.asset(
                'lib/assets/logo2.png',
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Alterar Senha',
              style: TextStyle(color: Color(0xFF003566)),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: newPasswordController,
                hint: "Nova Senha",
                onChanged: (value) => newPassword = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nova senha é obrigatória';
                  }
                  if (value.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: confirmPasswordController,
                hint: "Confirme a Nova Senha",
                onChanged: (value) => confirmPassword = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirmação de senha é obrigatória';
                  }
                  if (value != newPassword) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
                obscureText: true,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Color(0xFF003566)),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text(
            'Alterar Senha',
            style: TextStyle(color: Color(0xFF003566)),
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              // Lógica para alterar a senha
              await _requestHttp.changePassword(newPassword);
              Navigator.of(context).pop();
              // Aqui você pode mostrar um alerta de sucesso ou redirecionar
            }
          },
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(16),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required ValueChanged<String> onChanged,
    String? Function(String?)? validator,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 99, 99, 99)),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 99, 99, 99)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}
