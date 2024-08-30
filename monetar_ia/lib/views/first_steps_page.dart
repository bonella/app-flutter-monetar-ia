import 'package:flutter/material.dart';
import 'package:monetar_ia/components/cards/card_first_steps.dart';
import 'package:monetar_ia/views/first_steps_page2.dart';

class FirstStepsPage extends StatelessWidget {
  const FirstStepsPage({super.key});

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
                        'Primeiros Passos:',
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
                    CardFirstSteps(
                      title: 'Quais seus objetivos com a Monetar.ia?',
                      buttonLabels: const [
                        'Entender meus gastos',
                        'Descobrir o que mais me prejudica',
                        'Ter previsões sobre meus gastos',
                        'Criar planejamento financeiro',
                        'Centralizar meus gastos em um só local',
                        'Descobrir padrões de gastos',
                      ],
                      onNextPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FirstStepsPage2(),
                          ),
                        );
                      },
                    ),
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
