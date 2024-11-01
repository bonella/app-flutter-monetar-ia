import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monetar_ia/models/transaction.dart';
import 'package:monetar_ia/models/category.dart';
import 'package:monetar_ia/views/revenue_page.dart';

class TransactionDetailPopup extends StatefulWidget {
  final Transaction transaction;
  final Function(String, String, double, String, String, DateTime)
      onUpdateTransaction;
  final Function(String) onDeleteTransaction;
  final Future<List<Category>> Function() loadCategories;

  const TransactionDetailPopup({
    super.key,
    required this.transaction,
    required this.onUpdateTransaction,
    required this.onDeleteTransaction,
    required this.loadCategories,
  });

  @override
  _TransactionDetailPopupState createState() => _TransactionDetailPopupState();
}

class _TransactionDetailPopupState extends State<TransactionDetailPopup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String description = '';
  double amount = 0.0;
  DateTime? transactionDate;
  int? selectedCategoryId;
  List<Category> categories = [];
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
    _fetchCategories();
  }

  void _initializeFields() {
    amountController.text = widget.transaction.amount.toStringAsFixed(2);
    descriptionController.text = widget.transaction.description ?? '';
    transactionDate = widget.transaction.transactionDate;
    selectedCategoryId = widget.transaction.categoryId;
  }

  Future<void> _fetchCategories() async {
    try {
      final fetchedCategories = await widget.loadCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (e) {
      print('Erro ao carregar categorias: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: _buildTitle(),
      content: _buildContent(),
      actions: _buildActionButtons(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        _buildImage(),
        const SizedBox(height: 8),
        Text(
          widget.transaction.type == 'INCOME'
              ? 'Detalhes da Receita'
              : 'Detalhes da Despesa',
          style: const TextStyle(color: Color(0xFF003566)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEditableRow('Valor (R\$):', amountController,
                  isNumeric: true),
              _buildDropdownRow('Categoria:', selectedCategoryId),
              _buildEditableRow('Descrição:', descriptionController),
              _buildFixedRow('Criado em:',
                  DateFormat('dd/MM/yyyy').format(transactionDate!)),
              const Divider(thickness: 5, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('lib/assets/logo2.png'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }

  List<Widget> _buildActionButtons(BuildContext context) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => _confirmDelete(context),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: _toggleEdit,
            child: Text(_isEditing ? 'Salvar' : 'Editar',
                style: const TextStyle(color: Color(0xFF003566))),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar',
                style: TextStyle(color: Color(0xFF003566))),
          ),
        ],
      ),
    ];
  }

  Widget _buildEditableRow(String label, TextEditingController controller,
      {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: _isEditing ? () => controller.clear() : null,
        child: Container(
          decoration: BoxDecoration(
            border: _isEditing
                ? const Border(
                    bottom: BorderSide(color: Colors.grey, width: 1.0))
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('$label ',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: _isEditing,
                  keyboardType: isNumeric
                      ? const TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.text,
                  style: TextStyle(
                      fontSize: 14,
                      color: _isEditing ? Colors.grey : Colors.black),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: _isEditing ? 'Digite $label' : '',
                    hintStyle: const TextStyle(
                        fontSize: 14, color: Color.fromARGB(115, 34, 34, 34)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(bottom: 0),
                  ),
                ),
              ),
              if (_isEditing) const Icon(Icons.edit, color: Color(0xFF003566)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFixedRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('$label ',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Expanded(
              child: Text(value,
                  style: const TextStyle(fontSize: 14, color: Colors.black))),
        ],
      ),
    );
  }

  Widget _buildDropdownRow(String label, int? selectedValue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: _isEditing
              ? const Border(bottom: BorderSide(color: Colors.grey, width: 1.0))
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('$label ',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Expanded(
              child: DropdownButton<int>(
                value: selectedValue,
                onChanged: _isEditing
                    ? (int? newValue) {
                        setState(() {
                          selectedCategoryId = newValue;
                        });
                      }
                    : null,
                items:
                    categories.map<DropdownMenuItem<int>>((Category category) {
                  return DropdownMenuItem<int>(
                    value: category.id,
                    child: Text(
                      category.name,
                      style: TextStyle(
                          fontSize: 14,
                          color: _isEditing ? Colors.grey : Colors.black),
                    ),
                  );
                }).toList(),
                isExpanded: true,
                hint: const Text('Selecione uma categoria'),
                underline: Container(),
                icon: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  size: _isEditing ? 30 : 20,
                  color: _isEditing ? const Color(0xFF003566) : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _initializeFields();
      } else {
        if (_formKey.currentState!.validate()) {
          try {
            double parsedAmount =
                double.parse(amountController.text.replaceAll(',', '.'));
            if (selectedCategoryId != null) {
              String transactionType = widget.transaction.type;

              widget.onUpdateTransaction(
                widget.transaction.id.toString(),
                selectedCategoryId.toString(),
                parsedAmount,
                transactionType,
                descriptionController.text,
                transactionDate ?? DateTime.now(),
              );
              Navigator.of(context).pop();
            } else {
              _showError('Selecione uma categoria válida.');
            }
          } catch (e) {
            print('Erro ao converter valor: $e');
          }
        }
      }
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content:
              const Text('Tem certeza de que deseja excluir esta transação?'),
          actions: [
            TextButton(
              onPressed: () {
                widget.onDeleteTransaction(widget.transaction.id.toString());
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const RevenuePage()),
                );
              },
              child: const Text('Sim', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Não', style: TextStyle(color: Color(0xFF003566))),
            ),
          ],
        );
      },
    );
  }
}
