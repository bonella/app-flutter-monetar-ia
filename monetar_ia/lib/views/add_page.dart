import 'package:flutter/material.dart';
import 'package:monetar_ia/components/headers/header_first_steps.dart';
import 'package:monetar_ia/components/cards/card_add.dart';
import 'package:monetar_ia/components/footers/footer.dart';
import 'package:monetar_ia/components/buttons/round_btn.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String? selectedType;
  String? selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color(0xFF697077),
            child: Column(
              children: [
                // Adicionando o Header
                const HeaderFirstSteps(
                  title: 'Monetar.ia',
                  subtitle: 'Novo Registro',
                  backgroundColor: Color(0xFF697077),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CardAdd(
                          selectedType: selectedType,
                          onTypeChanged: (value) {
                            setState(() {
                              selectedType = value;
                            });
                          },
                          selectedStatus: selectedStatus,
                          onStatusChanged: (value) {
                            setState(() {
                              selectedStatus = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Footer(
                  backgroundColor: Color(0xFF697077),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: RoundButton(
              icon: Icons.check,
              backgroundColor: Colors.white,
              borderColor: const Color(0xFF697077),
              iconColor: const Color(0xFF697077),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
