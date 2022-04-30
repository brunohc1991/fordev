Feature: Login
Como um cliente
Quero pode acessar minha conta e me manter logado
Para que eu possa ver e responder enquetes de forma rapida

Canério: Credenciais Validas
Dado que o cliente informou credenciais Validas
Quando solicitar para fazer Login entao o sistema deve enviar o usuário para a tela de pesquisa
e manter o usuario conectado

Canério: Credenciais Invalidas
Dado que o cliente informou credenciais invalidas
Quando solicitar para fazer Login
Então o sistema deve retornar uma mensagem de erro

