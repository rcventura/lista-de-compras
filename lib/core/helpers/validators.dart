class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Campo obrigatório.';
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(value.trim())) return 'E-mail inválido.';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Campo obrigatória.';
    if (value.length < 6) return 'Mínimo 6 caracteres.';
    return null;
  }

  static String? required(String? value, {String label = 'Campo'}) {
    if (value == null || value.trim().isEmpty) return '$label obrigatório.';
    return null;
  }
}
