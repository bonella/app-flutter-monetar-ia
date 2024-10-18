import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:monetar_ia/components/headers/header_add.dart';
import 'package:monetar_ia/components/cards/white_card.dart';
import 'package:monetar_ia/components/boxes/info_box.dart';
import 'package:monetar_ia/components/footers/footer.dart';
import 'package:monetar_ia/components/buttons/round_btn.dart';
import 'package:monetar_ia/models/transaction.dart';
import 'package:monetar_ia/models/category.dart';
import 'package:monetar_ia/services/request_http.dart';
import 'package:monetar_ia/components/popups/add_transaction_popup.dart';

class RevenuePage extends StatefulWidget {
  const RevenuePage({super.key});

  @override
  _RevenuePageState createState() => _RevenuePageState();
}

class _RevenuePageState extends State<RevenuePage> {
  DateTime selectedDate = DateTime.now();
  List<Transaction> revenues = [];
  List<Category> categories = [];
  final RequestHttp _requestHttp = RequestHttp();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRevenues();
    _loadCategories();
  }

  void _onPrevMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, 1);
      _loadRevenues();
    });
  }

  void _onNextMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, 1);
      _loadRevenues();
    });
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
      _loadRevenues();
    });
  }

  Future<void> _loadCategories() async {
    try {
      var response = await _requestHttp.get('categories');
      if (response.statusCode == 200) {
        setState(() {
          categories = (json.decode(response.body) as List)
              .map((category) => Category.fromJson(category))
              .toList();
        });
      } else {
        _showErrorSnackbar(
            'Falha ao carregar categorias: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackbar('Erro ao carregar categorias: $e');
    }
  }

  Future<void> _loadRevenues() async {
    setState(() {
      _isLoading = true;
    });

    String formattedDate = DateFormat('yyyy-MM').format(selectedDate);

    try {
      var response = await _requestHttp
          .get('transactions?type=INCOME&date=$formattedDate');
      if (response.statusCode == 200) {
        setState(() {
          revenues = (json.decode(response.body) as List)
              .map((revenue) => Transaction.fromJson(revenue))
              .toList();
          _isLoading = false;
        });
      } else {
        _showErrorSnackbar('Erro ao carregar receitas: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      _showErrorSnackbar('Erro: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  double _calculateTotalRevenues() {
    return revenues.fold(0.0, (sum, revenue) => sum + revenue.amount);
  }

  void _showAddTransactionPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AddTransactionPopup(
          categories: categories,
          onSave:
              (userId, type, amount, categoryId, description, transactionDate) {
            _loadRevenues();
          },
          transactionType: 'INCOME',
        );
      },
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
                backgroundColor: const Color(0xFF3D5936),
                circleIcon: Icons.attach_money_outlined,
                circleIconColor: Colors.white,
                circleBackgroundColor: const Color(0xFF3D5936),
                label: 'Receitas de $monthDisplay',
                value: 'R\$ ${_calculateTotalRevenues().toStringAsFixed(2)}',
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : revenues.isEmpty
                        ? Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  'lib/assets/fundo_metas2.png',
                                  fit: BoxFit.contain,
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                ),
                              ),
                            ],
                          )
                        : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(height: 16),
                                WhiteCard(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Column(
                                      children: revenues.map((revenue) {
                                        return Column(
                                          children: [
                                            InfoBox(
                                              item: revenue,
                                              title: revenue.description ??
                                                  'Receita',
                                              description:
                                                  'R\$ ${revenue.amount.toStringAsFixed(2)}',
                                              creationDate: revenue
                                                  .formattedTransactionDate,
                                              showBadge: false,
                                              borderColor:
                                                  const Color(0xFF3D5936),
                                              badgeColor:
                                                  const Color(0xFF3D5936),
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
              const Footer(backgroundColor: Color(0xFF3D5936)),
            ],
          ),
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: RoundButton(
              icon: Icons.add,
              backgroundColor: Colors.white,
              borderColor: const Color(0xFF3D5936),
              iconColor: const Color(0xFF3D5936),
              onPressed: _showAddTransactionPopup,
            ),
          ),
        ],
      ),
    );
  }
}
