import 'package:flutter/material.dart';
import 'package:monetar_ia/components/popups/goal_detail_popup.dart';
import 'package:monetar_ia/models/goal.dart';
import 'package:monetar_ia/models/transaction.dart';

class InfoBox extends StatelessWidget {
  final dynamic item; // Pode ser uma Meta (Goal) ou uma Transação (Transaction)
  final String title;
  final String description;
  final bool showBadge;
  final String percentage;
  final Color borderColor;
  final Color badgeColor;
  final String creationDate;

  const InfoBox({
    super.key,
    required this.item,
    required this.title,
    required this.description,
    this.showBadge = false,
    this.percentage = '',
    this.borderColor = const Color(0xFF3D5936),
    this.badgeColor = const Color(0xFF3D5936),
    required this.creationDate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item is Goal) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return GoalDetailPopup(
                goal: item,
                onEdit: (updatedGoal) {
                  // Lógica para editar a meta
                },
                onDelete: (goalId) {
                  // Lógica para excluir a meta
                },
              );
            },
          );
        }
        // Aqui você pode adicionar um comportamento específico para transações, se necessário
      },
      child: Container(
        width: 361,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xFF697077),
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xFF21272A),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (showBadge)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    width: 60,
                    height: 24,
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      percentage,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            Text(
              'Data da criação: $creationDate',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color(0xFF697077),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
