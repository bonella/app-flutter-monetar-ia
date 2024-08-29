import 'package:flutter/material.dart';
import 'package:monetar_ia/components/headers/header_home.dart';
import 'package:monetar_ia/components/boxes/info_box.dart';
import 'package:monetar_ia/components/graphics/chart.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeaderHome(
            month: 'Agosto',
            onPrevMonth: () {},
            onNextMonth: () {},
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Chart(),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          width: double.infinity,
          height: 80,
          color: const Color(0xFF738C61),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRoundButton(Icons.add, 'Adicionar'),
              _buildRoundButton(Icons.mic, 'Microfone'),
              _buildRoundButton(Icons.person, 'Perfil'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.white,
        child: const Text(
          '+',
          style: TextStyle(
            fontFamily: 'Kumbh Sans',
            fontWeight: FontWeight.w400,
            fontSize: 48,
            color: Color(0xFF3D5936),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildRoundButton(IconData icon, String label) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF3D5936), width: 2),
      ),
      child: Center(
        child: Icon(
          icon,
          color: const Color(0xFF3D5936),
          size: 30,
        ),
      ),
    );
  }
}
