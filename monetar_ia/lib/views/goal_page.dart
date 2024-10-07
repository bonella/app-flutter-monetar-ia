import 'package:flutter/material.dart';
import 'package:monetar_ia/services/request_http.dart';
import 'package:monetar_ia/models/goal.dart'; // Importar a classe Goal
import 'package:monetar_ia/services/token_storage.dart'; // Importar a classe TokenStorage

class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  List<Goal> goals = []; // Armazenar objetos do tipo Goal
  final RequestHttp _requestHttp = RequestHttp();
  final TokenStorage _tokenStorage =
      TokenStorage(); // Crie uma instância de TokenStorage

  @override
  void initState() {
    super.initState();
    _loadGoals(); // Carregar metas ao iniciar a página
  }

  Future<void> _loadGoals() async {
    try {
      if (await _tokenStorage.isTokenValid()) {
        goals = await _requestHttp.getGoals();
        print(goals);
        setState(() {});
      } else {
        print("Token não está disponível. Faça login novamente.");
        // Navegar para a página de login ou exibir uma mensagem
      }
    } catch (error) {
      print("Erro ao carregar metas: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metas'),
      ),
      body: goals.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                return ListTile(
                  title: Text(
                      goal.name), // Acesso à propriedade name da classe Goal
                  subtitle: Text(
                      'Valor alvo: ${goal.targetAmount}'), // Acesso à propriedade targetAmount
                  trailing: Text(
                      'Atual: ${goal.currentAmount}'), // Acesso à propriedade currentAmount
                );
              },
            ),
    );
  }
}
