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
import 'package:monetar_ia/components/popups/transaction_detail_popup.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  DateTime selectedDate = DateTime.now();
  List<Transaction> expenses = [];
  List<Transaction> filteredExpenses = [];
  List<Category> categories = [];
  final RequestHttp _requestHttp = RequestHttp();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
    loadCategories();
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

  Future<List<Category>> loadCategories() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    try {
      var response = await _requestHttp.get('categories?date=$formattedDate');

      if (response.statusCode == 200) {
        var decodedResponse = utf8.decode(response.bodyBytes);
        return (json.decode(decodedResponse) as List)
            .map((category) => Category.fromJson(category))
            .toList();
      } else {
        throw Exception('Falha ao carregar categorias: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackbar('Erro ao carregar categorias: $e');
      return [];
    }
  }

  Future<void> _loadExpenses() async {
    setState(() {
      _isLoading = true;
    });

    String formattedDate = DateFormat('yyyy-MM').format(selectedDate);

    try {
      var response = await _requestHttp
          .get('transactions?type=EXPENSE&date=$formattedDate');
      if (response.statusCode == 200) {
        setState(() {
          expenses = (json.decode(response.body) as List)
              .map((expense) => Transaction.fromJson(expense))
              .toList();

          expenses
              .sort((a, b) => b.transactionDate.compareTo(a.transactionDate));

          filteredExpenses = List.from(expenses);
          _isLoading = false;
        });
      } else {
        _showErrorSnackbar('Erro ao carregar despesas: ${response.statusCode}');
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

  void _filterExpenses(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        filteredExpenses = List.from(expenses);
      } else {
        filteredExpenses = expenses
            .where((expense) =>
                expense.description != null &&
                expense.description!
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()))
            .toList();
      }
    });
  }

  double _calculateTotalExpenses() {
    return filteredExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  void _showAddTransactionPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AddTransactionPopup(
          onSave:
              (userId, amount, categoryId, description, transactionDate, type) {
            _loadExpenses();
          },
          transactionType: 'EXPENSE',
          loadCategories: loadCategories,
        );
      },
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showTransactionDetailPopup(
      BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TransactionDetailPopup(
          transaction: transaction,
          onUpdate:
              (userId, type, amount, categoryId, description, transactionDate) {
            int parsedCategoryId = int.tryParse(categoryId) ?? -1;

            if (type != 'INCOME' && type != 'EXPENSE') {
              _showErrorSnackbar('Tipo inválido. Deve ser INCOME ou EXPENSE.');
              return;
            }

            _requestHttp.put('transactions/${transaction.id}', {
              'user_id': userId,
              'type': type,
              'amount': amount,
              'category_id': parsedCategoryId,
              'description': description,
              'transaction_date': transactionDate.toIso8601String(),
            }).then((response) {
              if (response.statusCode == 200) {
                _loadExpenses();
              } else {
                _showErrorSnackbar(
                    'Erro ao atualizar transação: ${response.statusCode}');
              }
            }).catchError((e) {
              _showErrorSnackbar('Erro ao atualizar transação: $e');
            });
          },
          onDelete: (String transactionId) {
            _deleteTransaction(transactionId);
          },
          loadCategories: loadCategories,
        );
      },
    );
  }

  Future<void> _deleteTransaction(String transactionId) async {
    try {
      var response = await _requestHttp.delete('transactions/$transactionId');
      if (response.statusCode == 200) {
        _loadExpenses();
        _showErrorSnackbar('Transação excluída com sucesso.');
      } else {
        _showErrorSnackbar(
            'Erro ao excluir a transação: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackbar('Erro ao excluir a transação: $e');
    }
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
                onSearch: _filterExpenses,
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredExpenses.isEmpty
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
                                      children: filteredExpenses.map((expense) {
                                        return GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            _showTransactionDetailPopup(
                                                context, expense);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: InfoBox(
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
                                          ),
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
