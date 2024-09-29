import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monetar_ia/components/headers/header_add.dart';
import 'package:monetar_ia/components/cards/white_card.dart';
import 'package:monetar_ia/components/boxes/info_box.dart';
import 'package:monetar_ia/components/footers/footer.dart';
import 'package:monetar_ia/components/buttons/round_btn.dart';
import 'package:monetar_ia/views/add_page.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
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
          Container(
            color: Colors.white,
            child: Column(
              children: [
                HeaderAdd(
                  month: monthDisplay,
                  onPrevMonth: _onPrevMonth,
                  onNextMonth: _onNextMonth,
                  onDateChanged: _onDateChanged,
                  backgroundColor: const Color(0xFF003566),
                  circleIcon: Icons.star,
                  circleIconColor: Colors.white,
                  circleBackgroundColor: const Color(0xFF003566),
                  label: 'Metas 2024',
                  value: 'R\$ 80 mil reais',
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
                                  title: 'Viajem de fim de ano',
                                  description: 'R\$ 14.000,00',
                                  showBadge: true,
                                  percentage: '+10%',
                                  borderColor: Color(0xFF003566),
                                  badgeColor: Color(0xFF003566),
                                ),
                                SizedBox(height: 16),
                                InfoBox(
                                  title: 'Carro novo',
                                  description: 'R\$ 60.000,00',
                                  showBadge: true,
                                  percentage: '+2%',
                                  borderColor: Color(0xFF003566),
                                  badgeColor: Color(0xFF003566),
                                ),
                                SizedBox(height: 16),
                                InfoBox(
                                  title: 'IR',
                                  description: 'R\$ 6.000,00',
                                  showBadge: true,
                                  percentage: '+5%',
                                  borderColor: Color(0xFF003566),
                                  badgeColor: Color(0xFF003566),
                                ),
                                SizedBox(height: 16),
                                InfoBox(
                                  title: 'Outros',
                                  description: 'R\$ 500,00',
                                  showBadge: true,
                                  percentage: '-1%',
                                  borderColor: Color(0xFF003566),
                                  badgeColor: Color(0xFF003566),
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
                  backgroundColor: Color(0xFF003566),
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
              borderColor: const Color(0xFF003566),
              iconColor: const Color(0xFF003566),
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
