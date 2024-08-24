import 'package:flutter/material.dart';
import 'package:monetar_ia/components/btn_sign_up.dart';
import 'package:monetar_ia/components/card_register.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF738C61),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 80),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Monetar.ia',
                      style: TextStyle(
                        fontFamily: 'Kumbh Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 48,
                        color: Color(0xFFE1E7E0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: const Text(
                      'Cadastro:',
                      style: TextStyle(
                        fontFamily: 'Kumbh Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 22,
                        height: 27.29 / 22,
                        color: Color(0xFFFFFFFF),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: double.infinity, height: 20),
                  const SizedBox(
                    width: double.infinity,
                    child: CardRegister(),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width * 0.1,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: BtnSignUp(
                onPressed: () {
                  // Ação ao clicar no botão de salvar
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
