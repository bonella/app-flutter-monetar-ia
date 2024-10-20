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

class RevenuePage extends StatefulWidget {
  const RevenuePage({super.key});

  @override
  _RevenuePageState createState() => _RevenuePageState();
}

class _RevenuePageState extends State<RevenuePage> {
  DateTime selectedDate = DateTime.now();
  List<Transaction> revenues = [];
  List<Transaction> filteredRevenues = [];
  List<Category> categories = [];
  final RequestHttp _requestHttp = RequestHttp();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRevenues();
    loadCategories();
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

          revenues
              .sort((a, b) => b.transactionDate.compareTo(a.transactionDate));

          filteredRevenues = List.from(revenues);
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

  void _filterRevenues(String searchTerm) {
    setState(() {
      if (searchTerm.isEmpty) {
        filteredRevenues = List.from(revenues);
      } else {
        filteredRevenues = revenues
            .where((revenue) =>
                revenue.description != null &&
                revenue.description!
                    .toLowerCase()
                    .contains(searchTerm.toLowerCase()))
            .toList();
      }
    });
  }

  double _calculateTotalRevenues() {
    return filteredRevenues.fold(0.0, (sum, revenue) => sum + revenue.amount);
  }

  void _showAddTransactionPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AddTransactionPopup(
          onSave:
              (userId, amount, categoryId, description, transactionDate, type) {
            _loadRevenues();
          },
          transactionType: 'INCOME',
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
            print('Updating transaction with:');
            print('userId: $userId');
            print('type: $type');
            print('amount: $amount');
            print('categoryId: $categoryId');
            print('description: $description');
            print('transactionDate: $transactionDate');

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
                _loadRevenues();
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
        _loadRevenues();
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
                backgroundColor: const Color(0xFF3D5936),
                circleIcon: Icons.attach_money_outlined,
                circleIconColor: Colors.white,
                circleBackgroundColor: const Color(0xFF3D5936),
                label: 'Receitas de $monthDisplay',
                value: 'R\$ ${_calculateTotalRevenues().toStringAsFixed(2)}',
                onSearch: _filterRevenues,
              ),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFF003566)),
                        ),
                      )
                    : filteredRevenues.isEmpty
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
                                      children: filteredRevenues.map((revenue) {
                                        return GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            _showTransactionDetailPopup(
                                                context, revenue);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: InfoBox(
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
