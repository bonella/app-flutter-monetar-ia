import 'package:flutter/material.dart';
import 'package:monetar_ia/components/headers/header_home.dart';
import 'package:monetar_ia/components/boxes/info_box.dart';
import 'package:monetar_ia/components/graphics/line_graphic.dart';
import 'package:monetar_ia/views/expense_page.dart';
import 'package:monetar_ia/views/goal_page.dart';
import 'package:monetar_ia/views/profile_page.dart';
import 'package:monetar_ia/views/revenue_page.dart';
import 'package:monetar_ia/views/voice_page.dart';
import 'package:monetar_ia/components/buttons/round_btn.dart';
import 'package:monetar_ia/components/cards/white_card.dart';
import 'package:monetar_ia/components/footers/footer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Column(
              children: [
                HeaderHome(
                  month: 'Agosto',
                  onPrevMonth: () {},
                  onNextMonth: () {},
                ),
                const Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        WhiteCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 16.0,
                                ),
                                child: Column(
                                  children: [
                                    InfoBox(
                                      title: 'Total do mês de agosto:',
                                      description: '10 mil reais',
                                      showBadge: true,
                                      percentage: '+2,5%',
                                    ),
                                    SizedBox(height: 16),
                                    InfoBox(
                                      title: 'Total da meta atual',
                                      description: '4%',
                                      showBadge: true,
                                      percentage: '-1,2%',
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: SizedBox(
                                  height: 300,
                                  child: LineGraphic(title: 'Últimas compras'),
                                ),
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
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
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RoundButton(
                  icon: Icons.mic,
                  backgroundColor: Colors.white,
                  borderColor: const Color(0xFF3D5936),
                  iconColor: const Color(0xFF3D5936),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VoicePage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            height: 50,
            bottom: 5,
            left: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RevenuePage(),
                      ),
                    );
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.attach_money_outlined,
                        size: 30.0,
                      ),
                      SizedBox(height: 1),
                      Text(
                        'Receitas',
                        style: TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExpensePage(),
                      ),
                    );
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.money_off,
                        size: 30.0,
                      ),
                      SizedBox(height: 1),
                      Text(
                        'Despesas',
                        style: TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            height: 50,
            bottom: 5,
            right: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GoalPage(),
                      ),
                    );
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.star,
                        size: 30.0,
                      ),
                      SizedBox(height: 1),
                      Text(
                        'Metas',
                        style: TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                  child: const Column(
                    children: [
                      Icon(
                        Icons.person,
                        size: 30.0,
                      ),
                      SizedBox(height: 1),
                      Text(
                        'Perfil  ',
                        style: TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
