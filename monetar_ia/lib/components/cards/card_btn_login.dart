import 'package:flutter/material.dart';
import 'package:monetar_ia/components/buttons/btn_outline_white.dart';
import 'package:monetar_ia/components/buttons/btn_outline_green.dart';
import 'package:monetar_ia/views/register_page.dart';
import 'package:monetar_ia/views/home_page.dart';
import 'package:monetar_ia/services/auth_service.dart';
import 'package:monetar_ia/services/form_validations.dart';

class CardBtnLogin extends StatefulWidget {
  const CardBtnLogin({super.key});

  @override
  _CardBtnLoginState createState() => _CardBtnLoginState();
}

class _CardBtnLoginState extends State<CardBtnLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        final response = await AuthService().signin(
          email: email,
          password: password,
        );
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login realizado com sucesso!')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao realizar login: ${response.body}'),
            ),
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
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF738C61),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20),
              const Text(
                'Qual sua próxima meta?',
                style: TextStyle(
                  fontFamily: 'Kantumruy',
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                  color: Color(0xFFFFFFFF),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Nosso aplicativo é o seu parceiro ideal para alcançar metas e organizar suas finanças com eficiência. Transforme sua relação com o dinheiro e atinja seus objetivos com facilidade!',
                style: TextStyle(
                  fontFamily: 'Kumbh Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Color(0xFFFFFFFF),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 380),
              const Text(
                'Monetar.ia',
                style: TextStyle(
                  fontFamily: 'Kumbh Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 50,
                  height: 19.84 / 16,
                  color: Color(0xFFFFFFFF),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  labelStyle: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  labelStyle: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                validator: validatePassword,
              ),
              const SizedBox(height: 40.0),
              Center(
                child: BtnOutlineWhite(
                  onPressed: _login,
                  text: 'Entrar',
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: BtnOutlineGreen(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  },
                  text: 'Cadastrar',
                ),
              ),
              const SizedBox(height: 36.0),
              TextButton(
                onPressed: () {
                  // Ação ao clicar no link "Esqueceu a senha?"
                },
                child: const Text(
                  'Esqueceu a senha?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
