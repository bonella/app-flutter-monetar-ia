import 'package:flutter/material.dart';
import 'package:monetar_ia/services/request_http.dart';
import 'package:monetar_ia/utils/form_validations.dart';
import 'package:monetar_ia/views/profile_page.dart';

class AddCategoryPopup extends StatefulWidget {
  final Function(String) onSave;

  const AddCategoryPopup({super.key, required this.onSave});

  @override
  _AddCategoryPopupState createState() => _AddCategoryPopupState();
}

class _AddCategoryPopupState extends State<AddCategoryPopup> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController categoryNameController = TextEditingController();
  final FocusNode categoryFocusNode = FocusNode();
  final RequestHttp _requestHttp = RequestHttp();

  @override
  void dispose() {
    categoryNameController.dispose();
    categoryFocusNode.dispose();
    super.dispose();
  }

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
              'Adicionar Categoria',
              style: TextStyle(color: Color(0xFF003566), fontSize: 20),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: _buildTextField(
              controller: categoryNameController,
              hint: "Nome da categoria",
              onChanged: (value) {},
              focusNode: categoryFocusNode,
              // validator: validateCategory,
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
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => const ProfilePage()),
                //   (Route<dynamic> route) => false,
                // );
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
                    final categoryName = categoryNameController.text.trim();
                    // await _requestHttp.createCategory(categoryName);
                    showSnackbar('Categoria salva com sucesso!');
                    Navigator.of(context).pop();
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => const ProfilePage()),
                    // );
                  } catch (error) {
                    showSnackbar(
                        'Erro ao salvar a categoria! Tente novamente mais tarde.');
                  }
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
    required ValueChanged<String> onChanged,
    required FocusNode focusNode,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      focusNode: focusNode,
      textInputAction: TextInputAction.done,
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
    );
  }
}
