import 'package:flutter/material.dart';
import 'package:monetar_ia/components/buttons/btn_outline_white.dart';
import 'package:monetar_ia/components/buttons/btn_outline_green.dart';
import 'package:monetar_ia/views/register_page.dart';
import 'package:monetar_ia/views/first_steps_page.dart';

class CardBtnLogin extends StatelessWidget {
  const CardBtnLogin({super.key});

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
                height: 43.36 / 24,
                color: Color(0xFFFFFFFF),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Nosso aplicativo é o seu parceiro ideal para alcançar metas e organizar suas finanças com eficiência. Transforme sua relação com o dinheiro e atinja seus objetivos com facilidade!',
              style: TextStyle(
                fontFamily: 'Kumbh Sans',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                height: 19.84 / 16,
                color: Color(0xFFFFFFFF),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            const Center(
              child: Icon(
                Icons.arrow_downward,
                color: Colors.white,
                size: 60.0,
              ),
            ),
            const SizedBox(height: 40),
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
            TextField(
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
            ),
            const SizedBox(height: 12.0),
            TextField(
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
              obscureText: true,
            ),
            const SizedBox(height: 40.0),
            Center(
              child: BtnOutlineWhite(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FirstStepsPage(),
                    ),
                  );
                },
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
    );
  }
}
