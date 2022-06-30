enum UiError {
  requiredFiel,
  invalidField,
  unexpected,
  invalidCredentials,
}

extension UiErrorExtension on UiError {
  String get description {
    switch (this) {
      case UiError.requiredFiel:
        return 'Campo obrigatório';
      case UiError.invalidField:
        return 'Campo inválido';
      case UiError.invalidCredentials:
        return 'Credenciais invalidas';
      default:
        return 'Algo errado aconteceu. Tente novamente em breve!';
    }
  }
}
