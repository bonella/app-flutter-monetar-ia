import 'package:flutter/material.dart';
import 'package:monetar_ia/components/cards/card_register.dart';
import 'package:monetar_ia/components/headers/header_first_steps.dart';
import 'package:monetar_ia/components/footers/footer.dart';
import 'package:monetar_ia/components/buttons/btn_outline_green.dart';
import 'package:monetar_ia/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text;
      final lastName = _lastNameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;
      final confirmPassword = _confirmPasswordController.text;

      try {
        final response = await AuthService().signup(
          name: name,
          lastName: lastName,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
        );
        if (response.statusCode == 200) {
          // Registro bem-sucedido
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cadastro realizado com sucesso!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Erro ao realizar o cadastro: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao se conectar com o servidor: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                const HeaderFirstSteps(
                  title: 'Monetar.ia',
                  subtitle: 'Cadastro',
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const SizedBox(height: 20),
                            CardRegister(
                              nameController: _nameController,
                              lastNameController: _lastNameController,
                              emailController: _emailController,
                              passwordController: _passwordController,
                              confirmPasswordController:
                                  _confirmPasswordController,
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Footer(
                  backgroundColor: Color(0xFF738C61),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width / 2 - 130,
            child: SizedBox(
              width: 260,
              child: BtnOutlineGreen(
                text: 'Cadastrar',
                onPressed: _register,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
