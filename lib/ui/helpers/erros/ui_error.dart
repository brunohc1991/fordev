import '../helpers.dart';

enum UiError {
  requiredFiel,
  invalidField,
  unexpected,
  invalidCredentials,
  emailInUse,
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
      case UiError.emailInUse:
        return R.strings.emailInUse;
      default:
        return R.strings.defaultError;
    }
  }
}
