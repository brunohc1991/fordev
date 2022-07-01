import '../helpers.dart';

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
        return R.strings.requiredField;
      case UiError.invalidField:
        return R.strings.invalidField;
      case UiError.invalidCredentials:
        return R.strings.invalidCredentials;
      default:
        return R.strings.defaultError;
    }
  }
}
