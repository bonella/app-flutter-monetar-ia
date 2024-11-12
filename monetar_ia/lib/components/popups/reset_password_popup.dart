import 'package:flutter/material.dart';
import 'package:monetar_ia/services/request_http.dart';
import 'package:monetar_ia/components/popups/enter_code_popup.dart';
import 'package:monetar_ia/utils/form_validations.dart';

class ResetPasswordPopup extends StatefulWidget {
  const ResetPasswordPopup({super.key});

  @override
  _ResetPasswordPopupState createState() => _ResetPasswordPopupState();
}

class _ResetPasswordPopupState extends State<ResetPasswordPopup> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String? _emailError;
  final TextEditingController emailController = TextEditingController();
  final RequestHttp _requestHttp = RequestHttp();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _emailError = null;
      });

      try {
        final response = await _requestHttp.requestPasswordResetCode(email);

        if (response.statusCode == 200) {
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (context) {
              return EnterCodePopup(email: email);
            },
          );
        } else if (response.statusCode == 404) {
          setState(() {
            _emailError = 'E-mail não cadastrado';
            _formKey.currentState!.validate();
          });
        } else {
          // Outros erros (ex: 500, 422, etc.)
          setState(() {
            _emailError = 'Erro ao enviar código. Tente novamente.';
            _formKey.currentState!.validate();
          });
        }
      } catch (error) {
        setState(() {
          _emailError = 'Erro ao conectar ao servidor';
          _formKey.currentState!.validate();
        });
      }
    }
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
              'Esqueceu a senha?',
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
                controller: emailController,
                hint: "Digite seu e-mail",
                onChanged: (value) => email = value,
                validator: (value) {
                  final validationError = validateEmail(value);
                  return validationError ?? _emailError;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF003566)),
              ),
            ),
            TextButton(
              onPressed: _sendResetCode,
              child: const Text(
                'Enviar E-mail',
                style: TextStyle(color: Color(0xFF003566)),
              ),
            ),
          ],
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
  }) {
    return TextFormField(
      controller: controller,
      onChanged: (value) {
        setState(() {
          _emailError = null;
        });
        onChanged(value);
      },
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 99, 99, 99)),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: _emailError != null
                ? const Color(0xFFB22222)
                : const Color.fromARGB(255, 99, 99, 99),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: _emailError != null ? const Color(0xFFB22222) : Colors.black,
            width: 2,
          ),
        ),
      ),
      validator: validator,
    );
  }
}
