import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ClientSpy extends Mock implements Client {}

class httpAdapter {
  final Client client;

  httpAdapter(this.client);

  Future<void> request({
    @required String url,
    @required String methos,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    await client.post(url, headers: headers);
  }
}

void main() {
  group('post', () {
    test('Should call post with correct values', () async {
      final client = ClientSpy();
      final sut = httpAdapter(client);
      final url = faker.internet.httpUrl();

      await sut.request(url: url, methos: 'post');

      verify(client.post(
        url,
        headers: {
          'content-type': 'application/json',
          'accept': 'application/json'
        },
      ));
    });
  });
}
