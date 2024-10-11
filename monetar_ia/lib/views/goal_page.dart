import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monetar_ia/components/headers/header_add.dart';
import 'package:monetar_ia/components/cards/white_card.dart';
import 'package:monetar_ia/components/boxes/info_box.dart';
import 'package:monetar_ia/components/footers/footer.dart';
import 'package:monetar_ia/components/buttons/round_btn.dart';
import 'package:monetar_ia/components/popups/add_goal_popup.dart';
import 'package:monetar_ia/services/request_http.dart';
import 'package:monetar_ia/models/goal.dart';
import 'package:monetar_ia/services/token_storage.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  DateTime selectedDate = DateTime.now();
  List<Goal> goals = [];
  final RequestHttp _requestHttp = RequestHttp();
  final TokenStorage _tokenStorage = TokenStorage();

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    try {
      if (await _tokenStorage.isTokenValid()) {
        goals = await _requestHttp.getGoals();
        goals.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        setState(() {});
      } else {
        print("Token não está disponível. Faça login novamente.");
      }
    } catch (error) {
      print("Erro ao carregar metas: $error");
    }
  }

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

  void _showAddGoalPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddGoalPopup(
          onSave: (name, targetAmount, currentAmount, description, deadline) {
            // Lógica para salvar a nova meta
            print(
                "Meta adicionada: $name, $targetAmount, $currentAmount, $description, $deadline");
          },
        );
      },
    );
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
                  label: 'Metas em aberto',
                  value: 'R\$ 80 mil reais',
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),
                        WhiteCard(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: goals.isEmpty
                                  ? [
                                      const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ]
                                  : goals.map((goal) {
                                      return Column(
                                        children: [
                                          InfoBox(
                                            goal: goal,
                                            title: goal.name,
                                            description:
                                                'R\$ ${goal.currentAmount.toStringAsFixed(2)}',
                                            showBadge: true,
                                            percentage: '${goal.percentage}%',
                                            borderColor:
                                                const Color(0xFF003566),
                                            badgeColor: const Color(0xFF003566),
                                            creationDate:
                                                DateFormat('dd/MM/yyyy')
                                                    .format(goal.createdAt),
                                          ),
                                          const SizedBox(height: 16),
                                        ],
                                      );
                                    }).toList(),
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
              onPressed: _showAddGoalPopup,
            ),
          ),
        ],
      ),
    );
  }
}
