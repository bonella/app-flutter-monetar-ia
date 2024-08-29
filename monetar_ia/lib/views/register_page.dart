import 'package:flutter/material.dart';
import 'package:monetar_ia/components/cards/card_register.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF738C61),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 30),
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
                    const SizedBox(height: 20),
                    const CardRegister(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
