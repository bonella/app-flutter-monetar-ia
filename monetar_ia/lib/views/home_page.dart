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
import 'package:monetar_ia/components/cards/white_card.dart';
import 'package:monetar_ia/components/footers/footer.dart';
import 'package:monetar_ia/views/login.dart';
import 'package:monetar_ia/components/buttons/date_btn.dart';
import 'package:monetar_ia/models/goal.dart';
import 'package:monetar_ia/models/transaction.dart';
import 'package:monetar_ia/services/request_http.dart';
import 'package:monetar_ia/services/token_storage.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  String userName = '';
  String email = '';
  Transaction? lastTransaction;
  Transaction? lastExpense;
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
  late PageController pageController;
  int _currentPage = 0;
  bool _isLoading = true;
  final RequestHttp _requestHttp = RequestHttp();

  @override
  void initState() {
    super.initState();
    _showStayConnectedDialog();
    _loadUserName();
    _loadTotalRevenue();
    _loadTotalExpense();
    _loadLatestRevenue();
    _loadLatestExpense();
    _loadLatestGoal();
    _loadLatestTransactions();
    _loadMonthlyTransactions();
    _loadYearlyComparison();
    pageController = PageController();
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> navigateToNextPage() async {
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      pageController.jumpToPage(1);
    } else {}
  }

  // 1. Carregar as 10 ultimas transações para o gráfico de linha
  Future<void> _loadLatestTransactions() async {
    try {
      var response = await _requestHttp.get('transactions');
      if (response.statusCode == 200) {
        List<dynamic> decodedResponse = json.decode(response.body);
        setState(() {
          last10Transactions = decodedResponse
              .map((data) => Transaction.fromJson(data))
              .toList();

          last10Transactions = last10Transactions.take(10).toList();

          revenueTransactions = last10Transactions
              .where((transaction) => transaction.type == 'INCOME')
              .toList();

          expenseTransactions = last10Transactions
              .where((transaction) => transaction.type == 'EXPENSE')
              .toList();

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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 2. Carregar transações do mês selecionado para o gráfico de pizza
  Future<void> _loadMonthlyTransactions() async {
    try {
      DateTime firstDayOfMonth =
          DateTime(DateTime.now().year, DateTime.now().month, 1);
      DateTime lastDayOfMonth =
          DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

      var response = await _requestHttp.get(
        'transactions?start_date=${firstDayOfMonth.toIso8601String()}&end_date=${lastDayOfMonth.toIso8601String()}',
      );

      if (response.statusCode == 200) {
        List<dynamic> decodedResponse = json.decode(response.body);
        List<Transaction> transactions =
            decodedResponse.map((data) => Transaction.fromJson(data)).toList();

        Map<String, double> summary = {
          'Receitas': transactions
              .where((t) => t.type == 'INCOME')
              .fold(0.0, (sum, t) => sum + t.amount),
          'Despesas': transactions
              .where((t) => t.type == 'EXPENSE')
              .fold(0.0, (sum, t) => sum + t.amount),
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // 2. Carregar transações para o gráfico de coluna
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
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUserName() async {
    try {
      String? name = await _requestHttp.getUserName();
      setState(() {
        userName = name ?? 'Usuário';
        email = email;
      });
    } catch (e) {
      print('Erro ao carregar o nome do usuário: $e');
      print(email);
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _loadTotalRevenue() async {
    try {
      DateTime now = DateTime.now();
      int currentMonth = now.month;
      int currentYear = now.year;

      totalRevenue = 0.0; // Total de receitas

      var response = await _requestHttp.get('transactions/revenues');

      if (response.statusCode == 200) {
        var decodedResponse = utf8.decode(response.bodyBytes);
        List<Transaction> transactions = (json.decode(decodedResponse) as List)
            .map((data) => Transaction.fromJson(data))
            .toList();

        List<Transaction> currentMonthTransactions = transactions
            .where((transaction) =>
                transaction.transactionDate.year == currentYear &&
                transaction.transactionDate.month == currentMonth)
            .toList();

        totalRevenue = currentMonthTransactions.fold(
            0.0, (sum, transaction) => sum + transaction.amount);

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
      DateTime now = DateTime.now();
      int currentMonth = now.month;
      int currentYear = now.year;

      totalExpense = 0.0; // Total de despesas

      var response = await _requestHttp.get('transactions/expenses');

      if (response.statusCode == 200) {
        var decodedResponse = utf8.decode(response.bodyBytes);
        List<Transaction> transactions = (json.decode(decodedResponse) as List)
            .map((data) => Transaction.fromJson(data))
            .toList();

        List<Transaction> currentMonthTransactions = transactions
            .where((transaction) =>
                transaction.transactionDate.year == currentYear &&
                transaction.transactionDate.month == currentMonth)
            .toList();

        totalExpense = currentMonthTransactions.fold(
            0.0, (sum, transaction) => sum + transaction.amount);

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
        String responseBody = utf8.decode(response.bodyBytes);

        List<dynamic> decodedResponse = json.decode(responseBody);

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

  Future<void> _loadLatestExpense() async {
    try {
      var response = await _requestHttp.get('transactions/expenses');

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);

        List<dynamic> decodedResponse = json.decode(responseBody);

        List<Transaction> transactions =
            decodedResponse.map((data) => Transaction.fromJson(data)).toList();

        List<Transaction> filteredTransactions =
            transactions.where((transaction) {
          return transaction.transactionDate.year == selectedDate.year;
        }).toList();

        if (filteredTransactions.isEmpty) {
          lastExpense = transactions.reduce(
              (a, b) => a.transactionDate.isAfter(b.transactionDate) ? a : b);
        } else {
          lastExpense = filteredTransactions.reduce(
              (a, b) => a.transactionDate.isAfter(b.transactionDate) ? a : b);
        }

        // print('Última Despesa: ${lastExpense?.description}');

        setState(() {});
      } else {
        print('Erro ao carregar as despesas: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar as despesas: $e');
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
    } finally {
      setState(() {
        _isLoading = false;
      });
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
    TokenStorage tokenStorage = TokenStorage();
    await tokenStorage.clearToken();

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
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF003566),
            ),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await _logout(context);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF003566),
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      await _logout(context);
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
                          // print('Data selecionada: $selectedDate');

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
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF003566)),
                            ),
                          )
                        : hasData
                            ? SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 16),
                                    WhiteCard(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                            child: InfoBox2(
                                              title: lastTransaction
                                                          ?.description !=
                                                      null
                                                  ? 'Última Receita: ${lastTransaction!.description}'
                                                  : 'Sem Receitas',
                                              description: lastTransaction !=
                                                      null
                                                  ? 'R\$ ${lastTransaction!.amount.toStringAsFixed(2)}'
                                                  : '',
                                              creationDate: lastTransaction !=
                                                      null
                                                  ? DateFormat('dd/MM/yyyy')
                                                      .format(lastTransaction!
                                                          .transactionDate)
                                                  : 'Data não disponível',
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
                                            child: InfoBox2(
                                              title: lastExpense?.description !=
                                                      null
                                                  ? 'Última Despesa: ${lastExpense!.description}'
                                                  : 'Sem Despesas',
                                              description: lastExpense != null
                                                  ? 'R\$ ${lastExpense!.amount.toStringAsFixed(2)}'
                                                  : 'R\$ 0.00',
                                              borderColor:
                                                  const Color(0xFF8C1C03),
                                              badgeColor:
                                                  const Color(0xFF003566),
                                              creationDate: lastExpense != null
                                                  ? DateFormat('dd/MM/yyyy')
                                                      .format(lastExpense!
                                                          .createdAt)
                                                  : 'Data não disponível',
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0),
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
                                              borderColor:
                                                  const Color(0xFF003566),
                                              badgeColor:
                                                  const Color(0xFF003566),
                                              creationDate: lastGoal != null
                                                  ? DateFormat('dd/MM/yyyy')
                                                      .format(
                                                          lastGoal!.createdAt)
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
                                                  if (mounted) {
                                                    setState(() {
                                                      _currentPage = page;
                                                    });
                                                  }
                                                },
                                                children: [
                                                  LineGraphic(
                                                    title: 'Últimas Transações',
                                                    transactions:
                                                        last10Transactions,
                                                  ),
                                                  PizzaChart(
                                                    title: 'Resumo do Mês',
                                                    currentMonthRevenue:
                                                        monthlySummary[
                                                                'Receitas'] ??
                                                            0.0,
                                                    currentMonthExpense:
                                                        monthlySummary[
                                                                'Despesas'] ??
                                                            0.0,
                                                  ),
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: List.generate(
                                              3,
                                              (index) => Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
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
                              )
                            : Padding(
                                padding: const EdgeInsets.all(16.0),
                                child:
                                    Image.asset('lib/assets/monetar_home.png'),
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
                          builder: (context) => ProfilePage(
                            userName: userName,
                            email: email,
                          ),
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
              left: 16,
              bottom: 0,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VoicePage(userName: userName),
                        ),
                      );
                    },
                    child: Container(
                      width: 200,
                      height: 150,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('lib/assets/monetar_speak.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
