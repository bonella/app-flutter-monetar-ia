import 'package:flutter/material.dart';
import 'package:monetar_ia/components/cards/card_register.dart';
import 'package:monetar_ia/components/headers/header_first_steps.dart';
import 'package:monetar_ia/components/footers/footer.dart';
import 'package:monetar_ia/components/buttons/btn_outline_green.dart';
import 'package:monetar_ia/services/auth_service.dart';
import 'package:monetar_ia/views/login.dart';
import 'dart:io';

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

  bool _isLoading = false;

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final name = _nameController.text;
      final lastName = _lastNameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;
      final confirmPassword = _confirmPasswordController.text;

      try {
        await AuthService().signup(
          name: name,
          lastName: lastName,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso!')),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      } on SocketException catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao se conectar com o servidor: \nSem conexão'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erro de cadastro: \nUsuário já existente')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (route) => false,
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
                        padding: const EdgeInsets.only(
                            top: 0, left: 16, right: 16, bottom: 16),
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
                  isLoading: _isLoading,
                  onPressed: _register,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
