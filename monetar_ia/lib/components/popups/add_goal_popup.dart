import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monetar_ia/services/request_http.dart';

class AddGoalPopup extends StatefulWidget {
  final Function(String, String, String, String, DateTime?) onSave;

  const AddGoalPopup({super.key, required this.onSave});

  @override
  _AddGoalPopupState createState() => _AddGoalPopupState();
}

class _AddGoalPopupState extends State<AddGoalPopup> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String targetAmount = '';
  String currentAmount = '';
  String description = '';
  DateTime? _deadline;
  String? _dateError;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController targetAmountController = TextEditingController();
  final TextEditingController currentAmountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode targetAmountFocusNode = FocusNode();
  final FocusNode currentAmountFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();

  final RequestHttp _requestHttp = RequestHttp();

  @override
  void dispose() {
    nameController.dispose();
    targetAmountController.dispose();
    currentAmountController.dispose();
    descriptionController.dispose();
    nameFocusNode.dispose();
    targetAmountFocusNode.dispose();
    currentAmountFocusNode.dispose();
    descriptionFocusNode.dispose();
    super.dispose();
  }

  final TextStyle errorTextStyle = const TextStyle(
    color: Color(0xFFB00020),
    fontSize: 12,
  );

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
          const Center(
            child: Text(
              'Adicionar Meta',
              style: TextStyle(color: Color(0xFF003566)),
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
                _buildTextField(
                  controller: nameController,
                  hint: "Nome da meta",
                  onChanged: (value) => name = value,
                  focusNode: nameFocusNode,
                  nextFocusNode: targetAmountFocusNode,
                ),
                _buildTextField(
                  controller: targetAmountController,
                  hint: "Valor alvo (R\$)",
                  onChanged: (value) => targetAmount = value,
                  focusNode: targetAmountFocusNode,
                  nextFocusNode: currentAmountFocusNode,
                  isNumeric: true,
                ),
                _buildTextField(
                  controller: currentAmountController,
                  hint: "Valor atual (R\$)",
                  onChanged: (value) => currentAmount = value,
                  focusNode: currentAmountFocusNode,
                  isNumeric: true,
                  nextFocusNode: descriptionFocusNode,
                ),
                _buildTextField(
                  controller: descriptionController,
                  hint: "Descrição",
                  onChanged: (value) => description = value,
                  focusNode: descriptionFocusNode,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _deadline ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            primaryColor: const Color(0xFF003566),
                            colorScheme: const ColorScheme.light(
                                primary: Color(0xFF003566)),
                            buttonTheme: const ButtonThemeData(
                                textTheme: ButtonTextTheme.primary),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _deadline = selectedDate;
                        _dateError = null;
                      });
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _deadline == null
                        ? "Data Limite"
                        : "Prazo: ${DateFormat('dd/MM/yyyy').format(_deadline!)}",
                    style: TextStyle(
                      color: _deadline == null
                          ? const Color.fromARGB(255, 99, 99, 99)
                          : const Color(0xFF003566),
                      fontSize: 16,
                    ),
                  ),
                ),
                if (_dateError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Text(
                      _dateError!,
                      style: errorTextStyle,
                    ),
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
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Color(0xFF003566)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Salvar',
                style: TextStyle(color: Color(0xFF003566)),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    final goalData = {
                      "user_id": 0,
                      "name": name,
                      "target_amount": int.tryParse(targetAmount
                              .replaceAll('R\$', '')
                              .replaceAll('.', '')
                              .replaceAll(',', '')) ??
                          0,
                      "current_amount": int.tryParse(currentAmount
                              .replaceAll('R\$', '')
                              .replaceAll('.', '')
                              .replaceAll(',', '')) ??
                          0,
                      "description": description,
                      "deadline": _deadline?.toIso8601String() ?? '',
                    };

                    await _requestHttp.createGoal(goalData);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Meta salva com sucesso!'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    Navigator.of(context).pop();
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao salvar a meta: $error'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                } else {
                  setState(() {
                    _dateError = _deadline == null ? 'Defina uma data' : null;
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required Function(String) onChanged,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    bool isNumeric = false,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: (value) {
        if (isNumeric && !value.startsWith('R\$')) {
          value = 'R\$${value.replaceAll('R\$', '').replaceAll(',', '')}';
          controller.text = value;
          controller.selection =
              TextSelection.fromPosition(TextPosition(offset: value.length));
        }
        onChanged(value);
      },
      textCapitalization: TextCapitalization.words,
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
      cursorColor: const Color(0xFF003566),
      validator: (value) {
        if (isNumeric) {
          final isNumericValid = RegExp(r'^\d*\.?\d*$').hasMatch(value!
              .replaceAll('R\$', '')
              .replaceAll('.', '')
              .replaceAll(',', ''));
          if (!isNumericValid) {
            return 'Digite um valor numérico válido';
          }
        }

        return value!.isEmpty ? 'Campo obrigatório' : null;
      },
      focusNode: focusNode,
      onFieldSubmitted: (value) {
        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
      },
    );
  }
}
