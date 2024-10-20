import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monetar_ia/components/headers/header_home.dart';
import 'package:monetar_ia/components/boxes/info_box.dart';
import 'package:monetar_ia/components/graphics/line_graphic.dart';
import 'package:monetar_ia/components/graphics/pie_chart.dart';
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
  final RequestHttp _requestHttp = RequestHttp();

  @override
  void initState() {
    super.initState();
    _showStayConnectedDialog();
    _loadUserName();
    _loadLatestTransaction();
    ();
    _loadLastGoal();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('userName');
    setState(() {
      userName = name ?? 'Usuário';
    });
  }

  Future<void> _loadLatestTransaction() async {
    try {
      var response = await _requestHttp.get('/transactions');
      if (response.statusCode == 200) {
        List<dynamic> decodedResponse = json.decode(response.body);

        List<Transaction> transactions =
            decodedResponse.map((data) => Transaction.fromJson(data)).toList();

        if (transactions.isNotEmpty) {
          lastTransaction = transactions.reduce(
              (a, b) => a.transactionDate.isAfter(b.transactionDate) ? a : b);

          setState(() {});
        } else {
          print('Nenhuma transação encontrada.');
        }
      } else {
        print('Erro ao carregar as transações: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar as transações: $e');
    }
  }

  Future<void> _loadLastGoal() async {
    try {
      var response = await _requestHttp.get('goals?limit=1');
      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        lastGoal = Goal.fromJson(decodedResponse[0]);
        setState(() {});
      }
    } catch (e) {
      print('Erro ao carregar a última meta: $e');
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
                        });
                      },
                    ),
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
                                  child: InfoBox(
                                    item: lastTransaction,
                                    title: lastTransaction?.description ??
                                        'Último Registro',
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
                                  child: InfoBox(
                                    item: lastGoal,
                                    title: lastGoal?.name ?? 'Última Meta',
                                    description: lastGoal != null
                                        ? 'R\$ ${lastGoal!.currentAmount.toStringAsFixed(2)} / ${lastGoal!.targetAmount.toStringAsFixed(2)} (${((lastGoal!.currentAmount / lastGoal!.targetAmount) * 100).toStringAsFixed(0)}%)'
                                        : '',
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
                                      children: const [
                                        LineGraphic(title: 'Últimas compras'),
                                        CustomPieChart(
                                            title: 'Distribuição de despesas'),
                                        ColumnChart(
                                            title:
                                                'Comparativo de receitas e despesas'),
                                      ],
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
