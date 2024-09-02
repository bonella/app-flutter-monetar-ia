import 'package:flutter/material.dart';

class CardAdd extends StatelessWidget {
  final String? selectedType;
  final ValueChanged<String?> onTypeChanged;
  final String? selectedStatus;
  final ValueChanged<String?> onStatusChanged;

  const CardAdd({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildLabel('Nome do Registro:', context),
              _buildInput(context),
              _buildLabel('Tipo:', context),
              _buildRadioButtons(
                options: ['Receita', 'Despesa', 'Meta'],
                groupValue: selectedType,
                onChanged: onTypeChanged,
                colors: {
                  'Receita': const Color(0xFF3D5936),
                  'Despesa': const Color(0xFF8C1C03),
                  'Meta': const Color(0xFF003566),
                },
              ),
              _buildLabel('Valor do Registro:', context),
              _buildInput(context),
              _buildLabel('Descrição:', context),
              _buildInput(context),
              _buildLabel('Status:', context),
              _buildRadioButtons(
                options: ['Obrigatório', 'Supérfluo'],
                groupValue: selectedStatus,
                onChanged: onStatusChanged,
                colors: {
                  'Obrigatório': const Color(0xFF697077),
                  'Supérfluo': const Color(0xFF8C1C03),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Kumbh Sans',
          fontWeight: FontWeight.w400,
          fontSize: 18,
          color: Color(0xFF3D5936),
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Color(0xFF3D5936),
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Color(0xFF738C61),
              width: 2.0,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          isDense: true,
        ),
        style: const TextStyle(height: 1.5),
      ),
    );
  }

  Widget _buildRadioButtons({
    required List<String> options,
    required String? groupValue,
    required ValueChanged<String?> onChanged,
    required Map<String, Color> colors,
  }) {
    return Column(
      children: options.map((option) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(option),
          leading: Radio<String>(
            value: option,
            groupValue: groupValue,
            onChanged: onChanged,
            activeColor: colors[option] ?? Colors.green,
          ),
        );
      }).toList(),
    );
  }
}
