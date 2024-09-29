import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monetar_ia/components/headers/header_add.dart';
import 'package:monetar_ia/components/cards/white_card.dart';
import 'package:monetar_ia/components/boxes/info_box.dart';
import 'package:monetar_ia/components/footers/footer.dart';
import 'package:monetar_ia/components/buttons/round_btn.dart';
import 'package:monetar_ia/views/add_page.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  DateTime selectedDate = DateTime.now();

  void _onPrevMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, 1);
    });
  }

  void _onNextMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, 1);
    });
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedMonth = DateFormat('MMMM/yy').format(selectedDate);
    String monthDisplay =
        formattedMonth[0].toUpperCase() + formattedMonth.substring(1);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              HeaderAdd(
                month: monthDisplay,
                onPrevMonth: _onPrevMonth,
                onNextMonth: _onNextMonth,
                onDateChanged: _onDateChanged,
                backgroundColor: const Color(0xFF8C1C03),
                circleIcon: Icons.keyboard_arrow_down,
                circleIconColor: Colors.white,
                circleBackgroundColor: const Color(0xFF8C1C03),
                label: 'Despesas',
                value: 'R\$ 8.000,00',
              ),
              const Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      WhiteCard(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            children: [
                              SizedBox(height: 16),
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
                backgroundColor: Color(0xFF8C1C03),
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: RoundButton(
              icon: Icons.add,
              backgroundColor: Colors.white,
              borderColor: const Color(0xFF8C1C03),
              iconColor: const Color(0xFF8C1C03),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddPage(),
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
