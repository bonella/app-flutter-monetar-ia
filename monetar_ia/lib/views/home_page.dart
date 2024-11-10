import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monetar_ia/components/headers/header_home.dart';
import 'package:monetar_ia/components/boxes/info_box2.dart';

import 'package:monetar_ia/components/graphics/line_graphic.dart';
import 'package:monetar_ia/components/graphics/pizza_chart.dart';
import 'package:monetar_ia/components/graphics/column_chart.dart';
import 'package:monetar_ia/views/goal_page.dart';
import 'package:monetar_ia/views/profile_page.dart';
import 'package:monetar_ia/views/voice_page.dart';
import 'package:monetar_ia/components/buttons/round_btn.dart';
import 'package:monetar_ia/components/cards/white_card.dart';
import 'package:monetar_ia/components/footers/footer.dart';
import 'package:monetar_ia/views/login.dart';
import 'package:monetar_ia/components/buttons/date_btn.dart';
import 'package:monetar_ia/models/goal.dart';
import 'package:monetar_ia/models/transaction.dart';
import 'package:monetar_ia/services/request_http.dart';
import 'package:intl/intl.dart';
import 'package:monetar_ia/utils/calculate_total.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  String userName = '';
  Transaction? lastTransaction;
  Goal? lastGoal;
  double totalRevenue = 0.0;
  double totalExpense = 0.0;
  List<Transaction> revenues = [];
  double currentYearRevenue = 0;
  double currentYearExpense = 0;
  double previousYearRevenue = 0;
  double previousYearExpense = 0;
  Map<String, double> yearlyComparison = {};
  Map<String, double> monthlySummary = {};
  List<Transaction> last10Transactions = [];
  List<Transaction> revenueTransactions = [];
  List<Transaction> expenseTransactions = [];
  List<FlSpot> revenueSpots = [];
  List<FlSpot> expenseSpots = [];
  bool hasData = false;
  final PageController pageController = PageController();
  int _currentPage = 0;

  final RequestHttp _requestHttp = RequestHttp();

  @override
  void initState() {
    super.initState();
    _showStayConnectedDialog();
    _loadUserName();
    _loadTotalRevenue();
    _loadTotalExpense();
    _loadLatestRevenue();
    ();
    _loadLatestGoal();
    _loadLatestTransactions();
    _loadMonthlyTransactions();
    _loadYearlyComparison();
    pageController.dispose();
  }

  // 1. Carregar as 10 últimas transações para o gráfico de linha
  Future<void> _loadLatestTransactions() async {
    try {
      var response = await _requestHttp.get('transactions');
      if (response.statusCode == 200) {
        List<dynamic> decodedResponse = json.decode(response.body);
        setState(() {
          last10Transactions = decodedResponse
              .map((data) => Transaction.fromJson(data))
              .toList();

          // Limitar para as 10 últimas transações
          last10Transactions = last10Transactions.take(10).toList();

          // Separando as transações para gráficos
          revenueTransactions = last10Transactions
              .where((transaction) => transaction.type == 'INCOME')
              .toList();

          expenseTransactions = last10Transactions
              .where((transaction) => transaction.type == 'EXPENSE')
              .toList();

          // Filtragem e mapeamento para os gráficos
          revenueSpots = revenueTransactions
              .asMap()
              .map((index, transaction) => MapEntry(
                    index.toDouble(),
                    FlSpot(index.toDouble(), transaction.amount),
                  ))
              .values
              .toList();

          expenseSpots = expenseTransactions
              .asMap()
              .map((index, transaction) => MapEntry(
                    index.toDouble(),
                    FlSpot(index.toDouble(), transaction.amount),
                  ))
              .values
              .toList();

          hasData = last10Transactions.isNotEmpty;
        });
      } else {
        print('Erro ao carregar as últimas transações: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar as últimas transações: $e');
    }
  }

  // 2. Carregar transações do mês selecionado para o gráfico de pizza
  Future<void> _loadMonthlyTransactions() async {
    try {
      // Definir o primeiro e o último dia do mês atual
      DateTime firstDayOfMonth =
          DateTime(DateTime.now().year, DateTime.now().month, 1);
      DateTime lastDayOfMonth =
          DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

      // Realizar a requisição à API
      var response = await _requestHttp.get(
        'transactions?start_date=${firstDayOfMonth.toIso8601String()}&end_date=${lastDayOfMonth.toIso8601String()}',
      );

      if (response.statusCode == 200) {
        List<dynamic> decodedResponse = json.decode(response.body);
        List<Transaction> transactions =
            decodedResponse.map((data) => Transaction.fromJson(data)).toList();

        // Filtra as transações de receitas e despesas
        Map<String, double> summary = {
          'Receitas': transactions
              .where((t) => t.type == 'INCOME') // Corrigido para 'INCOME'
              .fold(0.0,
                  (sum, t) => sum + t.amount), // Usando diretamente t.amount
          'Despesas': transactions
              .where((t) => t.type == 'EXPENSE') // Corrigido para 'EXPENSE'
              .fold(0.0,
                  (sum, t) => sum + t.amount), // Usando diretamente t.amount
        };

        setState(() {
          monthlySummary = {
            'Receitas': summary['Receitas'] ?? 0.0,
            'Despesas': summary['Despesas'] ?? 0.0,
          };
        });
      }
    } catch (e) {
      print('Erro ao carregar transações mensais: $e');
    }
  }

  Future<void> _loadYearlyComparison() async {
    try {
      int currentYear = DateTime.now().year;
      int lastYear = currentYear - 1;

      var response = await _requestHttp.get('transactions');

      if (response.statusCode == 200) {
        List<dynamic> decodedResponse = json.decode(response.body);
        List<Transaction> transactions =
            decodedResponse.map((data) => Transaction.fromJson(data)).toList();

        double currentRevenue = 0.0;
        double currentExpense = 0.0;
        double lastRevenue = 0.0;
        double lastExpense = 0.0;

        for (var t in transactions) {
          double amount = t.amount;
          int transactionYear = t.transactionDate.year;

          if (transactionYear == currentYear) {
            if (t.type == 'INCOME') {
              currentRevenue += amount;
            } else if (t.type == 'EXPENSE') {
              currentExpense += amount;
            }
          } else if (transactionYear == lastYear) {
            if (t.type == 'INCOME') {
              lastRevenue += amount;
            } else if (t.type == 'EXPENSE') {
              lastExpense += amount;
            }
          }
        }

        setState(() {
          yearlyComparison = {
            'Receitas Atual': currentRevenue,
            'Despesas Atual': currentExpense,
            'Receitas Anterior': lastRevenue,
            'Despesas Anterior': lastExpense,
          };
        });
      } else {
        print('Erro ao carregar transações: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar comparação anual: $e');
    }
  }

  Future<void> _loadUserName() async {
    try {
      String? name = await _requestHttp.getUserName();
      setState(() {
        userName = name ?? 'Usuário';
      });
    } catch (e) {
      print('Erro ao carregar o nome do usuário: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _loadTotalRevenue() async {
    try {
      DateTime firstDayOfMonth =
          DateTime(selectedDate.year, selectedDate.month, 1);
      DateTime lastDayOfMonth =
          DateTime(selectedDate.year, selectedDate.month + 1, 0);

      totalRevenue = 0.0;

      var response = await _requestHttp.get(
          'transactions/revenues?start_date=${firstDayOfMonth.toIso8601String()}&end_date=${lastDayOfMonth.toIso8601String()}');
      if (response.statusCode == 200) {
        List<dynamic> decodedResponse = json.decode(response.body);
        List<Transaction> transactions =
            decodedResponse.map((data) => Transaction.fromJson(data)).toList();

        if (transactions.any((transaction) =>
            transaction.transactionDate.year == selectedDate.year &&
            transaction.transactionDate.month == selectedDate.month)) {
          totalRevenue = calculateTotalRevenues(transactions);
        } else {
          totalRevenue = 0.0;
        }

        setState(() {});
      } else {
        print('Erro ao carregar as receitas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar as receitas: $e');
    }
  }

  Future<void> _loadTotalExpense() async {
    try {
      DateTime firstDayOfMonth =
          DateTime(selectedDate.year, selectedDate.month, 1);
      DateTime lastDayOfMonth =
          DateTime(selectedDate.year, selectedDate.month + 1, 0);

      totalExpense = 0.0;

      var response = await _requestHttp.get(
          'transactions/expenses?start_date=${firstDayOfMonth.toIso8601String()}&end_date=${lastDayOfMonth.toIso8601String()}');
      if (response.statusCode == 200) {
        List<dynamic> decodedResponse = json.decode(response.body);
        List<Transaction> transactions =
            decodedResponse.map((data) => Transaction.fromJson(data)).toList();

        if (transactions.any((transaction) =>
            transaction.transactionDate.year == selectedDate.year &&
            transaction.transactionDate.month == selectedDate.month)) {
          totalExpense = calculateTotalExpenses(transactions);
        } else {
          totalExpense = 0.0;
        }

        setState(() {});
      } else {
        print('Erro ao carregar as despesas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar as despesas: $e');
    }
  }

  Future<void> _loadLatestRevenue() async {
    try {
      var response = await _requestHttp.get('transactions/revenues');
      if (response.statusCode == 200) {
        List<dynamic> decodedResponse = json.decode(response.body);
        List<Transaction> transactions =
            decodedResponse.map((data) => Transaction.fromJson(data)).toList();

        List<Transaction> filteredTransactions =
            transactions.where((transaction) {
          return transaction.transactionDate.year == selectedDate.year;
        }).toList();

        if (filteredTransactions.isEmpty) {
          lastTransaction = transactions.reduce(
              (a, b) => a.transactionDate.isAfter(b.transactionDate) ? a : b);
        } else {
          lastTransaction = filteredTransactions.reduce(
              (a, b) => a.transactionDate.isAfter(b.transactionDate) ? a : b);
        }
        setState(() {});
      } else {
        print('Erro ao carregar as transações: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar as transações: $e');
    }
  }

  Future<void> _loadLatestGoal() async {
    try {
      var response = await _requestHttp.get('goals/');
      if (response.statusCode == 200) {
        List<dynamic> decodedResponse = json.decode(response.body);
        List<Goal> goals =
            decodedResponse.map((data) => Goal.fromJson(data)).toList();

        List<Goal> filteredGoals = goals.where((goal) {
          return goal.createdAt.year == selectedDate.year;
        }).toList();

        if (filteredGoals.isEmpty) {
          lastGoal =
              goals.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b);
        } else {
          lastGoal = filteredGoals
              .reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b);
        }
        setState(() {});
      } else {
        print('Erro ao carregar as metas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar as metas: $e');
    }
  }

  Future<void> _showStayConnectedDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? stayConnected = prefs.getBool('stayConnected');

    if (stayConnected == null) {
      final shouldStayConnected = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Manter-se conectado?'),
          content: const Text('Você deseja permanecer logado?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Não'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Sim'),
            ),
          ],
        ),
      );

      if (shouldStayConnected == true) {
        await prefs.setBool('stayConnected', true);
      } else {
        await prefs.setBool('stayConnected', false);
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('stayConnected');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    final shouldExit = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmação'),
        content: const Text('Você tem certeza que deseja sair do aplicativo?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      _logout(context);
    }

    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  HeaderHome(
                    name: userName,
                    dateButton: DateButton(
                      onDateChanged: (DateTime newDate) {
                        setState(() {
                          selectedDate = newDate;
                          print('Data selecionada: $selectedDate');

                          _loadTotalRevenue();
                          _loadTotalExpense();
                          _loadMonthlyTransactions();
                          _loadYearlyComparison();
                        });
                      },
                    ),
                    totalRevenue: totalRevenue,
                    totalExpense: totalExpense,
                    onPrevMonth: () {},
                    onNextMonth: () {},
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 16),
                          WhiteCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: InfoBox2(
                                    title: lastTransaction?.description != null
                                        ? 'Última Receita: ${lastTransaction!.description}'
                                        : 'Sem Receitas',
                                    description: lastTransaction != null
                                        ? 'R\$ ${lastTransaction!.amount.toStringAsFixed(2)}'
                                        : '',
                                    creationDate: lastTransaction != null
                                        ? DateFormat('dd/MM/yyyy').format(
                                            lastTransaction!.transactionDate)
                                        : 'Data não disponível',
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: InfoBox2(
                                    title: lastGoal?.name != null
                                        ? 'Última Meta: ${lastGoal!.name}'
                                        : 'Sem Metas',
                                    description: lastGoal != null
                                        ? 'R\$ ${lastGoal!.targetAmount.toStringAsFixed(2)}'
                                        : 'R\$ 0.00',
                                    showBadge: lastGoal != null,
                                    percentage: lastGoal != null
                                        ? '${lastGoal!.percentage}%'
                                        : '0%',
                                    borderColor: const Color(0xFF003566),
                                    badgeColor: const Color(0xFF003566),
                                    creationDate: lastGoal != null
                                        ? DateFormat('dd/MM/yyyy')
                                            .format(lastGoal!.createdAt)
                                        : 'Data não disponível',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: SizedBox(
                                    height: 300,
                                    child: PageView(
                                      controller: pageController,
                                      onPageChanged: (int page) {
                                        setState(() {
                                          _currentPage = page;
                                        });
                                      },
                                      children: [
                                        if (hasData)
                                          LineGraphic(
                                            title: 'Últimas Transações',
                                            transactions:
                                                last10Transactions, // Aqui você passa as transações para o gráfico
                                          ),
                                        if (hasData)
                                          PizzaChart(
                                            title: 'Resumo do Mês',
                                            currentMonthRevenue:
                                                monthlySummary['Receitas'] ??
                                                    0.0,
                                            currentMonthExpense:
                                                monthlySummary['Despesas'] ??
                                                    0.0,
                                          ),
                                        if (hasData)
                                          ColumnChart(
                                            title: 'Comparação Anual',
                                            currentYearRevenue:
                                                yearlyComparison[
                                                        'Receitas Atual'] ??
                                                    0.0,
                                            currentYearExpense:
                                                yearlyComparison[
                                                        'Despesas Atual'] ??
                                                    0.0,
                                            previousYearRevenue:
                                                yearlyComparison[
                                                        'Receitas Anterior'] ??
                                                    0.0,
                                            previousYearExpense:
                                                yearlyComparison[
                                                        'Despesas Anterior'] ??
                                                    0.0,
                                            data: yearlyComparison,
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Indicadores de Página
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    3, // Número de gráficos
                                    (index) => Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      height: 10,
                                      width: 10,
                                      decoration: BoxDecoration(
                                        color: _currentPage == index
                                            ? Colors.green
                                            : Colors.grey,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),
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
              right: 16,
              bottom: 5,
              left: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          'Perfil',
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
          ],
        ),
      ),
    );
  }
}
