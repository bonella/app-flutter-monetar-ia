import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  // Salva o token
  Future<void> saveToken(String token) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      print("Token salvo: $token");
    } catch (e) {
      print("Erro ao salvar o token: $e");
    }
  }

  // Obtém o token
  Future<String?> getToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      print("Token recuperado: $token"); // Print para o token recuperado
      return token;
    } catch (e) {
      print("Erro ao obter o token: $e");
      return null;
    }
  }

  // Limpa o token
  Future<void> clearToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      print("Token limpo."); // Print após limpar
    } catch (e) {
      print("Erro ao limpar o token: $e");
    }
  }

  // Verifica se o token é válido
  Future<bool> isTokenValid() async {
    final token = await getToken();
    final isValid = token != null;
    print("Token é válido? $isValid"); // Print sobre a validade do token
    return isValid;
  }

  // Método opcional para exibir o token (útil para debugging)
  Future<void> printToken() async {
    final token = await getToken();
    print("Token atual: $token");
  }
}
