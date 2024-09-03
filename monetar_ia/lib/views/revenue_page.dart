import 'package:flutter/material.dart';
import 'package:monetar_ia/components/headers/header_add.dart';
import 'package:monetar_ia/components/cards/white_card.dart';
import 'package:monetar_ia/components/boxes/info_box.dart';
import 'package:monetar_ia/components/footers/footer.dart';
import 'package:monetar_ia/components/buttons/round_btn.dart';
import 'package:monetar_ia/views/expense_page.dart';

class RevenuePage extends StatelessWidget {
  const RevenuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                HeaderAdd(
                  month: 'Agosto',
                  onPrevMonth: () {},
                  onNextMonth: () {},
                  backgroundColor: const Color(0xFF3D5936),
                  circleIcon: Icons.keyboard_arrow_up,
                  circleIconColor: Colors.white,
                  circleBackgroundColor: const Color(0xFF3D5936),
                  label: 'Receitas',
                  value: 'R\$ 1.000,00',
                ),
                const Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 16),
                        WhiteCard(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: [
                                InfoBox(
                                  title: 'Total Mês de Agosto',
                                  description: 'R\$ 10.000,00',
                                  showBadge: true,
                                  percentage: '+5%',
                                  borderColor: Color(0xFF3D5936),
                                  badgeColor: Color(0xFF3D5936),
                                ),
                                SizedBox(height: 16),
                                InfoBox(
                                  title: 'Salário',
                                  description: 'R\$ 6.000,00',
                                  showBadge: true,
                                  percentage: '-3%',
                                  borderColor: Color(0xFF3D5936),
                                  badgeColor: Color(0xFF3D5936),
                                ),
                                SizedBox(height: 16),
                                InfoBox(
                                  title: 'Investimentos',
                                  description: 'R\$ 2.000,00',
                                  showBadge: true,
                                  percentage: '3%',
                                  borderColor: Color(0xFF3D5936),
                                  badgeColor: Color(0xFF3D5936),
                                ),
                                SizedBox(height: 16),
                                InfoBox(
                                  title: 'Herança',
                                  description: 'R\$ 5.000,00',
                                  showBadge: true,
                                  percentage: '5,5%',
                                  borderColor: Color(0xFF3D5936),
                                  badgeColor: Color(0xFF3D5936),
                                ),
                                SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Footer(
                  backgroundColor: Color(0xFF3D5936),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: RoundButton(
              icon: Icons.add,
              backgroundColor: Colors.white,
              borderColor: const Color(0xFF3D5936),
              iconColor: const Color(0xFF3D5936),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExpensePage(),
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
