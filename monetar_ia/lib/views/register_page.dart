import 'package:flutter/material.dart';
import 'package:monetar_ia/components/cards/card_register.dart';
import 'package:monetar_ia/components/headers/header_first_steps.dart';
import 'package:monetar_ia/components/footers/footer.dart';
import 'package:monetar_ia/components/buttons/btn_outline_green.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: const Column(
              children: <Widget>[
                HeaderFirstSteps(
                  title: 'Monetar.ia',
                  subtitle: 'Cadastro',
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 20),
                        CardRegister(),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Footer(
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
                onPressed: () {
                  // Ação ao pressionar o botão
                  print("Botão de cadastrar pressionado");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
