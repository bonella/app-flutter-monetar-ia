import 'package:flutter/material.dart';
import 'package:monetar_ia/components/buttons/btn_outline_white.dart';
import 'package:monetar_ia/components/buttons/btn_outline_green.dart';
import 'package:monetar_ia/views/register_page.dart';
import 'package:monetar_ia/views/home_page.dart';
import 'package:monetar_ia/services/auth_service.dart';
import 'package:monetar_ia/utils/form_validations.dart';
import 'dart:io';

class CardBtnLogin extends StatefulWidget {
  const CardBtnLogin({super.key});

  @override
  _CardBtnLoginState createState() => _CardBtnLoginState();
}

class _CardBtnLoginState extends State<CardBtnLogin>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  late AnimationController _spinController;
  late Animation<double> _spinAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _spinAnimation =
        Tween<double>(begin: 0.0, end: .3).animate(_spinController);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _spinController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _emailController.clear();
      _passwordController.clear();
      _formKey.currentState?.reset();
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      _spinController.repeat();

      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        // Solicita o token ao realizar o login
        await AuthService().signin(
          email: email,
          password: password,
        );

        // Valida o token obtido sem armazená-lo
        final isTokenValid = await AuthService().isTokenValid();
        _spinController.stop();

        if (isTokenValid) {
          // Navega para a HomePage se o token for válido
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erro: Token inválido. Faça login novamente.'),
            ),
          );
        }
      } on SocketException catch (_) {
        _spinController.stop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao se conectar com o servidor: \nSem conexão'),
          ),
        );
      } catch (e) {
        _spinController.stop();

        if (e.toString().contains('E-mail ou senha incorretos')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Erro ao realizar login: \nUsuário ou senha incorretos'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro inesperado: ${e.toString()}')),
          );
          print(e);
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
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
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                focusNode: _emailFocusNode,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Color(0xFF003566), width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  labelStyle: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                  floatingLabelStyle: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Color(0xFF003566), width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  labelStyle: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  floatingLabelStyle: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey[700],
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                validator: validatePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {},
              ),
              const SizedBox(height: 40.0),
              Center(
                child: _isLoading
                    ? AnimatedBuilder(
                        animation: _spinAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _spinAnimation.value * 6.3,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        },
                      )
                    : BtnOutlineWhite(
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
