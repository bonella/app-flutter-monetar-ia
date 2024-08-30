import 'package:flutter/material.dart';
import 'package:monetar_ia/components/headers/header_home.dart';
import 'package:monetar_ia/components/boxes/info_box.dart';
import 'package:monetar_ia/components/graphics/line_graphic.dart';
import 'package:monetar_ia/views/new_register_page.dart';
import 'package:monetar_ia/views/voice_page.dart';
import 'package:monetar_ia/views/profile_page.dart';
import 'package:monetar_ia/components/buttons/round_btn.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                HeaderHome(
                  month: 'Agosto',
                  onPrevMonth: () {},
                  onNextMonth: () {},
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
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
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFF738C61),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -25),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: RoundButton(
                          icon: Icons.add,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NewRegisterPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -25),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: RoundButton(
                          icon: Icons.mic,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const VoicePage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -25),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: RoundButton(
                          icon: Icons.person,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
