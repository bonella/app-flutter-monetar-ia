import 'package:flutter/material.dart';
import 'package:monetar_ia/services/request_http.dart';
import 'package:monetar_ia/components/popups/change_password_popup.dart';

class EnterCodePopup extends StatefulWidget {
  final String email;

  const EnterCodePopup({super.key, required this.email});

  @override
  _EnterCodePopupState createState() => _EnterCodePopupState();
}

class _EnterCodePopupState extends State<EnterCodePopup> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final RequestHttp _requestHttp = RequestHttp();
  String? errorMessage;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _validateCodeAndProceed() async {
    setState(() {
      errorMessage = null;
    });

    bool isAnyFieldEmpty =
        _controllers.any((controller) => controller.text.isEmpty);

    if (isAnyFieldEmpty) {
      _setErrorMessage("Favor preencher todos os campos");
      return;
    }

    if (_formKey.currentState!.validate()) {
      final code = _controllers.map((c) => c.text).join();

      try {
        final response =
            await _requestHttp.validateResetCode(widget.email, int.parse(code));

        if (response.statusCode == 200) {
          Navigator.of(context).pop();

          showDialog(
            context: context,
            builder: (context) => ChangePasswordPopup(email: widget.email),
          );
        }
      } catch (e) {
        String errorMsg = e.toString();
        if (errorMsg.contains("Código inválido ou expirado")) {
          _setErrorMessage("O código inserido é inválido ou expirou.");
        } else {
          _setErrorMessage("Erro ao validar o código. Tente novamente.");
        }
      }
    }
  }

  void _setErrorMessage(String message) {
    setState(() {
      errorMessage = message;
    });
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
              'Inserir Código',
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
            children: [
              const SizedBox(height: 20),
              _buildCodeInputFields(),
              const SizedBox(height: 20),
              if (errorMessage != null)
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(
                      color: Color(0xFFB22222),
                      fontSize: 12,
                    ),
                  ),
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
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF003566)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: _validateCodeAndProceed,
              child: const Text(
                'Validar Código',
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

  Widget _buildCodeInputFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 40,
          height: 50,
          child: TextFormField(
            controller: _controllers[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF003566)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xFF003566), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xFFB22222), width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xFFB22222), width: 2),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                FocusScope.of(context).nextFocus();
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).previousFocus();
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Campo obrigatório';
              }
              return null;
            },
          ),
        );
      }),
    );
  }
}
