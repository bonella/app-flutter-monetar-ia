import 'package:flutter/material.dart';
import 'package:monetar_ia/components/headers/header_first_steps.dart';
import 'package:monetar_ia/components/cards/card_first_steps.dart';
import 'package:monetar_ia/components/buttons/btn_outline_green.dart';
import 'package:monetar_ia/components/footers/footer.dart';
import 'package:monetar_ia/views/first_steps_page2.dart';

class FirstStepsPage extends StatelessWidget {
  const FirstStepsPage({super.key});

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
                  subtitle: 'Primeiros Passos',
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const SizedBox(height: 20),
                        CardFirstSteps(
                          title: 'Quais seus objetivos com a Monetar.ia?',
                          buttonLabels: const [
                            'Entender meus gastos',
                            'Descobrir o que mais me prejudica',
                            'Ter previsões sobre meus gastos',
                            'Criar planejamento financeiro',
                            'Centralizar meus gastos',
                            'Descobrir padrões de gastos',
                          ],
                          onButtonPressed: (label) {
                            // Adicione a ação desejada ao clicar em um dos botões
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
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
                text: 'Próximo',
                width: 260,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FirstStepsPage2(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
