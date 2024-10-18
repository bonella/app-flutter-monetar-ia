import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monetar_ia/services/request_http.dart';
import 'package:monetar_ia/utils/form_validations.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:monetar_ia/models/category.dart';

class AddTransactionPopup extends StatefulWidget {
  final Function(int, String, double, String, String, DateTime?) onSave;
  final String transactionType;
  final List<Category> categories;

  const AddTransactionPopup({
    super.key,
    required this.onSave,
    required this.transactionType,
    required this.categories,
  });

  @override
  _AddTransactionPopupState createState() => _AddTransactionPopupState();
}

class _AddTransactionPopupState extends State<AddTransactionPopup> {
  final _formKey = GlobalKey<FormState>();
  String type = '';
  String categoryId = '';
  String description = '';
  double amount = 0.0;
  DateTime? transactionDate;
  String? _dateError;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController transactionDateStringController =
      TextEditingController();

  final RequestHttp _requestHttp = RequestHttp();

  final FocusNode amountFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode transactionDateFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    type = widget.transactionType;
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    transactionDateStringController.dispose();
    amountFocusNode.dispose();
    descriptionFocusNode.dispose();
    transactionDateFocusNode.dispose();
    super.dispose();
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      title: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: ClipOval(
              child: Image.asset(
                'lib/assets/logo2.png',
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              type == 'EXPENSE' ? 'Adicionar Despesa' : 'Adicionar Receita',
              style: const TextStyle(color: Color(0xFF003566)),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: categoryId.isEmpty ? null : categoryId,
                  hint: const Text("Categoria"),
                  items: widget.categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category.id.toString(),
                      child: Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF003566),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      categoryId = value ?? '';
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Categoria é obrigatória' : null,
                  decoration: const InputDecoration(
                    hintText: "Selecione a Categoria",
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 99, 99, 99)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 99, 99, 99)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF003566), width: 2),
                    ),
                  ),
                ),
                _buildTextField(
                  controller: amountController,
                  focusNode: amountFocusNode,
                  hint: "Valor (R\$)",
                  onChanged: (value) {
                    amount = double.tryParse(value
                            .replaceAll('R\$', '')
                            .replaceAll('.', '')
                            .replaceAll(',', '')) ??
                        0.0;
                  },
                  isNumeric: true,
                  validator: validateNumericInput,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(descriptionFocusNode);
                  },
                ),
                _buildTextField(
                  controller: descriptionController,
                  focusNode: descriptionFocusNode,
                  hint: "Descrição",
                  onChanged: (value) => description = value,
                  validator: validateGoal,
                  textCapitalization: TextCapitalization.sentences,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context)
                        .requestFocus(transactionDateFocusNode);
                  },
                ),
                const SizedBox(height: 16),
                _buildDateField(
                  hint: transactionDate == null
                      ? "Data da Transação"
                      : DateFormat('dd/MM/yyyy').format(transactionDate!),
                  selectedDate: transactionDate,
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: transactionDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: const Color(0xFF003566),
                            colorScheme: const ColorScheme.light(
                                primary: Color(0xFF003566)),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (selectedDate != null) {
                      setState(() {
                        transactionDate = selectedDate;
                        _dateError = null;
                        transactionDateStringController.text =
                            DateFormat('dd/MM/yyyy').format(selectedDate);
                      });
                    }
                  },
                  errorText: _dateError,
                  controller: transactionDateStringController,
                ),
                const Divider(thickness: 5, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              child: const Text('Cancelar',
                  style: TextStyle(color: Color(0xFF003566))),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Salvar',
                  style: TextStyle(color: Color(0xFF003566))),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    final transactionData = {
                      "user_id": 0,
                      "amount": amount,
                      "type": type,
                      "category_id": int.parse(categoryId),
                      "description": description,
                      "transaction_date":
                          transactionDate?.toIso8601String() ?? '',
                    };

                    await _requestHttp.createTransaction(transactionData);
                    showSnackbar('Transação salva com sucesso!');
                    Navigator.pop(context);
                  } catch (error) {
                    showSnackbar(
                        'Erro ao salvar a transação! Tente mais tarde ou verifique os campos digitados.');
                  }
                } else {
                  setState(() {
                    _dateError =
                        transactionDate == null ? 'Data é obrigatória' : null;
                  });
                }
              },
            ),
          ],
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(16),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    );
  }

  Widget _buildDateField({
    required String hint,
    DateTime? selectedDate,
    required VoidCallback onTap,
    String? errorText,
    required TextEditingController controller,
  }) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              onTap();
            },
            child: AbsorbPointer(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle:
                      const TextStyle(color: Color.fromARGB(255, 99, 99, 99)),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 99, 99, 99)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF003566), width: 2),
                  ),
                  errorText: errorText,
                ),
                controller: controller,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today, color: Color(0xFF003566)),
          onPressed: () {
            FocusScope.of(context).unfocus();
            onTap();
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required ValueChanged<String> onChanged,
    FocusNode? focusNode,
    bool isNumeric = false,
    String? Function(String?)? validator,
    TextCapitalization textCapitalization = TextCapitalization.none,
    ValueChanged<String>? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: isNumeric
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      textCapitalization: textCapitalization,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 99, 99, 99)),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 99, 99, 99)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF003566), width: 2),
        ),
      ),
      validator: validator,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
