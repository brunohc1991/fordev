import 'package:get/state_manager.dart';

import 'package:fordev/domain/helpers/domain_error.dart';
import 'package:fordev/ui/pages/login/login_presenter.dart';

import 'package:meta/meta.dart';

import '../../domain/usecases/usecases.dart';
import '../../ui/helpers/erros/erros.dart';
import '../protocols/validation.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String _email;
  String _password;
  var _emailError = Rx<UiError>();
  var _passwordError = Rx<UiError>();
  var _mainError = Rx<UiError>();
  var _navigateTo = RxString();
  var _isFormValid = false.obs;
  var _isLoading = false.obs;

  Stream<UiError> get emailErrorStream => _emailError.stream;
  Stream<UiError> get passwordErrorStream => _passwordError.stream;
  Stream<UiError> get mainErrorStream => _mainError.stream;
  Stream<String> get navigateToStream => _navigateTo.stream;
  Stream<bool> get isFormValidStream => _isFormValid.stream;
  Stream<bool> get isLoadingStream => _isLoading.stream;

  GetxLoginPresenter({
    @required this.validation,
    @required this.authentication,
    @required this.saveCurrentAccount,
  });

  void validateEmail(String email) {
    _email = email;
    _emailError.value = _validateFeld(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    _passwordError.value = _validateFeld(field: 'password', value: password);
    _validateForm();
  }

  void _validateForm() {
    _isFormValid.value = _emailError.value == null &&
        _passwordError.value == null &&
        _email != null &&
        _password != null;
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
    try {
      _isLoading.value = true;
      final account = await authentication
          .auth(AuthenticationParams(email: _email, secret: _password));
      print(account);
      await saveCurrentAccount.save(account);
      _navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          _mainError.value = UiError.invalidCredentials;
          break;
        default:
          _mainError.value = UiError.unexpected;
          break;
      }
      _isLoading.value = false;
    }
  }

  void dispose() {}
}
