import 'dart:async';
import 'package:fordev/domain/helpers/domain_error.dart';
import 'package:fordev/ui/helpers/erros/ui_error.dart';
import 'package:fordev/ui/pages/login/login_presenter.dart';
import 'package:meta/meta.dart';
import '../../domain/usecases/usecases.dart';
import '../protocols/validation.dart';

class LoginState {
  String email;
  String password;
  UiError emailError;
  UiError passwordError;
  UiError mainError;
  String navigateTo;
  bool isLoading = false;

  bool get isFormValid =>
      emailError == null &&
      passwordError == null &&
      email != null &&
      password != null;
}

class StreamLoginPresenter implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  var _controller = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<UiError> get emailErrorStream =>
      _controller?.stream?.map((state) => state.emailError)?.distinct();

  Stream<UiError> get passwordErrorStream =>
      _controller?.stream?.map((state) => state.passwordError)?.distinct();

  Stream<UiError> get mainErrorStream =>
      _controller?.stream?.map((state) => state.mainError)?.distinct();

  Stream<bool> get isFormValidStream =>
      _controller?.stream?.map((state) => state.isFormValid)?.distinct();

  Stream<bool> get isLoadingStream =>
      _controller?.stream?.map((state) => state.isLoading)?.distinct();

  Stream<String> get navigateToStream =>
      _controller?.stream?.map((state) => state.navigateTo)?.distinct();

  StreamLoginPresenter(
      {@required this.validation, @required this.authentication});

  void _update() {
    _controller?.add(_state);
  }

  void validateEmail(String email) {
    _state.email = email;
    _state.emailError = _validateFeld(field: 'email', value: email);
    _update();
  }

  void validatePassword(String password) {
    _state.password = password;
    _state.passwordError = _validateFeld(field: 'password', value: password);
    _update();
  }

  UiError _validateFeld({String field, String value}) {
    final error = validation.validate(field: field, value: value);

    switch (error) {
      case ValidationError.invalidField:
        return UiError.invalidField;
        break;
      case ValidationError.requiredField:
        return UiError.requiredFiel;
        break;
      default:
        return null;
    }
  }

  Future<void> auth() async {
    _state.isLoading = true;
    _update();
    try {
      await authentication.auth(
          AuthenticationParams(email: _state.email, secret: _state.password));
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          _state.mainError = UiError.invalidCredentials;
          break;
        default:
          _state.mainError = UiError.unexpected;
          break;
      }
    }
    _state.isLoading = false;
    _update();
  }

  void dispose() {
    _controller?.close();
    _controller = null;
  }
}
