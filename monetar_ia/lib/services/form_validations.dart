String? validateName(String? value) {
  final regex = RegExp(r"^[A-Za-zÀ-ÿ]+$");
  final numberRegex = RegExp(r"\d");

  if (value == null || value.isEmpty) {
    return 'Nome é obrigatório';
  }

  if (value.length < 3) {
    return 'Nome deve ter pelo menos 3 letras';
  }

  if (numberRegex.hasMatch(value)) {
    return 'Nome não pode conter números';
  }

  if (!regex.hasMatch(value)) {
    return 'Nome não pode conter caracteres especiais';
  }

  return null;
}

String? validateLastName(String? value) {
  final regex = RegExp(r"^[A-Za-zÀ-ÿ\s]{3,256}$");
  final specialCharRegex = RegExp(r'[^\w\s]');
  final numberRegex = RegExp(r'\d');
  final leadingTrailingSpacesRegex = RegExp(r'^\s|\s$');
  final multipleSpacesRegex = RegExp(r'\s{2,}');

  if (value == null || value.isEmpty) {
    return 'Sobrenome é obrigatório';
  }
  if (leadingTrailingSpacesRegex.hasMatch(value)) {
    return 'Quantidade de espaços indevida';
  }
  if (multipleSpacesRegex.hasMatch(value)) {
    return 'Quantidade de espaços indevida';
  }
  if (numberRegex.hasMatch(value)) {
    return 'Sobrenome não pode conter números';
  }
  if (specialCharRegex.hasMatch(value)) {
    return 'Sobrenome não pode conter caractere especial';
  }
  if (!regex.hasMatch(value)) {
    return 'Sobrenome deve ter pelo menos 3 letras';
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
    return 'Senha deve ter entre 8 e 12 caracteres';
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
