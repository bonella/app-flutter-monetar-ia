import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monetar_ia/models/goal.dart';
import 'package:monetar_ia/services/request_http.dart';
import 'package:monetar_ia/views/goal_page.dart';

class GoalDetailPopup extends StatefulWidget {
  final Goal goal;
  final Function(Goal) onEdit;
  final Function(int) onDelete;

  const GoalDetailPopup({
    super.key,
    required this.goal,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  _GoalDetailPopupState createState() => _GoalDetailPopupState();
}

class _GoalDetailPopupState extends State<GoalDetailPopup> {
  final RequestHttp _requestHttp = RequestHttp();
  late TextEditingController _nameController;
  late TextEditingController _targetAmountController;
  late TextEditingController _currentAmountController;
  late TextEditingController _descriptionController;
  late DateTime _deadline;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.goal.name);
    _targetAmountController = TextEditingController(
        text: widget.goal.targetAmount.toStringAsFixed(2));
    _currentAmountController = TextEditingController(
        text: widget.goal.currentAmount.toStringAsFixed(2));
    _descriptionController =
        TextEditingController(text: widget.goal.description ?? '');
    _deadline = widget.goal.deadline;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetAmountController.dispose();
    _currentAmountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          _buildImage(),
          const SizedBox(height: 8),
          Text(
            widget.goal.name,
            style: const TextStyle(color: Color(0xFF003566)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildEditableRow('Nome:', _nameController),
              _buildEditableRow('Valor Alvo:', _targetAmountController,
                  isNumeric: true),
              _buildEditableRow('Valor Atual:', _currentAmountController,
                  isNumeric: true),
              _buildDetailRow('Progresso:',
                  '${double.tryParse(widget.goal.percentage)?.toStringAsFixed(2) ?? '0.00'}%'),
              _buildEditableRow('Descrição:', _descriptionController),
              _buildDetailRow('Criado em:', widget.goal.creationDate),
              _buildDeadlineRow(
                  'Vence em:', DateFormat('dd/MM/yyyy').format(_deadline)),
              const Divider(thickness: 5, color: Colors.grey),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                _confirmDelete(context, widget.goal.id);
              },
              child: const Text(
                'Excluir',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: _toggleEdit,
              child: Text(
                _isEditing ? 'Salvar' : 'Editar',
                style: const TextStyle(color: Color(0xFF003566)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Fechar',
                style: TextStyle(color: Color(0xFF003566)),
              ),
            ),
          ],
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
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

  Widget _buildEditableRow(String label, TextEditingController controller,
      {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: _isEditing ? () => controller.text = "" : null,
        child: Container(
          decoration: BoxDecoration(
            border: _isEditing
                ? const Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  )
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$label ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: _isEditing,
                  keyboardType: isNumeric
                      ? const TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.text,
                  style: TextStyle(
                    fontSize: 14,
                    color: _isEditing ? Colors.grey : Colors.black,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: _isEditing ? capitalize('Digite $label') : '',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(115, 34, 34, 34),
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.only(bottom: 0),
                  ),
                ),
              ),
              if (_isEditing)
                const Icon(
                  Icons.edit,
                  color: Color(0xFF003566),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeadlineRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: _isEditing ? _selectDeadline : null,
        child: Container(
          decoration: BoxDecoration(
            border: _isEditing
                ? const Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  )
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$label ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    color: _isEditing ? Colors.grey : Colors.black,
                  ),
                ),
              ),
              if (_isEditing)
                const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF003566),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _confirmDelete(BuildContext context, int goalId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Tem certeza de que deseja excluir esta meta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              await _requestHttp.deleteGoal(goalId);
              widget.onDelete(goalId);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const GoalPage()),
              );
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _toggleEdit() {
    if (_isEditing) {
      _saveEditedGoal();
    } else {
      setState(() {
        _isEditing = true;
      });
    }
  }

  void _saveEditedGoal() async {
    double targetAmount =
        double.tryParse(_targetAmountController.text.replaceAll(',', '.')) ?? 0;
    double currentAmount =
        double.tryParse(_currentAmountController.text.replaceAll(',', '.')) ??
            0;

    Goal editedGoal = Goal(
      id: widget.goal.id,
      userId: widget.goal.userId,
      name: _nameController.text,
      targetAmount: targetAmount,
      currentAmount: currentAmount,
      description: _descriptionController.text,
      deadline: _deadline,
      createdAt: widget.goal.createdAt,
      updatedAt: DateTime.now(),
    );

    try {
      Map<String, dynamic> goalData = {
        'name': editedGoal.name,
        'target_amount': editedGoal.targetAmount,
        'current_amount': editedGoal.currentAmount,
        'description': editedGoal.description,
        'deadline': editedGoal.deadline.toIso8601String(),
      };

      final response = await _requestHttp.updateGoal(editedGoal.id, goalData);

      if (response.statusCode == 200 || response.statusCode == 204) {
        widget.onEdit(editedGoal);
        setState(() {
          _isEditing = false;
        });
        showSnackbar('Meta atualizada com sucesso!');
        Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GoalPage()),
        );
      } else {
        Navigator.of(context).pop();
        showSnackbar(
            'Erro ao atualizar.\nTente novamente mais tarde ou verifique os campos digitados.');
        print('Erro do backend: ${response.body}');
      }
    } catch (error) {
      Navigator.of(context).pop();
      showSnackbar(
          'Atualização não concluída.\nTente novamente mais tarde ou verifique os campos digitados');
      print('Erro: $error');
    }
  }

  void _selectDeadline() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF003566),
            colorScheme: const ColorScheme.light(primary: Color(0xFF003566)),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != _deadline) {
      setState(() {
        _deadline = pickedDate;
      });
    }
  }

  String capitalize(String value) {
    return value[0].toUpperCase() + value.substring(1);
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
