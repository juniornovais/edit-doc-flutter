String? validarNome(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Informe seu nome completo';
  }
  return null;
}

String? validarEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Informe um e-mail válido';
  }
  final email = value.trim().toLowerCase();
  if (!email.contains('@') ||
      !(email.endsWith('.com') || email.endsWith('.com.br'))) {
    return 'O e-mail deve conter @ e terminar com .com ou .com.br';
  }
  return null;
}

String? validarSenha(String? value) {
  if (value == null || value.length < 6) {
    return 'A senha deve ter pelo menos 6 caracteres';
  }
  return null;
}
