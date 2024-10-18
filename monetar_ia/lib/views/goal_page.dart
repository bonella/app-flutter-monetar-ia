import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monetar_ia/components/headers/header_add.dart';
import 'package:monetar_ia/components/cards/white_card.dart';
import 'package:monetar_ia/components/boxes/info_box.dart';
import 'package:monetar_ia/components/footers/footer.dart';
import 'package:monetar_ia/components/buttons/round_btn.dart';
import 'package:monetar_ia/components/popups/add_goal_popup.dart';
import 'package:monetar_ia/components/popups/goal_detail_popup.dart';
import 'package:monetar_ia/services/request_http.dart';
import 'package:monetar_ia/models/goal.dart';
import 'package:monetar_ia/services/token_storage.dart';
import 'package:monetar_ia/views/home_page.dart';

class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  DateTime selectedDate = DateTime.now();
  List<Goal> goals = [];
  List<Goal> filteredGoals = [];
  final RequestHttp _requestHttp = RequestHttp();
  final TokenStorage _tokenStorage = TokenStorage();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals({String? searchTerm}) async {
    try {
      if (await _tokenStorage.isTokenValid()) {
        goals = await _requestHttp.getGoals();

        // Verifica se há um termo de busca e filtra as metas
        if (searchTerm != null && searchTerm.isNotEmpty) {
          _filterGoals(searchTerm);
        } else {
          _filterGoals('');
        }

        // Filtrando metas até o último dia do mês selecionado
        DateTime(selectedDate.year, selectedDate.month, 1);
        DateTime lastDayOfSelectedMonth =
            DateTime(selectedDate.year, selectedDate.month + 1, 0);

        // Filtra as metas até o último dia do mês selecionado
        filteredGoals = goals.where((goal) {
          return goal.createdAt.isBefore(
            lastDayOfSelectedMonth.add(const Duration(days: 1)),
          );
        }).toList();

        // Ordena as metas pela data de criação
        filteredGoals.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      } else {
        print("Token não está disponível. Faça login novamente.");
      }
    } catch (error) {
      print("Erro ao carregar metas: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Função para filtrar as metas com base no termo de busca
  void _filterGoals(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        filteredGoals = List.from(goals);
      } else {
        filteredGoals = goals
            .where((goal) =>
                goal.name.toLowerCase().contains(searchTerm.toLowerCase()))
            .toList();
      }
    });
  }

  void _onPrevMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, 1);
      _loadGoals();
    });
  }

  void _onNextMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, 1);
      _loadGoals();
    });
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
      _loadGoals();
    });
  }

  void _showAddGoalPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddGoalPopup(
          onSave: (name, targetAmount, currentAmount, description, deadline) {
            print(
                "Meta adicionada: $name, $targetAmount, $currentAmount, $description, $deadline");
            _loadGoals();
          },
        );
      },
    ).then((_) => _loadGoals());
  }

  void _showGoalDetailPopup(BuildContext context, Goal goal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GoalDetailPopup(
          goal: goal,
          onEdit: (editedGoal) {},
          onDelete: (goalId) {},
        );
      },
    );
  }

  double _calculateTotalGoals() {
    return filteredGoals.fold(0.0, (sum, goal) => sum + goal.targetAmount);
  }

  @override
  Widget build(BuildContext context) {
    String formattedMonth = DateFormat('MMMM/yy').format(selectedDate);
    String monthDisplay =
        formattedMonth[0].toUpperCase() + formattedMonth.substring(1);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );

        return false;
      },
      child: Scaffold(
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
                    circleIcon: Icons.emoji_events,
                    circleIconColor: Colors.white,
                    circleBackgroundColor: const Color(0xFF003566),
                    label: 'Metas até $monthDisplay',
                    value: 'R\$ ${_calculateTotalGoals().toStringAsFixed(2)}',
                    // onSearchGoals: _filterGoals,
                  ),
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF003566)),
                            ),
                          )
                        : filteredGoals.isEmpty
                            ? Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.asset(
                                      'lib/assets/fundo_metas2.png',
                                      fit: BoxFit.contain,
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                    ),
                                  ),
                                ],
                              )
                            : SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 16),
                                    WhiteCard(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Column(
                                          children: filteredGoals.map((goal) {
                                            return Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () =>
                                                      _showGoalDetailPopup(
                                                          context, goal),
                                                  child: InfoBox(
                                                    item: goal,
                                                    title: goal.name,
                                                    description:
                                                        'R\$ ${goal.targetAmount.toStringAsFixed(2)}',
                                                    showBadge: true,
                                                    percentage:
                                                        '${goal.percentage}%',
                                                    borderColor:
                                                        const Color(0xFF003566),
                                                    badgeColor:
                                                        const Color(0xFF003566),
                                                    creationDate: DateFormat(
                                                            'dd/MM/yyyy')
                                                        .format(goal.createdAt),
                                                  ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RoundButton(
                    icon: Icons.add,
                    backgroundColor: Colors.white,
                    borderColor: const Color(0xFF003566),
                    iconColor: const Color(0xFF003566),
                    onPressed: _showAddGoalPopup,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
