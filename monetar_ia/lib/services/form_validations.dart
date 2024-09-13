// lib/services/form_validations.dart

String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Nome é obrigatório';
  }

  if (value.length < 3) {
    return 'Nome deve ter pelo menos 3 letras';
  }

  final regex = RegExp(r"^[A-Za-zÀ-ÿ]+$");
  if (!regex.hasMatch(value)) {
    return 'Nome não pode conter caracteres especiais';
  }

  return null;
}

String? validateSurname(String? value) {
  final regex = RegExp(r"^[a-zA-Z\s]{3,256}$");
  if (value == null || value.isEmpty) {
    return 'Sobrenome é obrigatório';
  }
  if (!regex.hasMatch(value)) {
    return 'Sobrenome deve ter entre 3 e 256 letras e espaços';
  }
  return null;
}

String? validateEmail(String? value) {
  final regex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
  if (value == null || value.isEmpty) {
    return 'E-mail é obrigatório';
  }
  if (!regex.hasMatch(value)) {
    return 'E-mail inválido';
  }
  return null;
}

String? validatePassword(String? value) {
  final regex = RegExp(r"^[a-zA-Z0-9!@#\$%^&*()_+]{8,12}$");
  if (value == null || value.isEmpty) {
    return 'Senha é obrigatória';
  }
  if (!regex.hasMatch(value)) {
    return 'Senha deve ter entre 8 e 12 caracteres e pode incluir letras, números e caracteres especiais';
  }
  return null;
}

String? validateConfirmPassword(String password, String? confirmPassword) {
  if (confirmPassword == null || confirmPassword.isEmpty) {
    return 'Confirmação de senha é obrigatória';
  }
  if (password != confirmPassword) {
    return 'Senhas não coincidem';
  }
  return null;
}
