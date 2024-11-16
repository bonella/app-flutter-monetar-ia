import 'package:flutter/material.dart';
import 'package:monetar_ia/components/footers/footer.dart';
import 'package:monetar_ia/components/headers/header_basics.dart';
import 'package:monetar_ia/components/inputs/custom_text_field.dart';
import 'package:monetar_ia/components/buttons/btn_outline_green.dart';
import 'package:monetar_ia/services/request_http.dart';
import 'package:monetar_ia/components/popups/change_password_popup.dart';
import 'package:monetar_ia/models/category.dart';
import 'package:monetar_ia/services/token_storage.dart';
import 'package:monetar_ia/views/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String email;

  const ProfilePage({super.key, required this.userName, required this.email});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final RequestHttp requestHttp = RequestHttp();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _categoryFocusNode = FocusNode();

  bool _isLoading = false;
  bool _isEditingName = false;
  bool _isEditingLastName = false;
  final bool _isEditingCategory = false;

  String updatedName = '';
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    updatedName = widget.userName;
    _nameController.text = updatedName;
    _loadCategories();
    print(_loadCategories());
  }

  Future<void> _logout(BuildContext context) async {
    TokenStorage tokenStorage = TokenStorage();
    await tokenStorage.clearToken();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('stayConnected');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  // Função para carregar as categorias
  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await requestHttp.getCategories();
      setState(() {
        _categories = response;
      });
    } catch (e) {
      print("Erro ao carregar categorias: $e");
      // Exibir erro
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// Função para exibir o diálogo de criação/edição de categoria
  void _showCategoryDialog([Category? category]) {
    final TextEditingController nameController =
        TextEditingController(text: category != null ? category.name : "");
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            category == null ? 'Nova Categoria' : 'Editar Categoria',
            style: const TextStyle(
              color: Color(0xFF003566), // Cor do título
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nome da Categoria'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Informe o nome da categoria';
                }
                return null;
              },
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Color(0xFF003566)),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final name = nameController.text.trim();
                      final categoryData = {
                        'name': name,
                        'type': 'INCOME',
                        "user_id": 1,
                      };

                      if (category == null) {
                        // Criar nova categoria
                        await _createCategory(categoryData);
                      } else {
                        // Atualizar categoria
                        await _updateCategory(category.id, categoryData);
                      }

                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    category == null ? 'Criar' : 'Atualizar',
                    style: const TextStyle(color: Color(0xFF003566)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Função para criar categoria
  Future<void> _createCategory(Map<String, dynamic> categoryData) async {
    try {
      await requestHttp.createCategory(Category.fromJson(categoryData));
      _loadCategories();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoria criada com sucesso!')));
    } catch (e) {
      print('Erro ao criar categoria: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao criar categoria.')));
    }
  }

  // Função para atualizar categoria
  Future<void> _updateCategory(
      int categoryId, Map<String, dynamic> categoryData) async {
    try {
      await requestHttp.updateCategory(
          categoryId, Category.fromJson(categoryData));
      _loadCategories();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoria atualizada com sucesso!')));
    } catch (e) {
      print('Erro ao atualizar categoria: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao atualizar categoria.')));
    }
  }

  // Função para excluir categoria
  Future<void> _deleteCategory(int categoryId) async {
    try {
      await requestHttp.deleteCategory(categoryId);
      _loadCategories();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoria deletada com sucesso!')));
    } catch (e) {
      print('Erro ao excluir categoria: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao excluir categoria.')));
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Se o nome não foi editado, utiliza o valor atual
      final updatedNameToSend =
          _isEditingName ? _nameController.text : updatedName;

      // Se o sobrenome não foi editado, utiliza o valor atual
      final updatedLastNameToSend = _isEditingLastName
          ? _lastNameController.text
          : _lastNameController.text.isEmpty
              ? updatedName // Envia o nome se o sobrenome estiver vazio
              : _lastNameController.text;

      final response = await requestHttp.updateUser(
        name: updatedNameToSend,
        lastName: updatedLastNameToSend,
      );

      if (response.statusCode == 200) {
        setState(() {
          updatedName = _nameController.text; // Atualiza o nome na tela
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil atualizado com sucesso!')),
        );
      }
    } catch (error) {
      print('Erro ao atualizar perfil: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar perfil: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
        _isEditingName = false; // Desabilita a edição após salvar
        _isEditingLastName = false; // Desabilita a edição após salvar
      });
    }
  }

  // Exibe o Popup de Alteração de Senha
  void _showChangePasswordPopup(String email) {
    showDialog(
      context: context,
      builder: (context) => ChangePasswordPopup(
        email: email,
      ),
    );
    // print('Email change$email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                HeaderBasics(
                  userName: updatedName,
                  title: "Seu perfil, $updatedName",
                  subtitle: "Edite preferências pessoais",
                  imagePath: 'lib/assets/profile.png',
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Seção de nome e sobrenome (já existentes)
                          const SizedBox(height: 16),
                          _buildSectionTitle(
                            title:
                                'Fique à vontade para atualizar seus dados quando desejar!',
                          ),
                          const SizedBox(height: 8),
                          Divider(
                            color: Colors.grey[300],
                            thickness: 1,
                          ),
                          const SizedBox(height: 16),
                          // Campo de nome com ícone de edição
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: _nameController,
                                  label: "Seu nome: ${widget.userName}",
                                  focusNode: _nameFocusNode,
                                  enabled: _isEditingName,
                                  suffixIcon: null,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _isEditingName ? Icons.check : Icons.edit,
                                  color: const Color(0xFF738C61),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_isEditingName) {
                                      _updateProfile();
                                    } else {
                                      _isEditingName = true;
                                      FocusScope.of(context)
                                          .requestFocus(_nameFocusNode);
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Campo de sobrenome com ícone de edição
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: _lastNameController,
                                  label:
                                      'Sobrenome: ${_lastNameController.text}',
                                  focusNode: _lastNameFocusNode,
                                  enabled: _isEditingLastName,
                                  suffixIcon: null,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _isEditingLastName ? Icons.check : Icons.edit,
                                  color: const Color(0xFF738C61),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (_isEditingLastName) {
                                      _updateProfile();
                                    } else {
                                      _isEditingLastName = true;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Seção de categorias
                          _buildSectionTitle(
                            title:
                                'Gerencie suas categorias de forma simples e eficiente!',
                          ),
                          const SizedBox(height: 8),
                          Divider(
                            color: Colors.grey[300],
                            thickness: 1,
                          ),
                          _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFF003566)),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _categories.length,
                                  itemBuilder: (context, index) {
                                    final category = _categories[index];
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF0F0F0),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          category.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Color(0xFF738C61),
                                              ),
                                              onPressed: () =>
                                                  _showCategoryDialog(category),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Color(0xFF8C1C03),
                                              ),
                                              onPressed: () =>
                                                  _deleteCategory(category.id),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                          BtnOutlineGreen(
                            onPressed: () => _showCategoryDialog(),
                            text: 'Adicionar Categoria',
                            width: 100,
                          ),
                          const SizedBox(height: 32),

                          _buildSectionTitle(
                            title:
                                'Trocar sua senha de tempos em tempos é uma ótima maneira de garantir ainda mais segurança para sua conta!',
                          ),
                          const SizedBox(height: 8),
                          Divider(
                            color: Colors.grey[300],
                            thickness: 1,
                          ),
                          const SizedBox(height: 16),
                          const SizedBox(height: 8),
                          const Text(
                            'Dicas:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '1. Use uma senha forte com caracteres especiais.',
                            style: TextStyle(color: Colors.black),
                          ),
                          const Text(
                            '2. Não compartilhe sua senha com ninguém.',
                            style: TextStyle(color: Colors.black),
                          ),
                          const Text(
                            '3. Mantenha suas informações atualizadas.',
                            style: TextStyle(color: Colors.black),
                          ),
                          const Text(
                            '4. Nossa senha exige entre 8 e 12 caracteres.',
                            style: TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 16),

                          BtnOutlineGreen(
                            onPressed: () =>
                                _showChangePasswordPopup(widget.email),
                            text: 'Alterar Senha',
                            width: 100,
                          ),
                          const SizedBox(height: 32),
                          const SizedBox(height: 8),
                          Divider(
                            color: Colors.grey[300],
                            thickness: 2,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Deseja sair da sua conta?',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 16),
                              TextButton(
                                onPressed: () async {
                                  await _logout(context);

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(color: Colors.black),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.logout, color: Colors.black),
                                    SizedBox(width: 8),
                                    Text(
                                      'Logoff',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
                const Footer(backgroundColor: Color(0xFF738C61)),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Método para construir os títulos com bordas e sombras
  Widget _buildSectionTitle({required String title}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF738C61), // Cor de fundo
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
