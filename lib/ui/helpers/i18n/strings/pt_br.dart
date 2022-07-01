import 'strings.dart';

class PtBr implements Translations {
  @override
  String get addAccount => 'Criar conta';

  @override
  String get defaultError => "Algo errado aconteceu. Tente novamente em breve!";

  @override
  String get email => "E-mail";

  @override
  String get logIn => "Entrar";

  @override
  String get invalidCredentials => 'Credenciais inválidas';

  @override
  String get invalidField => 'Campo inválido';

  @override
  String get password => "Senha";

  @override
  String get requiredField => 'Campo obrigatório';
}
