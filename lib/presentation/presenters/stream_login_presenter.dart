import 'dart:async';
import 'package:meta/meta.dart';
import '../protocols/validation.dart';

class LoginState {
  String emailError;
}

class StreamLoginPresenter {
  final Validation validation;
  final _controler = StreamController<LoginState>.broadcast();

  var _state = LoginState();

  Stream<String> get emailErrorStream =>
      _controler.stream.map((state) => state.emailError).distinct();

  StreamLoginPresenter({@required this.validation});

  void validateEmail(String email) {
    _state.emailError = validation.validate(field: 'email', value: email);
    _controler.add(_state);
  }
}
