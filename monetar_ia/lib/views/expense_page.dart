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
// import 'package:monetar_ia/services/token_storage.dart';
import 'package:monetar_ia/components/popups/add_transaction_popup.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  DateTime selectedDate = DateTime.now();
  List<Transaction> expenses = [];
  List<Category> categories = [];
  final RequestHttp _requestHttp = RequestHttp();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
    _loadCategories();
  }

  void _onPrevMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, 1);
      _loadExpenses();
    });
  }

  void _onNextMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1, 1);
      _loadExpenses();
    });
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
      _loadExpenses();
    });
  }

  Future<void> _loadCategories() async {
    try {
      var response = await _requestHttp.get('categories/');
      if (response.statusCode == 200) {
        setState(() {
          categories = (json.decode(response.body) as List)
              .map((category) => Category.fromJson(category))
              .toList();
        });
      } else {
        throw Exception('Falha ao carregar categorias');
      }
    } catch (e) {
      print('Erro ao carregar categorias: $e');
    }
  }

  Future<void> _loadExpenses() async {
    setState(() {
      _isLoading = true;
    });

    String formattedDate = DateFormat('yyyy-MM').format(selectedDate);

    try {
      var response = await _requestHttp.get('transactions?date=$formattedDate');

      if (response.statusCode == 200) {
        setState(() {
          expenses = (json.decode(response.body) as List)
              .map((expense) => Transaction.fromJson(expense))
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Erro ao carregar despesas: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Erro: $e');
    }
  }

  double _calculateTotalExpenses() {
    return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  void _showAddTransactionPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AddTransactionPopup(
          categories: categories,
          onSave: (userId, type, amount, categoryId, description,
              transactionDate) async {
            if (transactionDate == null) {
              print('Data da transação não pode ser nula.');
              return;
            }

            Map<String, dynamic> transactionData = {
              'user_id': userId,
              'amount': amount,
              'type': type,
              'category_id': categoryId,
              'description': description,
              'transaction_date': transactionDate.toIso8601String(),
            };

            try {
              await _requestHttp.createTransaction(transactionData);
              _loadExpenses();
              Navigator.of(context).pop();
            } catch (e) {
              print('Erro ao salvar transação: $e');
            }
          },
          transactionType: 'EXPENSE',
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
          Column(
            children: [
              HeaderAdd(
                month: monthDisplay,
                onPrevMonth: _onPrevMonth,
                onNextMonth: _onNextMonth,
                onDateChanged: _onDateChanged,
                backgroundColor: const Color(0xFF8C1C03),
                circleIcon: Icons.money_off,
                circleIconColor: Colors.white,
                circleBackgroundColor: const Color(0xFF8C1C03),
                label: 'Despesas de $monthDisplay',
                value: 'R\$ ${_calculateTotalExpenses().toStringAsFixed(2)}',
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : expenses.isEmpty
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
                                      children: expenses.map((expense) {
                                        return Column(
                                          children: [
                                            InfoBox(
                                              item: expense,
                                              title: expense.description ??
                                                  'Despesa',
                                              description:
                                                  'R\$ ${expense.amount.toStringAsFixed(2)}',
                                              creationDate: expense
                                                  .formattedTransactionDate,
                                              showBadge: false,
                                              borderColor:
                                                  const Color(0xFF8C1C03),
                                              badgeColor:
                                                  const Color(0xFF8C1C03),
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
              onPressed: _showAddTransactionPopup,
            ),
          ),
        ],
      ),
    );
  }
}
