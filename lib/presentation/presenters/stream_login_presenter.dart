import 'dart:async';
import 'package:meta/meta.dart';
import '../protocols/validation.dart';

class LoginState {
  String emailError;
  String passwordError;

  bool get isFormValid => false;
}

class StreamLoginPresenter {
  final Validation validation;
  final _controler = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<String> get emailErrorStream =>
      _controler.stream.map((state) => state.emailError).distinct();

  Stream<bool> get isFormValidStream =>
      _controler.stream.map((state) => state.isFormValid).distinct();

  Stream<String> get passwordErrorStream =>
      _controler.stream.map((state) => state.passwordError).distinct();

  StreamLoginPresenter({@required this.validation});

  void _update() {
    _controler.add(_state);
  }

  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _update();
  }

  void validatePassword(String password) {
    _state.passwordError =
        validation.validate(field: 'password', value: password);
    _update();
  }
}
