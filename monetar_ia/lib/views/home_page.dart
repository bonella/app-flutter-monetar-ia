import 'package:flutter/material.dart';
import 'package:monetar_ia/components/header_home.dart';
import 'package:monetar_ia/components/info_box.dart';
import 'package:monetar_ia/components/chart.dart';

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
            onPrevMonth: () {
              // Navegar para o mês anterior
            },
            onNextMonth: () {
              // Navegar para o próximo mês
            },
          ),
          // Adicionar informações abaixo dos blocos financeiros
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                InfoBox(
                  title: '10 mil reais',
                  description: 'Total do mês de agosto:',
                  showBadge: true,
                ),
                SizedBox(height: 16),
                InfoBox(
                  title: 'Outro título',
                  description: 'Descrição aqui',
                ),
              ],
            ),
          ),
          // Adicionar gráfico
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Chart(),
          ),
        ],
      ),
      // Adicionar o footer e o botão flutuante fora da coluna
      bottomNavigationBar: BottomAppBar(
        child: Container(
          width: double.infinity,
          height: 80,
          color: const Color(0xFF738C61),
          child: const Center(
            child: Text(
              'Footer',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Kumbh Sans',
                fontWeight: FontWeight.w400,
                fontSize: 66,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ação ao pressionar o botão flutuante
        },
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
}
