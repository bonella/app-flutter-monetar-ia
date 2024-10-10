import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monetar_ia/models/goal.dart';
import 'package:monetar_ia/services/request_http.dart';

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
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Valor Alvo:',
                'R\$ ${widget.goal.targetAmount.toStringAsFixed(2)}'),
            _buildDetailRow('Valor Atual:',
                'R\$ ${widget.goal.currentAmount.toStringAsFixed(2)}'),
            _buildDetailRow('Progresso:', '${widget.goal.percentage}%'),
            _buildDetailRow(
                'Descrição:', widget.goal.description ?? 'Sem descrição'),
            _buildDetailRow('Data Limite:',
                DateFormat('dd/MM/yyyy').format(widget.goal.deadline)),
            _buildDetailRow('Criado em:', widget.goal.creationDate),
          ],
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
              onPressed: () {
                Navigator.of(context).pop();
                widget.onEdit(widget.goal);
              },
              child: const Text(
                'Editar',
                style: TextStyle(color: Color(0xFF003566)),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
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
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
