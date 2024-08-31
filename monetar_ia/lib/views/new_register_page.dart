import 'package:flutter/material.dart';
import 'package:monetar_ia/components/headers/header_new_register.dart';
import 'package:monetar_ia/components/cards/white_card.dart';
import 'package:monetar_ia/components/footers/footer.dart';
import 'package:monetar_ia/components/buttons/round_btn.dart';
import 'package:monetar_ia/components/inputs/input_new_register.dart';

class NewRegisterPage extends StatefulWidget {
  const NewRegisterPage({super.key});

  @override
  _NewRegisterPageState createState() => _NewRegisterPageState();
}

class _NewRegisterPageState extends State<NewRegisterPage> {
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const HeaderNewRegister(
                                backgroundColor: Color(0xFF697077),
                                title: 'Novo Registro',
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const InputNewRegister(
                                      labelText: 'Nome do Registro',
                                      hintText: 'Digite o nome do registro',
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Tipo',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Column(
                                      children: [
                                        ListTile(
                                          title: const Text('Receita'),
                                          leading: Radio<String>(
                                            value: 'Receita',
                                            groupValue: selectedType,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedType = value;
                                              });
                                            },
                                            activeColor: Colors.green,
                                          ),
                                        ),
                                        ListTile(
                                          title: const Text('Despesa'),
                                          leading: Radio<String>(
                                            value: 'Despesa',
                                            groupValue: selectedType,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedType = value;
                                              });
                                            },
                                            activeColor: Colors.red,
                                          ),
                                        ),
                                        ListTile(
                                          title: const Text('Meta'),
                                          leading: Radio<String>(
                                            value: 'Meta',
                                            groupValue: selectedType,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedType = value;
                                              });
                                            },
                                            activeColor: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    const InputNewRegister(
                                      labelText: 'Valor do Registro',
                                      hintText: 'Digite o valor',
                                    ),
                                    const SizedBox(height: 16),
                                    const InputNewRegister(
                                      labelText: 'Descrição',
                                      hintText: 'Digite a descrição',
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Status',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Column(
                                      children: [
                                        ListTile(
                                          title: const Text('Obrigatório'),
                                          leading: Radio<String>(
                                            value: 'Obrigatório',
                                            groupValue: selectedStatus,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedStatus = value;
                                              });
                                            },
                                            activeColor: Colors.grey,
                                          ),
                                        ),
                                        ListTile(
                                          title: const Text('Supérfluo'),
                                          leading: Radio<String>(
                                            value: 'Supérfluo',
                                            groupValue: selectedStatus,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedStatus = value;
                                              });
                                            },
                                            activeColor: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 100),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
            bottom: 55,
            left: MediaQuery.of(context).size.width / 2 - 30,
            child: RoundButton(
              icon: Icons.check,
              backgroundColor: Colors.white,
              borderColor: const Color(0xFF697077),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
