import 'package:flutter/material.dart';
import 'package:monetar_ia/components/headers/header_add.dart';
import 'package:monetar_ia/components/cards/white_card.dart';
import 'package:monetar_ia/components/boxes/info_box.dart';
import 'package:monetar_ia/components/footers/footer.dart';
import 'package:monetar_ia/components/buttons/round_btn.dart';
import 'package:monetar_ia/views/goal_page.dart';

class ExpensePage extends StatelessWidget {
  const ExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color(0xFF8C1C03),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomCard(
                          child: Column(
                            children: [
                              HeaderAdd(
                                month: 'Agosto',
                                onPrevMonth: () {},
                                onNextMonth: () {},
                                backgroundColor: const Color(0xFF8C1C03),
                                circleIcon: Icons.keyboard_arrow_down,
                                circleIconColor: Colors.white,
                                circleBackgroundColor: const Color(0xFF8C1C03),
                                label: 'Despesas',
                                value: 'R\$ 8.000,00',
                              ),
                              const SizedBox(height: 16),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  children: [
                                    InfoBox(
                                      title: 'Total Mês de Agosto',
                                      description: 'R\$ 8.000,00',
                                      showBadge: true,
                                      percentage: '+5%',
                                      borderColor: Color(0xFF8C1C03),
                                      badgeColor: Color(0xFF8C1C03),
                                    ),
                                    SizedBox(height: 16),
                                    InfoBox(
                                      title: 'Aluguel',
                                      description: 'R\$ 2.000,00',
                                      showBadge: true,
                                      percentage: '-3%',
                                      borderColor: Color(0xFF8C1C03),
                                      badgeColor: Color(0xFF8C1C03),
                                    ),
                                    SizedBox(height: 16),
                                    InfoBox(
                                      title: 'Mercado',
                                      description: 'R\$ 2.000,00',
                                      showBadge: true,
                                      percentage: '-3%',
                                      borderColor: Color(0xFF8C1C03),
                                      badgeColor: Color(0xFF8C1C03),
                                    ),
                                    SizedBox(height: 16),
                                    InfoBox(
                                      title: 'Gasolina',
                                      description: 'R\$ 800,00',
                                      showBadge: true,
                                      percentage: '0,2%',
                                      borderColor: Color(0xFF8C1C03),
                                      badgeColor: Color(0xFF8C1C03),
                                    ),
                                    SizedBox(height: 100),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Footer(
                  backgroundColor: Color(0xFF8C1C03),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 55,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: RoundButton(
              icon: Icons.add,
              backgroundColor: Colors.white,
              borderColor: const Color(0xFF8C1C03),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GoalPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
