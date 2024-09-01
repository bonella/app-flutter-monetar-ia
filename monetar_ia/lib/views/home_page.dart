import 'package:flutter/material.dart';
import 'package:monetar_ia/components/headers/header_home.dart';
import 'package:monetar_ia/components/boxes/info_box.dart';
import 'package:monetar_ia/components/graphics/line_graphic.dart';
import 'package:monetar_ia/views/add_page.dart';
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
                                  child: LineGraphic(title: 'Gastos por mês'),
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
                  icon: Icons.add,
                  backgroundColor: Colors.white,
                  borderColor: const Color(0xFF3D5936),
                  iconColor: const Color(0xFF3D5936),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddPage(),
                      ),
                    );
                  },
                ),
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
                RoundButton(
                  icon: Icons.person,
                  backgroundColor: Colors.white,
                  borderColor: const Color(0xFF3D5936),
                  iconColor: const Color(0xFF3D5936),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RevenuePage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
