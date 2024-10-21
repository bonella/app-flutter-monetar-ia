import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monetar_ia/services/request_http.dart';
import 'package:monetar_ia/views/goal_page.dart';
import 'package:monetar_ia/utils/form_validations.dart';

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
  final TextEditingController deadlineStringController =
      TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode targetAmountFocusNode = FocusNode();
  final FocusNode currentAmountFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode deadlineFocusNode = FocusNode();

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
    deadlineFocusNode.dispose();
    deadlineStringController.dispose();
    super.dispose();
  }

  final TextStyle errorTextStyle = const TextStyle(
    color: Color(0xFFB00020),
    fontSize: 12,
  );

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
                  validator: validateGoal,
                  textCapitalization: TextCapitalization.words,
                ),
                _buildTextField(
                  controller: targetAmountController,
                  hint: "Valor alvo (R\$)",
                  onChanged: (value) => targetAmount = value,
                  focusNode: targetAmountFocusNode,
                  nextFocusNode: currentAmountFocusNode,
                  isNumeric: true,
                  validator: validateNumericInput,
                ),
                _buildTextField(
                  controller: currentAmountController,
                  hint: "Valor atual (R\$)",
                  onChanged: (value) => currentAmount = value,
                  focusNode: currentAmountFocusNode,
                  isNumeric: true,
                  nextFocusNode: descriptionFocusNode,
                  validator: validateNumericInput,
                ),
                _buildTextField(
                  controller: descriptionController,
                  hint: "Descrição",
                  onChanged: (value) => description = value,
                  focusNode: descriptionFocusNode,
                  nextFocusNode: deadlineFocusNode,
                  validator: validateGoal,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 16),
                _buildDateField(
                  hint: _deadline == null
                      ? "Data Limite"
                      : DateFormat('dd/MM/yyyy').format(_deadline!),
                  selectedDate: _deadline,
                  onTap: () async {
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
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _deadline = selectedDate;
                        _dateError = null;
                        deadlineStringController.text =
                            DateFormat('dd/MM/yyyy').format(selectedDate);
                      });
                    }
                  },
                  focusNode: deadlineFocusNode,
                  errorText: _dateError,
                  controller: deadlineStringController,
                  onChanged: (value) {
                    setState(() {
                      _dateError = validateDateString(value);
                      if (_dateError == null) {
                        _deadline = DateFormat('dd/MM/yyyy').parse(value);
                      } else {
                        _deadline = null;
                      }
                    });
                  },
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const GoalPage()),
                  (Route<dynamic> route) => false,
                );
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

                    showSnackbar('Meta salva com sucesso!');
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const GoalPage()),
                    );

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const GoalPage()),
                      (Route<dynamic> route) => false,
                    );
                  } catch (error) {
                    showSnackbar(
                        'Erro ao salvar a meta! \n Tente mais tarde ou verifique os campos digitados.');
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const GoalPage()),
                    );
                  }
                } else {
                  setState(() {
                    _dateError =
                        _deadline == null ? 'Data é obrigatório' : null;
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
    required FocusNode focusNode,
    String? errorText,
    required TextEditingController controller,
    required Function(String) onChanged,
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
                focusNode: focusNode,
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
                onChanged: onChanged,
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
    required FocusNode focusNode,
    required FocusNode nextFocusNode,
    bool isNumeric = false,
    String? Function(String?)? validator,
    TextCapitalization? textCapitalization,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      focusNode: focusNode,
      textInputAction: TextInputAction.next,
      keyboardType: isNumeric
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 99, 99, 99)),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 99, 99, 99)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      validator: validator,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(nextFocusNode);
      },
    );
  }
}
