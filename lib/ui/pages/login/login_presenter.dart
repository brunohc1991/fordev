import '../../helpers/erros/erros.dart';

abstract class LoginPresenter {
  Stream<UiError> get emailErrorStream;
  Stream<UiError> get passwordErrorStream;
  Stream<UiError> get mainErrorStream;
  Stream<bool> get isFormValidStream;
  Stream<bool> get isLoadingStream;
  Stream<String> get navigateToStream;

  void validateEmail(String email);
  void validatePassword(String email);
  Future<void> auth();
  void dispose();
}
